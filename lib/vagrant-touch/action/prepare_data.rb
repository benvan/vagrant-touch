require_relative '../data'

module Vagrant
  module Touch
    module Action
      class PrepareData
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant::touch::action::prepare_data")
        end

        def call(env)
          @env      = env
          @data_dir = @env[:machine].data_dir.join('vagrant-touch')

          ensure_dir_exists
          assign_data_object

          @app.call env
        end

        private

        def ensure_dir_exists
          return if @data_dir.directory?

          @logger.debug 'Creating data directory'
          @data_dir.mkdir
        end

        def assign_data_object
          return if @env[:touch_data]

          @logger.debug 'Assigning data object'
          @env[:touch_data] = Data.new(@data_dir)
        end
      end
    end
  end
end
