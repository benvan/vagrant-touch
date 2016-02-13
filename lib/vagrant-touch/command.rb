module Vagrant
    module Touch
        class Command < Vagrant.plugin('2', :command)
            def execute
                exec('echo hello there')
                0
            end
        end
    end

end
