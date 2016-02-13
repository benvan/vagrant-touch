
begin
  require "vagrant"
rescue LoadError
  raise "The vagrant-touch plugin must be run within Vagrant."
end

module Vagrant
  module Touch



   class Plugin < Vagrant.plugin("2")
      name "vagrant-touch"
      description ="Triggers FS events in synced_folder to overcome poor VirtualBox nfs+libnotify support"

      config :touch do
        require_relative "./config"
        Config
      end

      start_server_hook = lambda do |hook|
        require_relative './action'
        hook.after Vagrant::Action::Builtin::WaitForCommunicator, Vagrant::Touch::Action.action_setup_touch
      end

      action_hook :start_server_on_up,     :machine_action_up, &start_server_hook
      action_hook :start_server_on_reload, :machine_action_reload, &start_server_hook

      action_hook :stop_server_on_halt, :machine_action_halt do |hook|
        require_relative './action'
        hook.before Vagrant::Action::Builtin::GracefulHalt, Vagrant::Touch::Action.action_teardown_touch
      end

      action_hook :stop_server_on_destroy, :machine_action_destroy do |hook|
        require_relative './action'
        hook.before VagrantPlugins::ProviderVirtualBox::Action::Destroy, Vagrant::Touch::Action.action_teardown_touch
      end

    end

  end
end
