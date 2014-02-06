require 'action_mailer'
require 'mail/madmimi'

class TestMailer < ActionMailer::Base
  def test_mail
    mail(to: "somebody@example.org",
      promotion_name: "Promo",
      from: "from@example.org",
      bcc: "bcc@example.org",
      subject: "Some subject") do |format|
        format.html { render(text: "Oi :P") }
      end
  end
end

class CorrectResponse
  def headers
    { "status" => 200 }
  end

  def parsed_response
    # Transaction ID
    "1234567890"
  end
end

class IncorrectResponse
  def headers
    { "status" => 403 }
  end

  def parsed_response
    "Not authorized"
  end
end