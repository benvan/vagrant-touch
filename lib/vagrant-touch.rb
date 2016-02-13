require 'bundler'

begin
  require 'vagrant'
rescue LoadError
  Bundler.require(:default, :development)
end

require 'vagrant-touch/plugin'
require 'vagrant-touch/command'
