require "rails_helper"

RSpec.describe Posts::Representers::Multiple do
  let(:post_1) { create :post, created_at: DateTime.new(2021,8,18) }
  let(:post_2) { create :post, created_at: DateTime.new(2021,7,17)}
  let(:posts) { [post_1, post_2] }
  let(:instance) { described_class.new(posts) }
  let(:expected_array) do
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
        created: "Saturday, July 17, 2021"
      },

    ]
  end

  subject { instance.call }

  describe ".call" do
    it "returns hash with proper structure" do
      expect(subject).to eq(expected_array)
    end
  end
end