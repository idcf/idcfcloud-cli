module Idcf
  module Cli
    module Controller
      module Include
        # sdk
        module Sdk
          protected

          def do_sdk(client, command, *args, _o)
            result = client_send(client, command, *args)
            return result if result.is_a?(Hash)

            if result.class == Array
              result_arr = []
              result.each do |v|
                result_arr << resource_ext(v)
              end

              return result_arr
            end

            resource_ext(result)
          end

          def client_send(client, command, *args)
            arg = set_headers(client.public_method(command.to_sym), *args.dup)

            client.__send__(command.to_sym, *arg)
          end

          def set_headers(method, *args)
            method.parameters.each do |k, v|
              case v[1].to_s
              when 'attributes'
                args[k] = {} unless args[k].class == Hash
              when 'headers'
                args[k] = {} unless args[k].class == Hash
                args[k].merge!(Idcf::Cli::Conf::Const::HEADERS)
              end
            end
            args
          end

          def resource_ext(val)
            return val unless classes?(val, resource_classes)
            return val.body if classes?(val, responce_classes)
            result = {}
            val.instance_variables.each do |pn_sym|
              pn = pn_sym.to_s
              next if pn == '@client'
              result[pn.gsub(/\A@+/, '')] = val.instance_variable_get(pn)
            end
            result
          end

          def classes?(val, classes)
            classes.each do |cl|
              return true if val.is_a?(cl)
            end
            false
          end

          def resource_classes
            []
          end

          def responce_classes
            []
          end

          def base_options(o)
            {}.tap do |result|
              sec = get_profile(o)
              [:api_key, :secret_key].each do |v|
                result[v] = o.key?(v) ? o[v] : get_user_conf(v.to_s, sec)
              end
            end
          end
        end
      end
    end
  end
end
