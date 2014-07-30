require 'action_mailer'
require 'mail/madmimi'

class TestMailer < ActionMailer::Base
  def test_mail(params_to_test)
    mail(params_to_test) do |format|
        format.html { render(text: "Oi :P") }
      end
  end
end

class CorrectResponse
  def headers
    { "status" => "200" }
  end

  def parsed_response
    # Transaction ID
    "1234567890"
  end
end

class IncorrectResponse
  def headers
    { "status" => "403" }
  end

  def parsed_response
    "Not authorized"
  end
end

