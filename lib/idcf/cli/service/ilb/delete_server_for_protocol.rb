require_relative './base_server_for_protocol'

module Idcf
  module Cli
    module Service
      module Ilb
        # delete server
        class DeleteServerForProtocol < BaseServerForProtocol
          class << self
            def description
              "Delete a [loadbalancer's config server]"
            end
          end

          protected

          def set_last_command(lb_id, config, target)
            server_id          = search_server_id(config['servers'], target)
            @last_command      = :delete_server
            @last_command_args = [lb_id, config['id'], server_id]
          end

          def search_server_id(servers, target)
            result = servers.select do |v|
              v['ipaddress'] == target[:ipaddress] &&
                v['port'] == target[:port]
            end
            result.first['id'] if result.size == 1
          end
        end
      end
    end
  end
end
