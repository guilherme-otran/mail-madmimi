require 'spec_helper'

describe Mail::Madmimi, "ActionMailer load process" do
  it "should register as delivery method" do
    ActionMailer::Base.delivery_methods[:mad_mimi].should == Mail::Madmimi::Sender
  end
end

describe Mail::Madmimi, "ActionMailer integration process" do
  let(:email) { TestMailer.test_mail(promotion_name: "Bla", to: "hi@hi.com") }
  let(:valid_settings) { { username: "none@example.com", api_key: "1234567890" } }

  before do
    ActionMailer::Base.delivery_method = :mad_mimi
    ActionMailer::Base.mad_mimi_settings = valid_settings
  end

  it "Madmimi::Sender instance should receive the mail to send after delivering it" do
    Mail::Madmimi::Sender.any_instance.should_receive(:deliver!).with(email)
    email.deliver
  end
end