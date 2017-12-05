module Idcf
  module Cli
    module Conf
      class TestConst
        dir_path        = File.dirname(__FILE__)
        BASE_PATH       = File.expand_path('..', dir_path).freeze
        DATA_DIR        = File.expand_path('data', BASE_PATH)
        TEST_NAME       = 'test-cli-lb-'.freeze
        OPTION_STR_LIST = %w(--region jp-west).freeze
      end
    end
  end
end
