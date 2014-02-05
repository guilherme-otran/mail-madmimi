require 'action_mailer'
require 'spec_helper'

class TestMailer < ActionMailer::Base
  def test_mail
    mail to: "somebody@example.org", promotion_name: "Promo" do |format|
      format.html { render(text: "Oi :P") }
    end
  end
end

describe Mail::Madmimi::Sender do
  let(:valid_settings) { { username: "none@example.com", api_key: "1234567890" } }
  let(:mimi_sender) { described_class.new valid_settings }

  context "Create without api key or username" do
    it "should raise an error" do
      expect { described_class.new }.to raise_error Mail::Madmimi::Sender::MadmimiError
    end
  end

  context "Promotion name aditional parameter" do
    let(:email) { TestMailer.test_mail }

    it "email_body should return options with correct promotion_name" do
      mimi_sender.send(:email_body, email)[:promotion_name].should == "Promo"
    end
  end
end