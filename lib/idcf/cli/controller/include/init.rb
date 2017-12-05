require_relative './validate'
require_relative './command'
require_relative './util'
require_relative './client'
module Idcf
  module Cli
    module Controller
      module Include
        # init load
        module Init
          include Validate
          include Command
          include Util
          include Client
        end
      end
    end
  end
end
