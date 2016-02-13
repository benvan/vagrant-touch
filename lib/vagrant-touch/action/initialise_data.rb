require_relative '../data'
require 'byebug'

module Vagrant
  module Touch
    module Action
      class InitialiseData
        def initialize(app, env)
          @app    = app
          # TODO
          @logger = Log4r::Logger.new("vagrant::touch::action::prepare_data")
        end

        def call(env)
          env[:touch_data][:guest_ip] = getFirstIp(env)
          @app.call env
        end

        private

        def getFirstIp(env)
          ips = []
          env[:machine].config.vm.networks.each do |network|
            key, options = network[0], network[1]
            ip = options[:ip]
            if (ip)
              if (key == :private_network)
                ips.unshift(options[:ip])
              elsif (key == :public_network)
                ips.push(options[:ip])
              end
            end
          end
          return ips[0]
        end

      end
    end
  end
end
