require 'vcr'
VCR.configure do |c|
  c.cassette_library_dir = File.join(File.dirname(__FILE__), '..', 'fixtures', 'vcr_cassettes')
  c.hook_into :webmock
  #  c.filter_sensitive_data('<TOKEN>') { ENV.fetch('') }
  c.configure_rspec_metadata!
end