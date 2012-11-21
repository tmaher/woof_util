require 'excon'
require "highline/import"
require "./lib/woof_util/gemhelp"

include WoofUtil::Gemhelp
#WoofUtil::Gemhelp.create_tasks

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
    build_the_gem
  end

  task :rubygems do
    system "gem push #{gemname}-#{read_version}.gem"
  end
  
  task :pushify => [:bump_version, :github, :build, :rubygems] do
  end

  task :hello do
    hello
  end

  task :name do
    puts gemname
    puts Rake.application.tasks[0]
    puts Rake.application.tasks[0].actions.map(&:source_location)
  end
  
end
