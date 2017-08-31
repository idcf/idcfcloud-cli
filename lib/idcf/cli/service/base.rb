module Idcf
  module Cli
    module Service
      # model base
      class Base
        ARG_TYPE_REQ   = :req
        ARG_TYPE_OPT   = :opt
        ARG_TYPE_REST  = :rest
        ARG_TYPE_BLOCK = :block
        class << self
          attr_reader :options, :params
          # option
          #
          # @param name [String]
          # @param attr [Hash]
          # @option attr [String] :type
          # @option attr [Boolean] :required
          # @option attr [String] :desc
          def option(name, *attr)
            @options ||= {}
            @options[name] = attr
          end

          # params
          #
          # @param values [String]
          # @param arg_type [String]
          def param(name, arg_type = ARG_TYPE_REQ)
            @params ||= []
            s = @params.select do |v|
              v[:name] == name
            end

            param = {
              name:     name,
              arg_type: arg_type
            }

            @params << param if s.size.zero?
          end
        end

        # do
        #
        # @param _client [Mixed]
        # @param *_args [Array]
        # @param _o [Hash] options
        # @return Hash
        # @raise
        def do(_client, *_args, _o)
          raise Idcf::Cli::CliError, 'Require override'
        end
      end
    end
  end
end
