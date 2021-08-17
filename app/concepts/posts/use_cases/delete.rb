module Posts
  module UseCases
    class Delete
      def initialize(post_id)
        @post_id = post_id
      end

      def call
        post.destroy
      end

      private

      attr_reader :post_id

      def post
        Post.find(post_id)
      end
    end
  end
end
