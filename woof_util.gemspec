Gem::Specification.new do |s|
  s.name = 'woof_util'
  s.version = File.read("VERSION").chomp
  s.date = '2012-11-15'
  s.summary = 'woof'
  s.description = 'catchment basin for misc crap'
  s.authors = ["Tom Maher"]
  s.email = "tmaher@tursom.org"
  s.files = `git ls-files`.split("\n")
  s.add_dependency "excon", "~> 0.16.10"
  s.add_dependency "highline", "~> 1.6.15"
  s.homepage = "https://github.com/tmaher/woofutil"
end

