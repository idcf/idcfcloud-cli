require_relative './base_server_for_protocol'

module Idcf
  module Cli
    module Service
      module Ilb
        # add server
        class AddServerForProtocol < BaseServerForProtocol
          class << self
            def description
              "Add a loadbalancer config's server."
            end
          end

          protected

          def set_last_command(lb_id, config, target)
            @last_command      = :add_server
            @last_command_args = [lb_id, config['id'], target]
          end
        end
      end
    end
  end
end
