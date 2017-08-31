require_relative './override'
require_relative './validate'
require_relative './command'
require_relative './util'
require_relative './sdk'
module Idcf
  module Cli
    module Controller
      module Include
        # init load
        module Init
          include Override
          include Validate
          include Command
          include Util
          include Sdk
        end
      end
    end
  end
end
