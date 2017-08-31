require_relative '../base'

module Idcf
  module Cli
    module Service
      module Ilb
        # [add/delete] server for protocol
        class BaseServerForProtocol < Idcf::Cli::Service::Base
          class << self
            def init
              param :lb_id
              param :protocol
              param :protocol_port
              param :data, Base::ARG_TYPE_REQ
            end
          end

          attr_reader :client

          # do
          #
          # @param client [Idcf::Ilb::Client]
          # @param args [Array]
          # @option args [String] lb id
          # @option args [Stirng] configure protocol
          # @option args [int] configure port
          # @option args [Hash] server info {ipaddress: '0.0.0.0', port: 80}
          # @param o [Hash] options
          def do(client, *args, o)
            @client = client
            lb_id   = args[0]
            lb      = search_lb(lbs, lb_id)
            config  = search_config(lb, args[1], args[2])

            if config.nil?
              not_param = o[:protocol].nil? ? 'conf_id' : 'protocol'
              raise Idcf::Cli::CliError, "Target not found (#{not_param})"
            end

            do_command(lb_id, config, args[3])
            client.list_servers(lb_id, config['id'])
          end

          protected

          def do_command(_lb_id, _config, _target)
            raise Idcf::Cli::CliError, 'override required'
          end

          # get lb list [Idcf::Ilb::Client]
          #
          # @param client
          # @return Array in Hash
          # @raise
          def lbs
            lb  = client.get(:loadbalancers)
            msg = "Status: #{lb.status}"
            raise Idcf::Cli::CliError, msg if !lb.success? || lb.status != 200

            lb.body
          end

          # search lb target
          #
          # @param list
          # @param id
          # @return [Hash]
          # @raise
          def search_lb(list, id)
            lbs = list.select do |v|
              v['id'] == id
            end

            msg = "Target lb_id not found ( #{id} )"
            raise Idcf::Cli::CliError, msg if lbs.empty?

            lbs[0]
          end

          # config search
          #
          # @param lb_info [Hash]
          # @param o [Hash]
          # @return Hash
          # @raise
          def search_config(lb_info, protocol, p_port)
            lb_info['configs'].each do |v|
              next unless target_config?(v, protocol, p_port)
              unless v['state'].casecmp('running').zero?
                msg = 'The operation is impossible because the target is currently being processed'
                raise Idcf::Cli::CliError, msg
              end
              return v
            end
          end

          # is target config
          #
          # @param config [Hash]
          # @param protocol [String]
          # @param p_port [String]
          # @return boolean
          def target_config?(config, purotocol, p_port)
            config['frontend_protocol'] == purotocol &&
              config['port'].to_s == p_port.to_s
          end
        end
      end
    end
  end
end
