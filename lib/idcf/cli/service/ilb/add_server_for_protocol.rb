require_relative './base_server_for_protocol'

module Idcf
  module Cli
    module Service
      module Ilb
        # add server
        class AddServerForProtocol < BaseServerForProtocol
          init

          protected

          def do_command(lb_id, config, target)
            client.add_server(lb_id, config['id'], target)
          end
        end
      end
    end
  end
end
