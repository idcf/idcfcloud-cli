module Idcf
  module Cli
    module Controller
      module Include
        # util
        module Util
          protected

          # make result string
          #
          # @param data [Hash]
          # @param err_f [Boolean]
          # @param o [Hash]
          # @return Stirng
          def make_result_str(data, o)
            message = data.class == Hash ? data[:message] : {}
            f       = output_format(o, message)
            Idcf::Cli::Lib::Convert::Helper.new.format(data, f)
          end

          # output format
          #
          # @param o [Hash] options
          # @param message [Hash] Validate Hash
          # @return String
          def output_format(o, message)
            default_output = Idcf::Cli::Lib::Configure.get_code_conf('output', o)
            return default_output if message.class == Hash && !message[:output].nil?

            f = o[:output]
            f.nil? ? default_output : f
          end

          # cli error
          #
          # @param msg [Strring]
          # @raise
          def cli_error(msg)
            raise Idcf::Cli::Error::CliError, msg
          end

          # make response base data
          #
          # @return Hash
          def make_base_response
            {
              status:  200,
              message: '',
              data:    []
            }
          end
        end
      end
    end
  end
end
