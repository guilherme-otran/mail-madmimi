require "spec_helper"

describe Mail::Madmimi::Sender do
  let(:valid_settings) { { username: "none@example.com", api_key: "1234567890" } }
  let(:mimi_sender) { described_class.new valid_settings }
  let(:email_basic_options) { { to: "somebody@example.org", promotion_name: "Promo", subject: "Hi" } }
  let(:email) { TestMailer.test_mail(email_basic_options) }

  context "Create without api key or username" do
    it "raises an error" do
      expect { described_class.new }.to raise_error Mail::Madmimi::Sender::MadmimiError
    end
  end

  describe "#email_post_body" do
    context "return a hash with mimi required attributes" do
      describe "promotion_name" do
        subject { mimi_sender.email_post_body(email)[:promotion_name] }
        it { is_expected.to eq("Promo") }
      end

      describe "recipients" do
        subject { mimi_sender.email_post_body(email)[:recipients] }
        it { is_expected.to eq("somebody@example.org") }
      end

      describe "raw_html" do
        subject { mimi_sender.email_post_body(email)[:raw_html] }
        it { is_expected.to eq("Oi :P") }
      end

      describe "subject" do
        subject { mimi_sender.email_post_body(email)[:subject] }
        it { is_expected.to eq("Hi") }
      end
    end

    context "optional string attributes" do
      [:from, :bcc].each do |attribute|
        context "when #{attribute} is present" do
          let(:mail_options) { email_basic_options.merge(attribute => attribute.to_s) }
          let(:email) { TestMailer.test_mail(mail_options) }

          subject { mimi_sender.email_post_body(email)[attribute] }
          it { is_expected.to eq(attribute.to_s) }
        end

        context "when #{attribute} is absent" do
          subject { mimi_sender.email_post_body(email) }
          it { is_expected.to_not have_key(attribute) }
        end
      end
    end

    context "optional boolean params" do
      booleans = [:check_suppressed, :track_links, :hidden,
                  :skip_placeholders, :remove_unsubscribe]

      booleans.each do |attribute|
        [:on, :off].each do |boolean|
          context "when #{attribute} is #{boolean}" do
            let(:mail_options) { email_basic_options.merge(attribute => boolean) }
            let(:email) { TestMailer.test_mail(mail_options) }

            subject { mimi_sender.email_post_body(email)[attribute] }
            it { is_expected.to eq(boolean.to_s) }
          end
        end

        context "when #{attribute} is absent" do
          subject { mimi_sender.email_post_body(email) }
          it { is_expected.to_not have_key(attribute) }
        end
      end
    end
  end

  describe "#parse_response" do
    context "Received a ok response" do
      let(:ok_reponse) { CorrectResponse.new }
      subject { mimi_sender.parse_response(ok_reponse) }

      it { is_expected.to eq("1234567890") }
    end

    context "Received a non ok response" do
      let(:invalid_response) { IncorrectResponse.new }
      subject(:parse_response) { mimi_sender.parse_response(invalid_response) }

      it { expect { parse_response }.to raise_error(Mail::Madmimi::Sender::MadmimiError) }
    end
  end

  describe "#deliver!" do
    it "posted the email" do
      expect(Mail::Madmimi::Sender).to receive(:post).and_return(CorrectResponse.new)
      mimi_sender.deliver!(email)
    end

    it "posted with correct path" do
      expect(Mail::Madmimi::Sender).to receive(:post)
        .with("/mailer", anything)
        .and_return(CorrectResponse.new)

      mimi_sender.deliver!(email)
    end

    it "posted with correct body" do
      expect(Mail::Madmimi::Sender).to receive(:post)
        .with(anything, body: mimi_sender.email_post_body(email))
        .and_return(CorrectResponse.new)

      mimi_sender.deliver!(email)
    end
  end
end
