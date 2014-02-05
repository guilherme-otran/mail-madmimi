require 'mail/mad_mimi/sender'

module Mail
  module MadMimi
    ActionMailer::Base.add_delivery_method :mad_mimi, Mail::MadMimi::Sender, username: "", api_key: ""
  end
end