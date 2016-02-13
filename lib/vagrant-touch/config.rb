require "vagrant"

module Vagrant
  module Touch

    class Config < Vagrant.plugin(2, :config)
      attr_accessor :port

      def initialize
        @port = UNSET_VALUE
      end

      def finalize!
        @port = 9147 if @port == UNSET_VALUE
      end

    end
  end
end
