module Idcf
  module Cli
    # cli custom error
    class CliError < StandardError
      def message
        msg = super
        "#{Idcf::Cli::Conf::Const::LOCAL_ERROR_PREFIX}#{msg}"
      end
    end
  end
end
