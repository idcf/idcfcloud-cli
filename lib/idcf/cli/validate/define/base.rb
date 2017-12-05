require 'active_model'
require 'active_model/model'
module Idcf
  module Cli
    module Validate
      module Define
        # Base Validate
        class Base
          include ActiveModel::Model
          include Idcf::Cli::Validate::Custom

          attr_accessor :output,
                        :profile,
                        :api_key,
                        :secret_key,
                        :no_ssl,
                        :no_vssl,
                        :json_path,
                        :fields

          validates :output,
                    allow_blank: true,
                    inclusion:   {
                      in:      %w(table json xml csv),
                      message: 'from this [table/json/xml/csv]'
                    }

          validates :api_key,
                    :secret_key,
                    allow_blank:      true,
                    require_relation: {
                      in: true
                    }
        end
      end
    end
  end
end
