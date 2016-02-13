module Vagrant
   module Touch
      module Action
        class StopListener

          def initialize(app, env)
            @app = app
            @logger = env[:ui]
          end

          def call(env)

            port = env[:machine].config.touch.port
            pid = env[:touch_data][:listener_pid]
            env[:machine].communicate.execute("kill #{pid}")

            @logger.info("[vagrant-touch] terminated guest daemon {port:#{port}, pid:#{pid}}")

            env[:touch_data][:listener_pid]  = nil
            env[:touch_data][:listener_port] = nil

            @app.call env
          end
        end

      end
    end
end
