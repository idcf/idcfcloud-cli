require 'idcf/cli/conf/const'
module Idcf
  module Cli
    module Controller
      module Extend
        # command
        module Command
          def register_method!(name, params, options)
            register_method_option! options
            cp = make_param_s params
            desc "#{name} #{cp}", ''
            define_method name.to_sym do |*args|
              execute(__method__, *args)
            end
          end

          # make param string
          #
          # @param params[Array]
          # @return String
          def make_param_s(params)
            cp = []
            return '' if params.nil?
            params.each do |param|
              f = param[:arg_type].to_s == 'req' ? '<%s>' : '[%s]'
              cp << format(f, param[:name])
            end
            cp.join(' ')
          end

          # regist method option
          #
          # @param values [Hash] name => desc
          def register_method_option!(values)
            return if values.nil?
            values.each do |opn, op|
              option = {}
              op.each do |ok, ov|
                option[ok.to_sym] = ov
              end
              method_option opn, option
            end
          end
        end
      end
    end
  end
end
