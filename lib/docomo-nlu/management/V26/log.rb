# frozen_string_literal: true

module DocomoNlu
  module Management::V26
    class Log < Base
      self.element_name = "logs"
      self.prefix = "/management/v2.6/projects/:project_id/"

      # Format of params:
      # => {
      # =>  "details":[
      # =>   {"operation":"","target":"input","query":"Hello"},
      # =>   {"operation":"AND","target":"","query":"xx"},
      # =>  ]
      # => }
      # operation: NOT or Empty in leading line, others are AND|OR|NOT.
      # target: input|output|startTopic|endTopic|userId|language|projectSpecific|responseTime_less_than|responseTime_greater_than
      # => It is possible to ambiguous search using "*" in the following target ( input|output|startTopic|endTopic|userId|language|projectSpecific)
      # query: String search within 200 characters.

      def download(params={})
        return JSON.parse(connection.post(collection_path(prefix_options), params.to_json, self.class.headers).body)
      end

      def count(params={})
        return JSON.parse(connection.post("#{collection_path(prefix_options)}/count", params.to_json, self.class.headers).body)["count"]
      end

      def all
        p "You shoud use 'download' or 'count' method"
      end

      def find
        p "You shoud use 'download' or 'count' method"
      end

      def where
        p "You shoud use 'download' or 'count' method"
      end
    end
  end
end
