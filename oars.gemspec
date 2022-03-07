# frozen_string_literal: true

require_relative "lib/oars/version"

Gem::Specification.new do |spec|
  spec.name          = "oars"
  spec.version       = Oars::VERSION
  spec.authors       = ["Connor Andrew Ngo"]
  spec.email         = ["connor.ngo@noaa.gov"]

  spec.summary       = "Open API RESTful Solution"
  spec.description   = "Open API RESTful Solution"
  spec.homepage      = "https://github.com/CNgo0/OARS_Ruby"
  spec.license       = "https://github.com/CNgo0/OARS_Ruby/LICENSE.txt"
  spec.required_ruby_version = ">= 2.4.0"

  #spec.metadata["allowed_push_host"] = "TODO: Set to 'https://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/CNgo0/OARS_Ruby"
  spec.metadata["changelog_uri"] = "https://github.com/CNgo0/OARS_Ruby/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
