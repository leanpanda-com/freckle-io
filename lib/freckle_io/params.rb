module FreckleIO
  class Params
    attr_reader :params
    attr_reader :allowed_keys
    attr_reader :validator_class

    def initialize(
      params,
      allowed_keys,
      validator_class
    )
      @params = params
      @allowed_keys = allowed_keys
      @validator_class = validator_class
    end

    def call
      return validator.output if valid?

      raise Errors::Params::InvalidParams.new, validator.messages.join(",")
    end

    private

    def valid?
      validator.errors.empty?
    end

    def validator
      @validator ||= validator_class.validation(params, allowed_keys)
    end
  end
end
