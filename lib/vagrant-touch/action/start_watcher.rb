require_relative '../watcher'


module Vagrant
  module Touch
    module Action
      class StartWatcher

        def initialize(app, env)
          @app = app
          @logger = env[:ui]
        end

        def call(env)
          @app.call env

          pid = Watcher.run(env)
          env[:touch_data][:watcher_pid] = pid

        end
      end

    end
  end
end
