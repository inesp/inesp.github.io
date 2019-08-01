# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "ines-theme"
  spec.version       = "0.1.0"
  spec.authors       = ["Ines Panker"]
  spec.email         = ["ines.panker@gmail.com"]

  spec.summary       = "Simple blog theme"
  spec.homepage      = "https://github.com/inesp/inesp.github.io"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_layouts|_includes|_sass|LICENSE|README)!i) }

  spec.add_runtime_dependency "jekyll", "~> 3.8"
  spec.add_runtime_dependency "jekyll-feed", "~> 0.9"
  spec.add_runtime_dependency "jekyll-seo-tag", "~> 2.1"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 12.0"
end
