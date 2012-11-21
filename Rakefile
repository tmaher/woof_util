require 'excon'
require "highline/import"
require "./lib/woof_util/gemhelp"

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

  task :github do
    push_to_github
  end

  task :build do
    system "gem build woof_util.gemspec"
  end

  task :rubygems do
    system "gem push woof_util-#{read_version}.gem"
  end
  
  task :pushify => [:bump_version, :github, :build, :rubygems] do
  end

  task :hello do
    hello
  end

  task :name do
    puts gemname
  end
  
end
