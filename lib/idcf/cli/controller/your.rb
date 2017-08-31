require_relative './base'
require 'idcf/your'

module Idcf
  module Cli
    module Controller
      # Your
      class Your < Base
        default_command :help

        class << self
          def description
            'Your Service'
          end

          def make_blank_client
            Idcf::Your::Client.new(
              api_key:    '',
              secret_key: ''
            )
          end
        end

        protected

        def make_table_data(data)
          data['data']
        end

        def resource_classes
          [
            Idcf::Your::Response
          ]
        end

        def responce_classes
          [
            Idcf::Your::Response
          ]
        end

        # Create a new client
        # @param o [Hash] other options
        # @return [Response] Idcf::Ilb::Client
        def make_client(o)
          option = {
            host:       get_code_conf('your.v1.host', o),
            verify_ssl: o.key?(:no_vssl) ? false : true
          }
          option.merge!(base_options(o))

          Idcf::Your::Client.new(option)
        end
      end
    end
  end
end
