require 'excon'
require "highline/import"

def read_version
  File.read("VERSION").chomp
end

def bump_version vtype=:patch
  v = {}
  v[:major], v[:minor], v[:patch] = read_version.split '.'
  v[vtype] = (v[vtype].to_i + 1).to_s
    
  vstring = [v[:major], v[:minor], v[:patch]].join "."

  system "git stash save versionbump_#{vstring}"
  File.write "VERSION", "#{vstring}\n"
  system "git add VERSION"
  system "git commit -m versionbump_to_#{vstring}"
  system "git stash pop"
  vstring
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

def rubygems_logout
  begin
    File.unlink "#{ENV["HOME"]}/.gem/credentials"
  rescue Errno::ENOENT
  end
end

namespace :gem do
  task :login do
    rubygems_login
  end
  task :logout do
    rubygems_logout
  end

  task :bump_version do
    bump_version (ENV['name'] || :patch).to_sym
  end

end
