require 'httparty'

module Mail
  module Madmimi
    class Sender
      class MadmimiError < StandardError; end
      attr_accessor :settings

      include ::HTTParty
      base_uri 'https://api.madmimi.com'

      def initialize(settings = {})
        unless settings[:username] && settings[:api_key]
          raise MadmimiError, "Missing username or api_key"
        end

        self.settings = settings
      end

      def deliver!(mail)
        resp = self.class.post '/mailer', body: email_post_body(mail)
        parse_response(resp)
      end

      def parse_response(resp)
        case resp.headers["status"].to_i
          when 200..299 then resp.parsed_response
          else raise MadmimiError.new "status=#{resp.headers["status"]}; " + resp.parsed_response
        end
      end

      def email_post_body(mail)
        options = settings.merge(
          recipients:     mail[:to].to_s.gsub(",", ";"),
          promotion_name: mail[:promotion_name].to_s,
          subject:        mail.subject.to_s,
          raw_html:       html_data(mail).to_s
        )

        options.merge!(from: mail[:from].to_s) unless mail[:from].to_s.empty?
        options.merge!(bcc:  mail[:bcc].to_s)  unless mail[:bcc].to_s.empty?

        boolean_params = [:check_suppressed, :track_links, :hidden,
          :skip_placeholders, :remove_unsubscribe]

        boolean_params.each do |param|
          options.merge!(param => mail[param].to_s) unless mail[param].to_s.empty?
        end

        options
      end

      def html_data(mail)
        html_data = mail.find_first_mime_type('text/html')

        if html_data
          html_data.body
        else
          mail.mime_type == 'text/html' ? mail.body : nil
        end
      end
    end
  end
end