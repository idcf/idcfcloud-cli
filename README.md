# idcfcloud-cli

## Installation

Note: requires Ruby 2.2.7 or higher.

Carry out the next command to initialize.

```
bin/idcfcloud init
```

If you want each user to have their own configuration file, use the "--no-global" option and have the file created in the following:

```
~/.idcfcloud/config.ini
```

Install idcfcloud-cli by using the following command:

```
$ gem install idcfcloud
```
or
```
$ git clone [idcfcloud]
$ bundle install --path vendor/bundle
```

## Usage

```
$ bin/idcfcloud <serviceName> <command> [attributes] [option]
```

If you want to set more than one attribute, use the json form.

```ex)
'{"ipaddress": "0.0.0.0", "port": 80}'
```

## ServiceName
[ILB](#ilb)

[Your](#your)

#### <a name="ilb"></a>ILB

https://github.com/idcf/idcf-ilb-ruby

##### ILB Extend Commands

add server

``` code
bin/idcfcloud ilb add_server_for_protocol <lb_id> <protocol> <protocol_port> <data> [option]
```

| data | type | example | note |
|:---|:---|:---|:---|
| ipaddress | String | 0.0.0.0 | no cidr |
| port | Numeric | 80 |  |

delete server

``` code
bin/idcfcloud ilb delete_server_for_protocol <lb_id> <protocol> <protocol_port> <data> [option]
```

#### <a name="your"></a>Your

http://docs.idcf.jp/cloud/billing/


## Development

Running the following test code is possible, but not recommended nor supported.  Run only a code of a target.

```code
bundle exec ruby test/run_test.rb idcf/cli/controller/test_billing.rb
```

In order to avoid collapsed setting in ILB, make sure you understand how things work before running a code.

## Contributing

1. Fork it ( https://github.com/idcf/idcfcloud-cli/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push the branch (git push origin my-new-feature)
5. Create a new Pull Request