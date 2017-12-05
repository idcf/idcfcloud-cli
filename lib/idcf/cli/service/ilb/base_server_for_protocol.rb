require_relative '../base'

module Idcf
  module Cli
    module Service
      module Ilb
        # [add/delete] server for protocol
        class BaseServerForProtocol < Idcf::Cli::Service::Base
          attr_reader :api, :options

          # do
          #
          # @param api [Idcf::Ilb::Lib::Api]
          # @param o [Hash] options
          # @option lb_id [String]
          # @option protocol [Stirng] http
          # @option protocol_port [int] 80
          # @option params [Hash] {ipaddress: '0.0.0.0', port: 80}
          def do(api, o, lb_id, protocol, protocol_port, params)
            @api     = api
            @options = o
            lb       = search_lb(lbs, lb_id)
            config   = search_config(lb, protocol, protocol_port)

            if config.nil?
              not_param = o[:protocol].nil? ? 'conf_id' : 'protocol'
              cli_error "A target isn't found(#{not_param})"
            end

            set_last_command(lb_id, config, params)
            config['servers']
          end

          protected

          def set_last_command(_lb_id, _config, _target)
            cli_error 'override required'
          end

          # get lb list
          #
          # @return Array in Hash
          # @raise
          def lbs
            @api.do(:list_loadbalancers)
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
            cli_error msg if lbs.empty?

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
                cli_error msg
              end
              return v
            end
            nil
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
