require_relative '../test_ilb'

module Idcf
  module Cli
    module Controller
      module IlbCommand
        class TestSslcert < Idcf::Cli::Controller::TestIlb
          self.test_order = :defined

          def setup
            @limit_param = 'sslcert_limit'
            @limit_action = 'list_sslcerts'
            super
          end

          data(
            create: {
              name: 'test-sslcert'
            }
          )

          def test_create_sslcert(data)
            return output_skip_info('out limit') if limit?
            befor_certs = do_command(:list_sslcerts)
            data[:name] = make_unique_name(data[:name], befor_certs, 'name')
            do_command(:create_sslcert, data)
            after_certs = do_command(:list_sslcerts)
            assert_equal(befor_certs.size + 1, after_certs.size)
          end

          data(
            list: {}
          )

          def test_list_sslcerts(_data)
            result = do_command(:list_sslcerts)
            refute(result.empty?)
          end

          data(
            list: {}
          )

          def test_get_sslcert(_data)
            cert = do_command(:list_sslcerts).last
            result = do_command(:get_sslcert, cert['id'])
            check = pickup_same_item(cert, result)
            assert_equal(cert, check)
          end

          data(
            list: {}
          )

          def test_sslcerts(_data)
            result = do_command(:sslcerts)
            refute(result.empty?)
          end

          data(
            del: {}
          )

          def test_delete_sslcert(_data)
            return output_skip_info('out limit') if limit?
            t_cert = do_command(:list_sslcerts).last
            do_command(:delete_sslcert, t_cert['id'])
            cert = do_command(:get_sslcert, t_cert['id'])
            assert(cert.empty?)
          end

          data(
            create: {
              name: 'test-upload-sslcert',
              private_key: '-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA23uP4sFTeIxZTPzt1h0qEalAbbqlNluaSMmnRxSDF/2tSz3u
8Wsjhp4uGuyelnYSJyHE97UWLtqztHo3+pGPP56oVWa8h4nyW6v9/NrjKxnELPGG
/uabpCyyqVHB/Gd5iOD0RzWQBR29tUgDUUPESlKOWGMxLzkNz3USXOc5VuE2autP
Kz5wkVu2hvzZS2nMGHLDhMX15KHzen0NAxzgci8qr8M8LeE8lW18c0ZEFGCIKHJb
RPD/YCWa9HKEAClJU6y3rxylgsoUPr6m/JPPYYbc6WVyJQMQCUVS8Ik3f81KDd14
qNtDvYw7oiwq3Lp+U0EsaoE2O+pBNSptVyhB2QIDAQABAoIBAQCoQ2M84R+gBGEV
77ZadwNghNQbC4NLWBDBCq/Og4A5LUbkrzd3J78VnkEUbSDrkts52t7JVLAL/ajV
jPlLhLpAeN7ukhOpCW2fMA1JA3oy+c728befxaW+yHGz8zT3z1BSSrubuAmQkot0
5h989qoOnJn6UxlK7b+Ts1n/lVjVK+jxL2+yzfIDz8ym+7f4J2fT/F+5oL87qDCa
KfwKDKREw2ZWvWk1l6Jc/x2RkKVGCKPRfqGBDCXQbbI9NwqZ07vCR258AQIC/A3G
J3Xmh2gY6HNF7/gkk7YwgogApwjn1Zi/pMm+njplZSiMo1WRdhzzOeOTlm10bKl0
swMto0UdAoGBAP+st7Bh3G5OkC9xPIdwYJQblt44YtrkcipJrXqLaRNh0fLEyz2S
h+zDBKg7IoWNirESwrNpgkC1s3vXHRFs57bY5LQTrBkHicrnYm/7gAXES3NaLExt
BrtvvIl86SVZy3tNfpYUrShwb+FHKKxHMZAFqB2z8EGKTP4qGC58GBwfAoGBANvD
DjOQ/EiJIXDygCFUR8Xkp9LnkgNPmAH1wla5y1bjVYjHTvXXz0wemzfOrWSVBVlS
yTQGD6XifaTAvy4E/DfKF8F5UHgUhUb4jUwIRSwo2Vaaa9wdfmSGvUptLK0cTup9
Gw4oBL+f4UtZ4MT16GdAi3GqUoYPyfpxyKU8cOMHAoGALC1v3+5I5FZ223u5db2Z
Mn5B50ve6OuoPl5Ut2P3V/4DBOu0IoN7MRHRcDAnmuQGHuqa8d09QGklBjT5NNWY
hCOeAO+VQQ3oZULt42OVj2mHj/r4xIviKej4rtkCgA2v9zJAuTYBZYdoDYj6Iip7
CeOwVNGOpgR7oT8sxntyvwkCgYBMReS17QpCuqWKp//kkXXfrz64Kns4/vUJKRzs
MMvsOjbDpDk5hk+CYdUJh4gSss4KdHs0vS3NK1DkT6mK9Vv8mP2pvss5AhZHzZhs
3Sn067CTKEFrQilOBp3IKSAqbPrO0+ECBs2vHHR7TJSAh8DDpVlAeBbwRKabb8Zt
4w5jHQKBgQCti/W2FheSOxUs7KYD+u1tfXbheZyX6wgGqr5+F4jIs3BjxH6W46d5
1BQZj8817Vicaa8DuTKs8QBa28bhC25AA7Q+puFPddsiiy+v3e3vXZcy4zZeDeY9
+WCI/ywk60IfsPCqDJGKsQhOLeBjYMAKX1cGaPlNB8KDbeNfQ1JqpA==
-----END RSA PRIVATE KEY-----',
              certificate: '-----BEGIN CERTIFICATE-----
MIIC/jCCAeYCCQC2ciGgZT1iHzANBgkqhkiG9w0BAQsFADBAMQswCQYDVQQGEwJK
UDEOMAwGA1UECAwFVG9reW8xITAfBgNVBAoMGEludGVybmV0IFdpZGdpdHMgUHR5
IEx0ZDAgFw0xNzA2MjIwNzE1MjlaGA8yMTE3MDUyOTA3MTUyOVowQDELMAkGA1UE
BhMCSlAxDjAMBgNVBAgMBVRva3lvMSEwHwYDVQQKDBhJbnRlcm5ldCBXaWRnaXRz
IFB0eSBMdGQwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDbe4/iwVN4
jFlM/O3WHSoRqUBtuqU2W5pIyadHFIMX/a1LPe7xayOGni4a7J6WdhInIcT3tRYu
2rO0ejf6kY8/nqhVZryHifJbq/382uMrGcQs8Yb+5pukLLKpUcH8Z3mI4PRHNZAF
Hb21SANRQ8RKUo5YYzEvOQ3PdRJc5zlW4TZq608rPnCRW7aG/NlLacwYcsOExfXk
ofN6fQ0DHOByLyqvwzwt4TyVbXxzRkQUYIgocltE8P9gJZr0coQAKUlTrLevHKWC
yhQ+vqb8k89hhtzpZXIlAxAJRVLwiTd/zUoN3Xio20O9jDuiLCrcun5TQSxqgTY7
6kE1Km1XKEHZAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAJU3j0lUYX3vj8aUbSV3
xwI8pxfPhT9oLg67eX+85TgotA08/13wDFJ/lIeZgH2Wif2yHyNioIzm9sK78TUo
Lm0jTEl1krETRc8K2OweTRfFR0eYt2hSplt+GC3inFNNnkvHBTyRzYO4DYXKQISG
xuHvZv9BoXg18ndZ/QMzhnuh084YZs8mWkEt/zf3K2OQ5A5j0x2rf7mjxGNP/8Xl
wvjTshl2iXLfHbp67uE3E9L4SHH8o0+agbrbjOwp7BM20fvtsZFaVjEib0H7O38P
X8NdMPpnaVRSU+rwnU70Nd4A/dFFVHt81kyKsuxpYuTdomuv8sZ7YUejvxfqBwIc
dnM=
-----END CERTIFICATE-----'
            }
          )

          def test_upload_sslcert(data)
            return output_skip_info('out limit') if limit?
            befor_certs = do_command(:list_sslcerts)
            data[:name] = make_unique_name(data[:name], befor_certs, 'name')
            cert = do_command(:upload_sslcert, data)
            after_certs = do_command(:list_sslcerts)
            # delete
            do_command(:delete_sslcert, cert['id'])
            assert_equal(befor_certs.size + 1, after_certs.size)
          end
        end
      end
    end
  end
end
