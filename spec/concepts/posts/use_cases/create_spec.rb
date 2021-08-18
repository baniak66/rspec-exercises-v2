require "rails_helper"

RSpec.describe Posts::UseCases::Create do
  describe ".call" do
    let(:params) do
      {
        title: title,
        body: "post body"
      }
    end
    let(:title) { "new title" }

    subject(:create_post) { described_class.new(params).call }

    it "creates new post" do
      expect { create_post }.to change { Post.count }.by(1)
    end

    it "creates new post" do
      expect { create_post }.to change { Post.count }.from(0).to(1)
    end

    it "returns Post object" do
      expect(create_post).to be_a_kind_of(Post)
    end

    it "creates post with proper attributes" do
      expect(create_post).to have_attributes(params)
    end

    context "when params are invalid" do
      let(:title) { nil }

      it "creates new post" do
        expect { create_post }.not_to change { Post.count }
      end

      it "return errors" do
        expect(create_post.errors.full_messages).to eq(["Title can't be blank"])
      end
    end
  end
end