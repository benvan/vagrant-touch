module Vagrant
  module Touch
    module Action
      class WatcherIsRunning
        def initialize(app, env)
          @app    = app
          @logger = env[:ui]
        end

        def call(env)
          pid = env[:touch_data][:watcher_pid]
          result = valid_process?(pid)
          env[:result] = !!result
          @app.call env
        end

        private

        def valid_process?(pid)
          Process.getpgid(pid.to_i) if pid
        rescue Errno::ESRCH
          false
        end
      end
    end
  end
end
