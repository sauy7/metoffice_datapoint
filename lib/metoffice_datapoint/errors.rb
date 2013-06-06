module MetofficeDatapoint
  module Errors
    class GeneralError < StandardError; end
    class ForbiddenError < StandardError; end
    class NotFoundError < StandardError; end
    class SystemError < StandardError; end
    class UnavailableError < StandardError; end
  end
end
