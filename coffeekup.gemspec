# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "coffeekup/version"

Gem::Specification.new do |s|
  s.name        = "coffeekup_rails"
  s.version     = Coffeekup::VERSION
  s.authors     = ["Chris McCord"]
  s.email       = ["chris@chrismccord.com"]
  s.homepage    = ""
  s.summary     = %q{Asset pipeline engine/preprocessor for CoffeeKup template files}
  s.description = %q{CoffeeKup Rails is an asset pipeline engine/preprocessor for CoffeeKup template files.}

  s.rubyforge_project = "coffeekup_rails"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
