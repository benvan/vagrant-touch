module Vagrant
  module Touch
    module Action
      class ListenerIsRunning
        def initialize(app, env)
          @app    = app
          @logger = env[:ui]
        end

        def call(env)
          pid = env[:touch_data][:listener_pid]
          if pid
            begin
              result = env[:machine].communicate.execute("ps #{pid}")
              # TODO
              puts "RESULT #result}"
            rescue => e
              puts e
            end
            env[:result] = result == 0
          else
            env[:result] = false
          end

          @app.call env
        end

      end
    end
  end
end
