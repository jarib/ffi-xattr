# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ffi-xattr/version"

Gem::Specification.new do |s|
  s.name        = "ffi-xattr"
  s.version     = Xattr::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jari Bakken"]
  s.email       = ["jari.bakken@gmail.com"]
  s.homepage    = "http://github.com/jarib/ffi-xattr"
  s.summary     = %q{Manipulate extended file attributes}
  s.description = %q{Manipulate extended file attributes}

  s.rubyforge_project = "ffi-xattr"

  s.add_development_dependency "rspec", "~> 2.5"
  s.add_dependency "ffi"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
