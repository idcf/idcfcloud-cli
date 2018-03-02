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
            info = caller(1..1).first.split('/').pop(3).join('/')
            puts format("\nskip: %<info>s \nmsg: %<msg>s", info: info, msg: msg)
          end
        end
      end
    end
  end
end
