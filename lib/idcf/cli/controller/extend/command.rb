require 'idcf/cli/conf/const'
require 'idcf/cli/lib/api'
require 'idcf/cli/lib/document'
module Idcf
  module Cli
    module Controller
      module Extend
        # command
        module Command
          attr_reader :public_commands

          # register schema method by link
          #
          # @param link [Idcf::JsonHyperSchema::Expands::LinkInfoBase]
          def register_schema_method_by_link!(link)
            param_str   = Idcf::Cli::Lib::Api.command_param_str(link)
            method_desc = "#{link.title} #{param_str}"
            description = link.description
            desc method_desc.strip, description
            description = "#{description}\n\n#{Idcf::Cli::Lib::Document.make_document_desc(link)}"
            long_desc description
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

          def desc(usage, description, options = {})
            super(usage, description, options)
            @public_commands ||= []
            cmd = usage.split(' ').shift
            @public_commands << cmd unless @public_commands.include?(cmd)
          end

          def subcommand_structure
            result = super
            list = @public_commands
            list.concat(superclass.public_commands) if superclass.respond_to?(:public_commands)
            list.each do |cmd|
              result[cmd] = nil unless result.key?(cmd)
            end
            result
          end
        end
      end
    end
  end
end
