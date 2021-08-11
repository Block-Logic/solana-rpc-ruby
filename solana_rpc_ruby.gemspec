# frozen_string_literal: true

require_relative 'lib/solana_rpc_ruby/version'

Gem::Specification.new do |spec|
  spec.name                  = 'solana_rpc_ruby'
  spec.version               = SolanaRpcRuby::VERSION
  spec.authors               = ['Block Logic Team']
  spec.email                 = ['email@example.com']
  spec.summary               = 'Ruby wrapper for solana JSON RPC API.'
  spec.description           = 'This gem allows to use JSON RPC API from solana.'
  spec.homepage              = 'https://github.com/Block-Logic/solana-rpc-ruby'
  spec.license               = 'MIT'
  spec.platform              = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.6.5'
  spec.files = Dir[
    'README.md', 'LICENSE', 'CHANGELOG.md',
    'lib/**/*.rb',
    'lib/**/*.rake',
    'solana_rpc_ruby.gemspec',
    '.github/*.md',
    'Gemfile',
    'Rakefile'
  ]
  spec.extra_rdoc_files = ['README.md']
  spec.metadata= {
    'documentation_uri' => 'https://www.rubydoc.info/github/Block-Logic/solana-rpc-ruby',
    'source_code_uri' => 'https://github.com/Block-Logic/solana-rpc-ruby'
  }

  spec.add_dependency 'faye-websocket', '~> 0.11'

  spec.add_development_dependency 'rubocop', '~> 1.15'
  spec.add_development_dependency 'rubocop-performance', '~> 1.11'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.3'
  spec.add_development_dependency 'pry', '~> 0.14'

  spec.add_development_dependency 'codecov', '~> 0.4'
  spec.add_development_dependency 'dotenv', '~> 2.7'
  spec.add_development_dependency 'rails', '~> 6.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'rspec-rails', '~> 4.0'
  spec.add_development_dependency 'simplecov', '~> 0.21'
  spec.add_development_dependency 'vcr', '~> 6.0'
  spec.add_development_dependency 'webmock', '~> 3.13'
end
