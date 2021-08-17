module Posts
  module UseCases
    class Create
      def initialize(params)
        @params = params
      end

      def call
        Post.create(params)
      end

      private

      attr_reader :params
    end
  end
end