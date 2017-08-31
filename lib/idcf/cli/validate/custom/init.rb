module Idcf
  module Cli
    module Validate
      # custom validation load sesettings
      module Custom
        path = 'idcf/cli/validate/custom/'
        autoload :RequireRelationValidator,
                 "#{path}require_relation_validator"
        autoload :MonthCheckValidator,
                 "#{path}month_check_validator"
      end
    end
  end
end
