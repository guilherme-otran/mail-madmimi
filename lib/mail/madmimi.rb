require 'mail/madmimi/version'
require 'mail/madmimi/sender'

module Mail
  module Madmimi
    ActionMailer::Base.add_delivery_method :mad_mimi, Mail::Madmimi::Sender
  end
end
