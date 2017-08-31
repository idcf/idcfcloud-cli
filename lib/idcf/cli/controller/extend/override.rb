module Idcf
  module Cli
    module Controller
      module Extend
        # override methods
        module Override
          def description
            raise Idcf::Cli::CliError, 'Require override'
          end

          # blank client
          #
          # @return Mixed
          def make_blank_client
            # blank client
          end
        end
      end
    end
  end
end
