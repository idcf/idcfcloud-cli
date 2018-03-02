require 'test/unit'
require 'idcf/cli/index'
require 'idcf/cli/conf/const'
require 'idcf/cli/controller/ilb'
require 'idcf/cli/controller/your'
require 'thor'

module Idcf
  module Cli
    module Extend
      # test update file
      class TestUpdateFile < Test::Unit::TestCase
        @target = nil

        def setup
          Idcf::Cli::Index.init({})
          @target = Idcf::Cli::Index.new
        end

        def cleanup
          @target = nil
        end

        data(
          http:  'http://example.com/',
          https: 'https://example.com/',
          ftp:   'ftp://example.com/'
        )

        def test_create_schema_url(data)
          path = @target.__send__(:create_schema_url, data)
          assert_equal(path, data)
        end

        data(
          relative: 'doc/test.json',
          usr_dir:  '~/.bash_profile',
          full:     '/bin/bash'
        )

        def test_create_schema_url_by_local(data)
          path = @target.__send__(:create_schema_url, data)
          assert_not_equal(path, data)
        end

        data(
          ilb:  Idcf::Cli::Controller::Ilb,
          your: Idcf::Cli::Controller::Your
        )

        def test_schema_file_paths(data)
          result = @target.__send__(:schema_file_paths, data)
          refute(result.size.zero?)
        end

        data(
          min:          '0.0.0',
          last_three:   '0.0.100',
          middle_three: '0.100.0',
          first_three:  '100.0.0',
          all_three:    '999.999.999'
        )

        def test_success_check_api_version_format(data)
          result = @target.__send__(:check_api_version_format, data)
          assert(result)
        end

        data(
          last_under:   '0.0.-1',
          middle_under: '0.-1.0',
          first_under:  '-1.0.0',
          all_under:    '-1.-1.-1',
          format:       '0',
          format2:      '0.0',
          format3:      '0.0.0.0',
          non_numeric:  'a.0.0',
          other_symbol: '0/0/0'
        )

        def test_error_check_api_version_format(data)
          assert_throw(:done) do
            begin
              @target.__send__(:check_api_version_format, data)
            rescue StandardError => _e
              throw(:done)
            end
          end
        end
      end
    end
  end
end
