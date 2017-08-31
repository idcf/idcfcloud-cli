require_relative './override'
require_relative './search_module'
require_relative './command'
module Idcf
  module Cli
    module Controller
      module Extend
        # init load
        module Init
          include Override
          include SearchModule
          include Command
        end
      end
    end
  end
end
