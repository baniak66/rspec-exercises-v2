require "rails_helper"

RSpec.describe "Posts requests", type: :request do
  describe "GET /posts/:id" do
    let(:post) { create :post, created_at: DateTime.new(2021,8,18) }

    it "returns success response" do
      get("/posts/#{post.id}")

      expect(response.status).to eq(200)
    end

    it "returns success response" do
      get("/posts/#{post.id}")

      expect(JSON.parse(response.body)).to eq(
        {
          "id" => post.id,
          "title" => post.title,
          "body" => post.body,
          "created" => "Wednesday, August 18, 2021"
        }
      )
    end

    context "when representer is mocked" do
      let(:single_represener) do
        instance_double(Posts::Representers::Single, call: { title: "test title" })
      end

      before do
        allow(Posts::Representers::Single)
          .to receive(:new)
          .with(post)
          .and_return(single_represener)
      end

      it "uses Posts::Representers::Single to create body" do
        expect(single_represener).to receive(:call)

        get("/posts/#{post.id}")
      end

      it "returns representer hash as body" do
        get("/posts/#{post.id}")

        expect(JSON.parse(response.body)).to eq(
          { "title" => "test title" }
        )
      end
    end
  end
end