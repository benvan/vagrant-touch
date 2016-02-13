module Vagrant
   module Touch
      module Action

        class Base
          def initialize(app, env)
            @app = app
            @logger = env[:ui]
          end

          def call(env)
            @app.call env
          end
        end

        class NotifyWatcherRunning < Base
          def notify
            pid = env[:touch_data][:watcher_pid]
            @logger.info("[vagrant-touch] host daemon already running {pid:#{pid}}")
          end
        end

        class NotifyListenerRunning < Base
          def notify
            port = env[:machine].config.touch.port
            pid = env[:touch_data][:listener_pid]
            @logger.info("[vagrant-touch] guest daemon already running {pid:#{pid}, port:#{port}}")
          end
        end

      end
    end
end
