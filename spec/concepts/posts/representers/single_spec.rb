require "rails_helper"

RSpec.describe Posts::Representers::Single do
  let(:post) { create :post, created_at: DateTime.new(2021,8,18) }

  subject(:single) { described_class.new(post).call }

  describe ".call" do
    it "returns proper hash" do
      expect(single).to eq(
        {
          id: post.id,
          title: post.title,
          body: post.body,
          created: "Wednesday, August 18, 2021"
        }
      )
    end
  end
end