require_relative '../test_ilb'

module Idcf
  module Cli
    module Controller
      module IlbCommand
        class TestSslpolicy < Idcf::Cli::Controller::TestIlb
          self.test_order = :defined

          def setup
            @limit_param = 'sslpolicy_limit'
            @limit_action = 'list_sslpolicies'
            super
          end

          data(
            create: {
              name: 'test-sslpolicy-1'
            }
          )

          def test_create_sslpolicy(data)
            return output_skip_info('out limit') if limit?
            befor_policies = do_command(:list_sslpolicies)
            algorithms = do_command(:sslalgorithms_ids)

            params = data.merge(algorithms)
            do_command(:create_sslpolicy, params)
            after_certs = do_command(:list_sslpolicies)
            assert_equal(befor_policies.size + 1, after_certs.size)
          end

          data(
            list: {}
          )

          def test_list_sslpolicies(_data)
            result = do_command(:list_sslpolicies)
            refute(result.empty?)
          end

          data(
            list: {}
          )

          def test_get_sslpolicy(_data)
            policy = do_command(:list_sslpolicies).last
            result = do_command(:get_sslpolicy, policy['id'])
            check = pickup_same_item(policy, result)
            assert_equal(policy, check)
          end

          data(
            list: {}
          )

          def test_sslpolicies(_data)
            result = do_command(:sslpolicies)
            refute(result.empty?)
          end

          data(
            list: {}
          )

          def test_delete_sslpolicy(_data)
            return output_skip_info('out limit') if limit?
            policy = do_command(:list_sslpolicies).last
            do_command(:delete_sslpolicy, policy['id'])
            result = do_command(:get_sslpolicy, policy['id'])
            assert(result.empty?)
            assert(result.empty?)
          end
        end
      end
    end
  end
end
