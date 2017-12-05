require 'active_support/core_ext/string/inflections'
module Idcf
  module Cli
    module Lib
      module Util
        # name
        class Name
          class << self
            def namespace(cls_name)
              class_names = cls_name.split('::')
              class_names.pop
              class_names.join('::')
            end
          end
        end
      end
    end
  end
end
