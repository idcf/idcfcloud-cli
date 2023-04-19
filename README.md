# idcfcloud-cli

## Installation

Note: requires Ruby 2.7.0 or higher.

Carry out the next command to initialize.

```
$ idcfcloud init
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
$ idcfcloud <serviceName> <command> [attributes] [option]
```

If you want to set more than one attribute, use the json form.

``` ex)
'{"ipaddress": "0.0.0.0", "port": 80}'
```

Or you can also define the GET or POST parameter in the JSON file and hand it using xargs.

``` ex) xargs
cat [attributes file path] | echo -e "'"$(cat)"'" | xargs -L1 idcfcloud <serviceName> <command> [option]
```

### Service Options

| option | alias | default | note |
|:---|:---|:---|:---|
| output | o | json | Output formats (table/json/xml/csv) |
| profile |  | default | Switching profiles |
| api-key |  | [Configuration file description] | API Key |
| secret-key |  | [Configuration file description] | Secret Key |
| no-ssl |  |  | Not using SSL |
| no-vssl |  |  | Not using Verify SSL |
| json-path | j |  | Narrowing the data part of a return value using json-path<br/>https://github.com/joshbuddy/jsonpath |
| fields | f |  | Limiting the return value to be displayed (applied only to the latest hash)<br/>Punctuation: comma (",") |
| version |  | [latest] | The API version to be used |


#### How to Narrow Down (Examples)
```
idcfcloud your list_billing_history --json-path '$.data[?(@.month=="2017-10")]' --fields month,billing_amount
```

## ServiceName
[Compute](#compute)

[ILB](#ilb)

[DNS](#dns)

[Your](#your)

### Common Features

versions

Get a supported API version.

```code
$ idcfcloud your versions
```


### Compute<a name="compute"></a>

http://docs.idcf.jp/cloud/api/

### ILB<a name="ilb"></a>

https://github.com/idcf/idcf-ilb-ruby

#### ILB Extend Commands

add server

``` code
$ idcfcloud ilb add_server_for_protocol <lb_id> <protocol> <protocol_port> <data> [option]
```

| data | type | example | note |
|:---|:---|:---|:---|
| ipaddress | String | 0.0.0.0 | no cidr |
| port | Numeric | 80 |  |

delete server

``` code
$ idcfcloud ilb delete_server_for_protocol <lb_id> <protocol> <protocol_port> <data> [option]
```

check_job

``` code
$ idcfcloud ilb check_job <job_id>
```

sslalgorithms_ids

``` code
$ idcfcloud ilb sslalgorithms_ids
```

### DNS<a name="dns"></a>

http://docs.idcf.jp/cloud/dns/#s_fid=4FEB16B56007BA5C-0BFB42ABA668ADA8

### Your<a name="your"></a>

http://docs.idcf.jp/cloud/billing/

## Development && Test

Running the following test code is possible, but not recommended nor supported.  Run only a code of a target.

🚨NOTE 🚨

- Be sure to specify `test/run_test.rb` before the test target.
- The test environment is not standalone. You need to apply for services and prepare your own environment.
  At least an [ILB](https://www.idcf.jp/cloud/ilb/) is required to pass all tests.
- If you do not specify the region properly with the environment variable `TEST_REGION (default: jp-east)`, the test will not pass.

```code
$ TEST_REGION=your_region bundle exec ruby test/run_test.rb idcf/cli/controller/test_your.rb
```

In order to avoid collapsed setting in ILB, make sure you understand how things work before running a code.

#### environments

|name|description|
|----|-----------|
|`TEST_REGION`|Region used in the test. (jp-east・jp-east-2・jp-east-3・jp-west)|

## Contributing

1. Fork it ( https://github.com/idcf/idcfcloud-cli/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push the branch (git push origin my-new-feature)
5. Create a new Pull Request
