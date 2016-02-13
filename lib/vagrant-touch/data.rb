module Vagrant
  module Touch
    class Data
      def initialize(data_dir)
        @data_dir = data_dir
      end

      def []=(key, value)
        file = @data_dir.join(key.to_s)
        if value.nil? && file.exist?
          file.delete
        else
          file.open("w+") { |f| f.write(value) }
        end
      end

      def [](key)
        file = @data_dir.join(key.to_s)
        file.read if file.file?
      end
    end
  end
end
