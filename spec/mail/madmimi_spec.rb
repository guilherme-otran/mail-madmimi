require 'action_mailer'
require 'spec_helper'

describe Mail::Madmimi, "ActionMailer load process" do
  it "should register as delivery method" do
    ActionMailer::Base.delivery_methods[:mad_mimi].should == Mail::Madmimi::Sender
  end
end