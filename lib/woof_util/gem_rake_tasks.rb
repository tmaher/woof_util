module WoofUtil
  module GemRakeTasks
    include Rake::DSL
    extend self
    
    def read_gem_version
      begin
        File.read("VERSION").chomp
      rescue Errno::ENOENT
        "0.0.0"
      end
    end

    def bump_version vtype=((ENV["bump_type"] || :patch).to_sym)
      v = {}
      vstring = read_gem_version
      puts "old: #{vstring}"
      v[:major], v[:minor], v[:patch] = vstring.split "."
      v[vtype] = (v[vtype].to_i + 1).to_s
      vstring = [v[:major], v[:minor], v[:patch]].join "."
      
      stashdata = `git stash save versionbump_#{vstring}`
      $stdout.write stashdata
      
      File.write "VERSION", "#{vstring}\n"
      system "git add VERSION"
      system "git commit -m versionbump_to_#{vstring}"
      system "git stash pop" unless stashdata =~ /No local changes to save/
      puts "new: #{vstring}"
      vstring
    end

    def rubygems_logout
      begin
        File.unlink "#{ENV["HOME"]}/.gem/credentials"
      rescue Errno::ENOENT
      end
    end

    def rubygems_login
      rubygems_logout

      user = ask("Rubygems username: ")
      pw = ask("Password: ") { |q| q.echo = false }

      resp = Excon.get "https://#{user}:#{pw}@rubygems.org/api/v1/api_key.yaml"
      raise "login fail #{resp.status}" unless resp.status == 200
      File.umask(0077)
      File.write "#{ENV["HOME"]}/.gem/credentials", resp.body
    end

    def push_to_github
      system "git push github master"
    end

    def hello
      puts "hello world"
    end

    def gemspec_file_name
      raise "cwd needs exactly 1 gemspec" if Dir.glob("*.gemspec").length != 1
      Dir.glob("*.gemspec")[0]
    end
    
    def gemname
      eval(File.read gemspec_file_name).name
    end

    def build_the_gem
      begin ; File.unlink gem_file_name
      rescue Errno::ENOENT ; end
      system "gem build #{gemspec_file_name}"
      raise "can't build gem" unless File.exists gem_file_name
    end

    def gem_file_name
      "#{gemname}-#{version}.gem"
    end

    def push_to_rubygems
      build_the_gem
      system "gem push #{gem_file_name}"
    end

    def create_tasks
      namespace :gem do
        [:rubygems_login, :rubygems_logout,
         :bump_version, :push_to_github,
         :build_the_gem, :push_to_rubygems, :hello].each do |tname|
          Rake::Task.define_task tname do
            send tname
          end
        end
        task :pushify => [:bump_version, :push_to_github,
                          :build_the_gem, :push_to_rubygems] do
        end
      end
    end
    
  end
end
