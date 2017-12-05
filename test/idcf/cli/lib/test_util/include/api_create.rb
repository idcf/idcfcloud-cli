require 'idcf/cli/conf/test_const'
require 'idcf/cli/lib/api'
module Idcf
  module Cli
    module Lib
      module TestUtil
        module Include
          module ApiCreate
            # make_api
            #
            # @param cls [Idcf::Cli::Controller::Base]
            # @return Idcf::Cli::Lib::Api
            def make_api(cls)
              cls.init(Idcf::Cli::Conf::TestConst::OPTION_STR_LIST)
              o      = thor_options(cls)
              region = cls.get_region(o)
              target = cls.new
              client = target.__send__(:make_client, o, region)
              Idcf::Cli::Lib::Api.new(links: cls.links, client: client)
            end

            # thor options
            #
            # @param cls [Idcf::Cli::Controller::Base]
            # @return Thor::Options
            def thor_options(cls)
              op = cls.__send__(:class_options)
              Thor::Options.new(op).parse(Idcf::Cli::Conf::TestConst::OPTION_STR_LIST)
            end

            # skip info
            #
            # @param msg [String]
            def output_skip_info(msg)
              info = caller.first.split('/').pop(3).join('/')
              puts format("\nskip: %s \nmsg: %s", info, msg)
            end
          end
        end
      end
    end
  end
end
