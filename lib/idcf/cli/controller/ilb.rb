require_relative './base'
require 'idcf/ilb'

module Idcf
  module Cli
    module Controller
      # ILB
      class Ilb < Base
        default_command :help

        class_option :region,
                     type:    :string,
                     aliases: '-r',
                     require: true,
                     desc:    "region: #{Idcf::Cli::Conf::Const::REGIONS.join('/')}"

        class << self
          def description
            'ILB Service'
          end

          def make_blank_client
            Idcf::Ilb::Client.new(
              api_key:    '',
              secret_key: ''
            )
          end
        end

        protected

        def resource_classes
          [
            Idcf::Ilb::Response,
            Idcf::Ilb::Resources::Base
          ]
        end

        def responce_classes
          [
            Idcf::Ilb::Response
          ]
        end

        # Create a new client
        # @param o [Hash] other options
        # @return [Response] Idcf::Ilb::Client
        def make_client(o)
          region = get_region(o)
          option = {
            host:       get_code_conf("ilb.v1.host.#{region}", o),
            ssl:        o.key?(:no_ssl) ? false : true,
            verify_ssl: o.key?(:no_vssl) ? false : true
          }
          option.merge!(base_options(o))

          Idcf::Ilb::Client.new(option)
        end
      end
    end
  end
end
