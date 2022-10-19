module FreckleIO
  class Params
    attr_reader :params,
                :validator_module

    def initialize(
      params,
      validator_module
    )
      @params = params
      @validator_module = validator_module
    end

    def call
      return validator.to_h if valid?

      raise Errors::Params::InvalidParams.new, validator_messages
    end

    private

    def valid?
      validator.errors.empty?
    end

    def validator
      @validator ||= which_validator_module.new.call(params)
    end

    def which_validator_module
      Kernel.const_get(validator_module)
    rescue NameError => e
      raise Errors::Params::InvalidModule.new(e), e.message
    end

    def validator_messages
      messages = validator.errors(full: true).messages
      messages.join(",")
    end
  end
end
