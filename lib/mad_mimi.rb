module Mail
  class MadMimi
    class MadMimiError < StandardError;

    include HTTParty
    base_uri 'https://api.madmimi.com'

    def initialize(settings)
      @auth = settings
    end

    def deliver!(mail)
      resp = self.class.post '/mailer', body: email_body(mail)
      parse_response(resp)
    end

    def parse_response(resp)
      case resp.headers["status"]
        when 200..299 then resp.parsed_response
        else raise Error.new "status=#{resp.headers["status"]}; " + resp.parsed_response
      end
    end

    private
    def email_body(mail)
      {
        from:           mail[:from].to_s,
        recipient:      mail[:to].to_s,
        bcc:            mail[:bcc].to_s,
        subject:        mail.subject,
        promotion_name: mail[:promotion_name].to_s,
        raw_html:       html_data(mail).to_s
      }.merge @auth
    end

    def html_data(mail)
      html_data = mail.find_first_mime_type('text/html')

      if html_data
        html_data.body
      else
        mail.mime_type == 'text/html' ? mail.body : nil
      end
    end

    if defined? ActionMailer::Base
      ActionMailer::Base.add_delivery_method :mad_mimi, Mail::MadMimi
    end
  end
end