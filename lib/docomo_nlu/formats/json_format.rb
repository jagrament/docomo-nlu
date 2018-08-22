# Override json_format class's decode functions

# Why:
# This format is that ActiveResource expected when API call.
# [{"key": "value"},{"key":"value"},...]
# or
# {"object": [{"key": "value"},{"key":"value"},...]}
#
# But NLPManagementAPI returns here when resources count = 0. hahahaha
# {
#  "object": null
# }
#
# It does not conform to the specification of json.
# Of cource ActiveResource does not supported
#

module DocomoNlu
  module Formats
    class JsonFormat
      include ActiveResource::Formats


      def extension
        'json'
      end

      def mime_type
        'application/json'
      end

      def encode(hash, options = nil)
        ActiveSupport::JSON.encode(hash, options)
      end

      def decode(json)
        if json.present?
          data = ActiveSupport::JSON.decode(json).values.first
        end
      end
    end
  end
end
