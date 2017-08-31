require 'active_support'
require 'active_support/core_ext'
require 'idcf/cli/conf/const'
require 'idcf/cli/lib/util/template'
require_relative 'update_file'
module Idcf
  module Cli
    module Extend
      # update settings
      module Update
        protected

        include UpdateFile

        COMP_N = 'complement'.freeze

        def do_update(_o)
          clients = make_clients
          writable_setting_file clients.keys
          infos = {}

          clients.each do |s_name, client|
            info = make_module_info(client)
            output_yaml(s_name, info)
            infos[s_name] = info
          end
          output_complement
        end

        def make_clients
          {}.tap do |result|
            self.class.subcommand_classes.each do |k, v|
              next unless v.ancestors.include?(Idcf::Cli::Controller::Base)
              client    = v.make_blank_client
              result[k] = client unless client.nil?
            end
          end
        end

        def make_module_info(client)
          {}.tap do |result|
            module_methods = []
            client.class.included_modules.each do |m|
              next unless m.to_s =~ /\AIdcf::.*::ClientExtensions/
              module_methods.concat(m.instance_methods)
            end
            module_methods.each do |method|
              result[method] = make_method_info(client, method)
            end
          end
        end

        def make_method_info(client, method_sym)
          params = []
          client.method(method_sym).parameters.each do |param|
            next if param[0] == :block
            params << {
              name:     param[1].to_s,
              arg_type: param[0].to_s
            }
          end

          { desc: '', params: params }
        end

        def output_complement
          view = Idcf::Cli::Lib::Util::Template.new
          view.set('variables', make_script_variables)
          paths = []
          %w(bash zsh).each do |e|
            str  = view.fetch("#{e}/#{COMP_N}.erb")
            path = "#{Idcf::Cli::Conf::Const::OUT_DIR}/#{COMP_N}.#{e}"
            paths << File.expand_path(path)
            output_complement_file(str, paths.last)
          end
          output_notification(paths)
        end

        def output_notification(paths)
          notification = Idcf::Cli::Conf::Const::COMP_NOTIFICATION
          puts format(notification, *paths)
        end

        def make_script_variables
          self.class.init
          make_flat_variables(self.class.subcommand_structure)
        end

        # bash 3.x
        #
        # @param list [Hash]
        # @param names [Array]
        # @return Hash
        def make_flat_variables(list, names = [])
          {}.tap do |result|
            name = names.empty? ? 'top' : names.join('_')
            result[name] = list.keys
            list.each do |k, v|
              next unless v.class == Hash
              names << k
              result.merge!(make_flat_variables(v, names))
              names.pop
            end
          end
        end
      end
    end
  end
end
