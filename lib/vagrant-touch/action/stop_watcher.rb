module Vagrant
   module Touch
      module Action
        class StopWatcher

          def initialize(app, env)
            @app = app
            @logger = env[:ui]
          end

          def call(env)

            pid = env[:touch_data][:watcher_pid]

            Process.kill('KILL', pid.to_i) rescue nil

            @logger.info("[vagrant-touch] terminated host daemon {pid:#{pid}}")
            env[:touch_data][:watcher_pid]  = nil

            @app.call env
          end
        end

      end
    end
end
