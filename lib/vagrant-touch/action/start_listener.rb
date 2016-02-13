module Vagrant
  module Touch
    module Action





      class StartListener
        def initialize(app, env)
          @app = app
          @logger = env[:ui]
        end

        def call(env)
          port = env[:machine].config.touch.port
          ip = env[:touch_data][:guest_ip]

          toucher_command = "while true; do nc -l #{port} | xargs touch; done"
          full_command    = "nohup sh -c \'#{toucher_command}\' & echo $!"

          env[:machine].communicate.execute(full_command) do |type,data|
            env[:touch_data][:listener_pid] = data[/\d+$/].to_i
          end

          pid = env[:touch_data][:listener_pid]
          @logger.info("[vagrant-touch] guest daemon started {port: #{port}, pid: #{pid}}")

          @app.call env
        end




      end




    end
  end
end
