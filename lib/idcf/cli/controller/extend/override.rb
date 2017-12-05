module Idcf
  module Cli
    module Controller
      module Extend
        # override methods
        module Override
          def description
            raise Idcf::Cli::Error::CliError, 'Require override'
          end
        end
      end
    end
  end
end
