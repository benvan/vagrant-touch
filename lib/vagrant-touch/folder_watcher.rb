module Vagrant
  module Touch

    class DefaultAdapter
      listeners = []
      def watch(source,&block)
        listeners += Listen.to(source,block)
      end

      def start
        listeners.each(&:start)
      end

    end

    # guard/listen is too slow. Use native fsevent instead
    class MacAdapter
      def initialize
        @fse = FSEvent.new
      end

      def watch(source,&block)
        options = {:latency => 0.5, :no_defer => true }
        @fse.watch source, options, block
      end
    end


    class FolderWatcher
      def self.adapt
        if RbConfig::CONFIG['target_os'] =~ /darwin/i
          MacAdapter.new
        else
          DefaultAdapter.new
        end
      end

      def watch(folder, &block)
      end

    end
  end
end
