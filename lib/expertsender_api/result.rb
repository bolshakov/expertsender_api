module ExpertSenderApi
  class Result
    attr_reader :response, :parsed_response, :error_code, :error_message
    SUCCESS_CODES = [200, 201, 202, 204].freeze

    def initialize(response)
      @response = response

      if (@response.body)
        @parsed_response = Nokogiri::XML(@response.body)

        if @parsed_response.xpath('//ErrorMessage').any?
          @error_message = @parsed_response.xpath('//ErrorMessage/Message').text
          @error_code = @parsed_response.xpath('//ErrorMessage/Code').text
        end
      end

      freeze
    end

    def success?
      status_success? and
      error_code.nil? and
      error_message.nil?
    end

    def failed?
      not success?
    end

    def status_success?
      SUCCESS_CODES.include?(response.code)
    end
  end
end

