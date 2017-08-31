require 'active_model'
require 'active_model/model'
require_relative '../base'
module Idcf
  module Cli
    module Validate
      module Define
        module Ilb
          # Base Validate
          class Base < Idcf::Cli::Validate::Define::Base
            include ActiveModel::Model
            include Idcf::Cli::Validate::Custom

            attr_accessor :region

            validates :region,
                      allow_blank: true,
                      inclusion:   {
                        in:      Idcf::Cli::Conf::Const::REGIONS,
                        message: "from this [#{Idcf::Cli::Conf::Const::REGIONS.join('/')}]"
                      }
          end
        end
      end
    end
  end
end
