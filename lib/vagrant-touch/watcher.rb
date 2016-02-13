require "vagrant/action/builtin/mixin_synced_folders"
require 'socket'
require 'byebug'
require 'listen'

module Vagrant
  module Touch
    class Watcher
      include Vagrant::Action::Builtin::MixinSyncedFolders

      def self.run(env)
        watcher = self.new(env)
        watcher.log
        watcher.run
      end

      def initialize(env)
        @logger       = env[:ui]
        @id           = env[:machine].id
        @machine_name = env[:machine].name
        @provider     = env[:machine].provider_name
        @ip           = env[:touch_data][:guest_ip]
        @port         = env[:machine].config.touch.port
        @folder_mappings = build_folder_mappings(env)
      end

      def build_folder_mappings(env)
        # TODO find a way to use cached: true
        synced_folders(env[:machine]).map{ |impl_name, fs|
          fs.map{ |id,data| data } if (impl_name == :nfs)
        }.compact.flatten(1).group_by{ |k| k[:hostpath] }.map{ |hostpath,datas|
          [hostpath, datas.map{|d| d[:guestpath]}]
        }.to_h
      end

      def run
        pid = Process.fork
        if pid.nil? then
          $0 = "vagrant-touch-daemon"

          listeners = @folder_mappings.map{ |s,ts| create_listener(s,ts) }
          listeners.each( &:start )

          sleep

        else Process.detach(pid)
        end
        pid
      end

      def log
        formatted = lambda do |k,v|
          "#{k} -> #{v}"
        end

        @logger.info("[vagrant-touch] host daemon starting:")
        @logger.detail(" - port:     #{@port}")
        @logger.detail(" - guest ip: #{@ip}")

        if @folder_mappings.size > 1
          @logger.detail(" - folders:")
          @folder_mappings.each do |k,v|
            @logger.detail("\t#{formatted(k,v)}")
          end
        else
          str = @folder_mappings.map(&formatted)[0] || "none"
          @logger.detail(" - folders:  #{str}")
        end


      end

      def create_listener(source, targets)
        Listen.to(source) do |modified, added, removed|
          args = targets.join("\n")
          send_message( targets.join("\n") )
        end
      end


      def get_source_folders(files)

      end

      def send_message(msg, retries = 3)
        begin
          Socket.tcp(@ip, @port) {|sock|
            sock.puts msg
            sock.close_write
          }
        rescue => a
          sleep 0.1
          send_message(msg, retries - 1) if (retries > 0)
        end
      end
    end
  end
end
