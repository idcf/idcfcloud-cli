require 'idcf/cli/conf/const'
require 'erb'
module Idcf
  module Cli
    module Lib
      module Util
        # template
        class Template
          def set(name, value)
            instance_variable_set("@#{name}", value)
          end

          # return string
          #
          # @param path [String]
          # @param attr
          def fetch(path, attr = {})
            tmp_path = "#{Idcf::Cli::Conf::Const::TEMPLATE_DIR}/#{path}"
            attr.each do |k, v|
              set(k, v)
            end
            f_content = File.open(File.expand_path(tmp_path)).read
            ERB.new(f_content).result(binding)
          end
        end
      end
    end
  end
end
