require 'idcf/cli/conf/const'
module Idcf
  module Cli
    module Controller
      module Include
        # command
        module Command
          include Comparable

          protected

          def convert_arg_json(*args)
            result = []
            args.each do |v|
              begin
                result << JSON.parse(v, symbolize_names: true)
              rescue
                result << v
              end
            end
            result
          end

          # check params
          #
          # @param mcs [Array] module classes
          # @option mcs [Object] not namespace class name => model class object
          # @param command [String]
          # @param *args [Array]
          # @raise
          def check_params(mcs, command, *args)
            m_class = nil
            mcs.each do |k, v|
              m_class = v if k == command.to_s
            end
            if m_class.nil?
              settings = load_command_setting(command)
              between_param?(settings[:params], args.size)
            else
              between_param?(m_class.params, args.size)
            end
          end

          def load_command_setting(command)
            fn   = self.class.to_s.underscore.split('/').pop
            cm   = command.to_sym
            dir  = Idcf::Cli::Conf::Const::CMD_FILE_DIR
            ext  = Idcf::Cli::Conf::Const::CMD_FILE_EXT
            path = "#{dir}/#{fn}.#{ext}"
            Idcf::Cli::Lib::Util::YmlConf.new(path).find(cm)
          end

          # between params
          #
          # @param params [Array]
          # @param arg_size [int]
          # @raise
          def between_param?(params, arg_size)
            p_cnt = params.nil? ? 0 : params.size
            return true if method_rest?(params)
            opt_cnt = method_option_cnt(params)

            min     = p_cnt - opt_cnt
            msg     = format('Argument: %s', self.class.make_param_s(params))

            return if arg_size.between?(min, p_cnt)
            raise Idcf::Cli::CliError, msg
          end

          # is rest
          #
          # @param params [Array]
          # @return Boolean
          def method_rest?(params)
            unless params.nil?
              params.each do |param|
                case param[:arg_type]
                when 'rest'
                  return true
                end
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
            unless params.nil?
              params.each do |param|
                case param[:arg_type]
                when 'opt'
                  result += 1
                end
              end
            end
            result
          end
        end
      end
    end
  end
end
