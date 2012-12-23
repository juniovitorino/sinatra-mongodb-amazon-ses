module Validators
  module Email
    def self.valid(value)
      begin
       return false if value == ''
       parsed = Mail::Address.new(value)
       return parsed.address == value && parsed.local != parsed.address
      rescue Mail::Field::ParseError
        return false
      end
    end
  end
end