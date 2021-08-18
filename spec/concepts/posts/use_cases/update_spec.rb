require "rails_helper"

RSpec.describe Posts::UseCases::Update do
  describe ".call" do
    let!(:post) { create :post }
    let(:params) do
      {
        title: "updated title",
        body: "updated body"
      }
    end

    subject(:update_post) { described_class.new(post.id, params).call }

    it "updates post title" do
      expect { update_post }
        .to change { post.reload.title }
        .from("Post title")
        .to("updated title")
    end

    it "updates post body" do
      expect { update_post }
        .to change { post.reload.body }
        .from("Post body")
        .to("updated body")
    end

    it "updates post" do
      expect { update_post }
        .to change { post.reload.body }
        .from("Post body")
        .to("updated body")
        .and change { post.reload.title }
        .from("Post title")
        .to("updated title")
    end
  end
end