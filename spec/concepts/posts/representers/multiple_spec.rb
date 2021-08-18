require "rails_helper"

RSpec.describe Posts::Representers::Multiple do
  let(:post_1) { create :post, created_at: DateTime.new(2021,8,18) }
  let(:post_2) { create :post, created_at: DateTime.new(2021,8,19) }
  let(:posts) { [post_1, post_2] }

  subject(:multiple) { described_class.new(posts).call }

  describe ".call" do
    it "returns proper hash" do
      expect(multiple).to eq(
        [
          {
            id: post_1.id,
            title: post_1.title,
            body: post_1.body,
            created: "Wednesday, August 18, 2021"
          },
          {
            id: post_2.id,
            title: post_2.title,
            body: post_2.body,
            created: "Thursday, August 19, 2021"
          }
        ]
      )
    end
  end
end