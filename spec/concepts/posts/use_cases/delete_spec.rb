require "rails_helper"

RSpec.describe Posts::UseCases::Delete do
  let!(:post) { create :post, title: "title", body: "body" }
  let(:instance) { described_class.new(post.id) }

  subject { instance.call }

  describe ".call" do
    it "deletes post" do
      expect { subject }.to change { Post.count }.from(1).to(0)
    end

    it "deletes post" do
      expect { subject }.to change { Post.count }.by(-1)
    end
  end
end