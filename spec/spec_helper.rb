$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'bundler'
Bundler.require(:development)

require 'pretty_time'
require 'active_support'
require 'active_support/core_ext/numeric'

RSpec.configure do |config|
end
