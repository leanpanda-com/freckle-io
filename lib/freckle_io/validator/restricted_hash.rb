module FreckleIO
  module Validator
    module RestrictedHash
      include Dry::Logic::Predicates

      predicate(:restricted_hash?) do |allowed_keys, hash|
        (hash.keys - allowed_keys).empty?
      end
    end
  end
end
