require 'idcf/cli/conf/const'
require 'idcf/cli/lib/api'
module Idcf
  module Cli
    module Controller
      module Extend
        # command
        module Command
          # register schema method by link
          #
          # @param link [Idcf::JsonHyperSchema::Expands::LinkInfoBase]
          def register_schema_method_by_link!(link)
            param_str = Idcf::Cli::Lib::Api.command_param_str(link)
            method_desc = "#{link.title} #{param_str}"
            desc method_desc.strip, link.description
            define_method link.title.to_sym do |*args|
              execute(__method__, *args)
            end
          end

          # register module mothod
          #
          # @param name [String] command_name
          # @param cls [Idcf::Cli::Service::Base]
          def register_module_method!(name, cls)
            register_method_option! cls.options
            desc "#{name} #{cls.make_param_s}", cls.description
            define_method name.to_sym do |*args|
              execute(__method__, *args)
            end
          end

          # regist method option
          #
          # @param values [Hash] name => desc
          def register_method_option!(values)
            return nil if values.nil?
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
