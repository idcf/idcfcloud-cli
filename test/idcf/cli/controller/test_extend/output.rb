module Idcf
  module Cli
    module Controller
      module TestExtend
        # test code utils
        module Output
          protected

          # skip info
          #
          # @param msg [String]
          def output_skip_info(msg)
            info = caller.first.split('/').pop(3).join('/')
            puts format("\nskip: %s \nmsg: %s", info, msg)
          end
        end
      end
    end
  end
end
