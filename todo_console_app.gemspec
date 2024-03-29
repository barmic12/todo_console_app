
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "todo_console_app/version"

Gem::Specification.new do |spec|
  spec.name          = "todo_console_app"
  spec.version       = TodoConsoleApp::VERSION
  spec.authors       = ["Bartosz Michalak"]
  spec.email         = ["barmic12@gmail.com"]

  spec.summary       = "Simple app to manage your tasks."
  spec.description   = "Application provides simple interface to manage you tasks using list."
  spec.homepage      = "https://github.com/barmic12/todo_console_app"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "sequel"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "database_cleaner"
  spec.add_development_dependency "cli-ui"
end
