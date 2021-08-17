module Posts
  module UseCases
    class Update
      def initialize(post_id, params)
        @post_id = post_id
        @params = params
      end

      def call
        post = Post.find(post_id)
        post.update(params)
        post
      end

      private

      attr_reader :post_id, :params
    end
  end
end