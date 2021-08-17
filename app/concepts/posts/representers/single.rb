module Posts
  module Representers
    class Single
      def initialize(post)
        @post = post
      end

      def call
        {
          id: post.id,
          title: post.title,
          body: post.body,
          created: post.created_at.strftime("%A, %B %e, %Y")
        }
      end

      private

      attr_reader :post
    end
  end
end
