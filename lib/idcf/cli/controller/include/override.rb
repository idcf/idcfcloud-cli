module Idcf
  module Cli
    module Controller
      module Include
        # override methods
        module Override
          protected

          # Create a new client
          #
          # @param _o [Hash] other options
          # @return [Response] Mixed
          def make_client(_o)
            raise Idcf::Cli::CliError, 'Required override'
          end

          # sdk do
          #
          # @param _command [String]
          # @param *_args [Array]
          # @param o [Hash] options
          # @return String
          def do_sdk(_command, *_args, _o)
            raise Idcf::Cli::CliError, 'Requre override'
          end
        end
      end
    end
  end
end
