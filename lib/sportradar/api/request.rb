module Sportradar
  module Api
    class Request

      include HTTParty

      attr_reader :url, :headers, :timeout, :api_key

      def base_setup(path, options={})
        @url = set_base(path)
        @headers = set_headers
        @api_key = options[:api_key]
        @timeout = options.delete(:api_timeout) || Sportradar::Api.config.api_timeout
      end

      def get(path, options={})
        base_setup(path, options)
        results = self.class.get(url, headers: headers, query: options, timeout: timeout)
        rescue Net::ReadTimeout, Net::OpenTimeout
          raise Sportradar::Api::Error::Timeout
        rescue EOFError
          raise Sportradar::Api::Error::NoData
      end

      private

      def set_base(path)
        protocol = !!Sportradar::Api.config.use_ssl ? "https://" : "http://"
        url = "#{protocol}api.sportradar.us"
        url += path
        url += ".#{Sportradar::Api.config.format}"
      end

      def set_headers
        {'Content-Type' => "application/#{Sportradar::Api.config.format}", 'Accept' => "application/#{Sportradar::Api.config.format}"}
      end

    end
  end
end

