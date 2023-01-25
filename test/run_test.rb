$VERBOSE = false

base_dir = File.expand_path(File.join(File.dirname(__FILE__), '..'))
lib_dir = File.join(base_dir, 'lib')
test_dir = File.join(base_dir, 'test')

require 'test-unit'
require 'test/unit/notify' unless ENV['DISABLE_TEST_NOTIFY']
require 'idcf/cli/validate/custom/init'
require 'idcf/cli/conf/const'
require 'idcf/cli/error/init'
require 'idcf/cli/index'

require 'net/https'
Net::HTTP.prepend(Module.new do
  def use_ssl=(flag)
    super
    self.ciphers = 'DEFAULT:!DH'
  end
end)

$LOAD_PATH.unshift(test_dir)
$LOAD_PATH.unshift(lib_dir)

ENV['TEST_UNIT_MAX_DIFF_TARGET_STRING_SIZE'] ||= '5000'

Idcf::Cli::Index.__send__(:add_classify_rule)

exit Test::Unit::AutoRunner.run(true, test_dir)
