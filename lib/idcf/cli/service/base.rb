require 'idcf/cli/lib/include/recurring_calling'
module Idcf
  module Cli
    module Service
      # model base
      class Base
        ARG_TYPE_REQ  = :req
        ARG_TYPE_OPT  = :opt
        ARG_TYPE_REST = :rest
        HELP_FORMAT   = {
          ARG_TYPE_REQ  => '<%s>',
          ARG_TYPE_OPT  => '[%s]',
          ARG_TYPE_REST => '[%s ...]'
        }.freeze
        attr_reader :last_command, :last_command_args
        include Idcf::Cli::Lib::Include::RecurringCalling

        class << self
          attr_reader :options

          # reset
          # setting reset
          def reset
            @options = {}
          end

          # option
          #
          # @param name [String]
          # @param attr [Hash]
          # @option attr [String] :type
          # @option attr [Boolean] :required
          # @option attr [String] :desc
          def option(name, attr)
            @options ||= {}
            @options[name] = attr
          end

          # descritpion
          #
          # @return String
          def description
            ''
          end

          # make param string
          #
          # @return String
          def make_param_s
            cp = []
            valid_params.each do |param|
              f = HELP_FORMAT[param[0]]
              next if f.nil?
              cp << format(f, param[1])
            end
            cp.join(' ')
          end

          def valid_params
            [].tap do |result|
              new.method(:do).parameters.each do |param|
                result << param if target_param?(param[1])
              end
            end
          end

          protected

          # target param?
          #
          # @param name [String]
          # @return Boolean
          def target_param?(name)
            val            = name.to_s
            exclusion_list = %w(api o)
            return false if exclusion_list.include?(val)
            return false if val[0] == '_'
            true
          end
        end

        def initialize
          @last_command      = ''
          @last_command_args = []
        end

        # do
        #
        # @param _client [Mixed]
        # @param _o [Hash] options
        # @param *_args [Array]
        # @return Hash
        # @raise
        def do(_client, _o, *_args)
          cli_error 'Require override'
        end

        # between params
        #
        # @param params [Array]
        # @param arg_size [int]
        # @raise
        def between_param?(arg_size)
          param = self.class.valid_params
          p_cnt = param.size
          return true if method_rest?(param)
          opt_cnt = method_option_cnt(param)

          min = p_cnt - opt_cnt
          msg = format('Argument: %s', self.class.make_param_s)
          cli_error msg unless arg_size.between?(min, p_cnt)
          true
        end

        # is rest
        #
        # @param params [Array]
        # @return Boolean
        def method_rest?(params)
          return false if params.nil?
          params.each do |param|
            case param[0]
            when ARG_TYPE_REST
              return true
            end
          end
          false
        end

        # option count
        #
        # @param params [Array]
        # @return int
        def method_option_cnt(params)
          result = 0
          return result if params.nil?
          params.each do |param|
            case param[0]
            when ARG_TYPE_OPT
              result += 1
            end
          end
          result
        end

        # cli error
        #
        # @param msg [String]
        # @raise
        def cli_error(msg)
          raise Idcf::Cli::Error::CliError, msg
        end
      end
    end
  end
end
