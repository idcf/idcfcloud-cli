require_relative '../test_ilb'

module Idcf
  module Cli
    module Controller
      module IlbCommand
        class TestSslalgorithm < Idcf::Cli::Controller::TestIlb
          self.test_order = :defined

          data(
            default: {}
          )

          def test_list_sslalgorithms(_data)
            result = do_command(:list_sslalgorithms)
            refute(result.empty?)
          end

          data(
            default: {}
          )

          def test_get_sslalgorithm(_data)
            algo = do_command(:list_sslalgorithms).last
            result = do_command(:get_sslalgorithm, algo['id'])
            assert_equal(algo, result)
          end

          data(
            default: {}
          )

          def test_sslalgorithms(_data)
            result = do_command(:sslalgorithms)
            refute(result.empty?)
          end

          data(
            default: {}
          )

          def test_sslalgorithms_ids(_data)
            algos = do_command(:list_sslalgorithms)
            result = do_command(:sslalgorithms_ids)
            assert_equal(algos.size, result[:algorithms].size)
          end
        end
      end
    end
  end
end
