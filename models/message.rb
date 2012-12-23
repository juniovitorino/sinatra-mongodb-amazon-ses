class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :email
  field :subject
  field :message

end