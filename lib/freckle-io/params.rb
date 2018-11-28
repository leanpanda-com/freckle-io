module FreckleIO
  class Params
    attr_reader :params
    attr_reader :allowed_keys
    attr_reader :validator_module

    def initialize(
      params,
      allowed_keys,
      validator_module
    )
      @params = params
      @allowed_keys = allowed_keys
      @validator_module = validator_module
    end

    def call
      return validator.output if valid?

      raise Errors::Params::InvalidParams.new, validator_messages
    end

    private

    def valid?
      validator.errors.empty?
    end

    def validator
      @validator ||= which_validator_module.validation(params, allowed_keys)
    end

    def which_validator_module
      Kernel.const_get(validator_module)
    end

    def validator_messages
      messages = validator.messages(full: true)
      return messages.values.join(",") if messages.is_a?(Hash)

      messages.join(",")
    end
  end
end
