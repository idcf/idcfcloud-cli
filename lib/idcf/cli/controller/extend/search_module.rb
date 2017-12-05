require 'idcf/cli/conf/const'
module Idcf
  module Cli
    module Controller
      module Extend
        # model class search
        module SearchModule
          # search module class
          #
          # @param class_mame [String]
          # @return Mixed
          def search_module_class(module_name)
            make_module_classes.each do |k, v|
              return v if module_name.to_s == k
            end
            nil
          end

          # make module require and class list
          #
          # @return Hash
          def make_module_classes
            return @m_classes if @m_classes
            result = {}
            add_classify_rule

            make_service_paths.each do |fn, path|
              require path
              result[fn] = path.classify.constantize
            end

            @m_classes = result
          end

          # add classify rule
          def add_classify_rule
            Idcf::Cli::Conf::Const::CLASSIFY_RULE.each do |rule|
              ActiveSupport::Inflector.inflections do |inflect|
                inflect.irregular(*rule)
              end
            end
          end

          # make service paths
          #
          # @return Hash
          def make_service_paths
            s_name    = make_model_name
            base_path = Idcf::Cli::Conf::Const::BASE_PATH
            s_path    = "#{Idcf::Cli::Conf::Const::SERVICE_PATH}/#{s_name}"
            {}.tap do |result|
              Dir.glob("#{base_path}/#{s_path}/*.rb").each do |f|
                fn         = File.basename(f, '.rb')
                result[fn] = "#{s_path}/#{fn}" unless fn =~ /^base_*/
              end
            end
          end

          def make_model_name
            list = to_s.split('::')
            list.shift(3)
            list.join('/').underscore
          end
        end
      end
    end
  end
end
