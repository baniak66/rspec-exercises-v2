require "rails_helper"

RSpec.describe Posts::Representers::Single do
  let(:post) { create :post, created_at: DateTime.new(2021,8,18) }
  let(:instance) { described_class.new(post) }
  let(:expected_hash) do
    {
      id: post.id,
      title: post.title,
      body: post.body,
      created: "Wednesday, August 18, 2021"
    }
  end

  subject { instance.call }

  describe ".call" do
    it "returns hash with proper structure" do
      expect(subject).to eq(expected_hash)
    end
  end
end