require "spec_helper"

describe Mail::Madmimi, "ActionMailer load process" do
  it "registers as delivery method" do
    expect(ActionMailer::Base.delivery_methods[:mad_mimi]).to eq(Mail::Madmimi::Sender)
  end
end

describe Mail::Madmimi, "ActionMailer integration process" do
  let(:email) { TestMailer.test_mail(promotion_name: "Bla", to: "hi@hi.com") }
  let(:valid_settings) { { username: "none@example.com", api_key: "1234567890" } }

  before do
    ActionMailer::Base.delivery_method = :mad_mimi
    ActionMailer::Base.mad_mimi_settings = valid_settings
  end

  it "Madmimi::Sender instance receives the mail to send after delivering it" do
    allow_any_instance_of(Mail::Madmimi::Sender).to receive(:deliver!).with(email)
    email.deliver
  end
end
