require_relative 'action/listener_is_running'
require_relative 'action/watcher_is_running'
require_relative 'action/start_listener'
require_relative 'action/stop_listener'
require_relative 'action/start_watcher'
require_relative 'action/stop_watcher'
require_relative 'action/prepare_data'
require_relative 'action/initialise_data'
require_relative 'action/notifications'

module Vagrant
  module Touch
    module Action
      class << self
        Call = Vagrant::Action::Builtin::Call

        def action_setup_touch
          Vagrant::Action::Builder.new.tap do |b|

            b.use PrepareData
            b.use InitialiseData
            b.use Call, ListenerIsRunning do |env2, b2|
              if env2[:result]
                b2.use NotifyListenerRunning
              else
                b2.use StartListener
              end
            end

            b.use Call, WatcherIsRunning do |env2, b2|
              if env2[:result]
                b2.use NotifyWatcherRunning
              else
                b2.use StartWatcher
              end
            end
          end

        end

        def action_teardown_touch
          Vagrant::Action::Builder.new.tap do |b|

            b.use PrepareData
            b.use Call, ListenerIsRunning do |env2, b2|
              b2.use StopListener if env2[:result]
            end

            b.use Call, WatcherIsRunning do |env2, b2|
              b2.use StopWatcher if env2[:result]
            end

          end
        end
      end
    end
  end
end
