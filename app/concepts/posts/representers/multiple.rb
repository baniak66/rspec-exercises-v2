module Posts
  module Representers
    class Multiple
      def initialize(posts)
        @posts = posts
      end

      def call
        posts.map do |post|
          Posts::Representers::Single.new(post).call
        end
      end

      private

      attr_reader :posts
    end
  end
end
