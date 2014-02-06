require 'spec_helper'

describe Mail::Madmimi::Sender do
  let(:valid_settings) { { username: "none@example.com", api_key: "1234567890" } }
  let(:mimi_sender) { described_class.new valid_settings }
  let(:email) { TestMailer.test_mail }

  context "Create without api key or username" do
    it "should raise an error" do
      expect { described_class.new }.to raise_error Mail::Madmimi::Sender::MadmimiError
    end
  end

  describe "email_post_body" do
    context "return a hash with mimi required attributes" do
      it "promotion_name" do
        mimi_sender.email_post_body(email)[:promotion_name].should == "Promo"
      end

      it "from" do
        mimi_sender.email_post_body(email)[:from].should == "from@example.org"
      end

      it "recipient" do
        mimi_sender.email_post_body(email)[:recipient].should == "somebody@example.org"
      end

      it "bcc" do
        mimi_sender.email_post_body(email)[:bcc].should == "bcc@example.org"
      end

      it "subject" do
        mimi_sender.email_post_body(email)[:subject].should == "Some subject"
      end

      it "raw_html" do
        mimi_sender.email_post_body(email)[:raw_html].should == "Oi :P"
      end
    end
  end

  describe "parse_response" do
    context "Received a ok response" do
      let(:ok_reponse) { CorrectResponse.new }

      it { mimi_sender.parse_response(ok_reponse).should == "1234567890" }
    end

    context "Received a non ok response" do
      let(:invalid_response) { IncorrectResponse.new }

      it "raises an error" do
        expect { mimi_sender.parse_response(invalid_response) }
          .to raise_error Mail::Madmimi::Sender::MadmimiError
      end
    end
  end

  describe "deliver!" do
    it "posted the email" do
      Mail::Madmimi::Sender.should_receive(:post).and_return(CorrectResponse.new)
      mimi_sender.deliver!(email)
    end

    it "posted with correct path" do
      Mail::Madmimi::Sender.should_receive(:post)
        .with('/mailer', anything)
        .and_return(CorrectResponse.new)
      mimi_sender.deliver!(email)
    end

    it "posted with correct body" do
      Mail::Madmimi::Sender.should_receive(:post)
        .with(anything, body: mimi_sender.email_post_body(email))
        .and_return(CorrectResponse.new)
      mimi_sender.deliver!(email)
    end
  end
end