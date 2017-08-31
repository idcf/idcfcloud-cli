require_relative './update'
require_relative './configure'
module Idcf
  module Cli
    module Extend
      # init load
      module Init
        include Update
        include Configure
      end
    end
  end
end
