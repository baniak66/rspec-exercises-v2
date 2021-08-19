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

    context "just check how factory bot works" do
      let(:comment) { create :comment, post: post }
      let(:post) { create :post, title: "new post", status: "published" }
      let(:post_2) { create :post, :published }
      let(:post_3) { create :post, :published, :empty }
      let(:post_4) { create :post, :with_comments }

      it do
        # byebug
      end
    end
  end

  describe "GET /posts" do
    let(:post) { create :post, created_at: DateTime.new(2021,8,18), updated_at: DateTime.new(2021,8,18) }
    let(:post_2) { create :post, created_at: DateTime.new(2021,8,18), updated_at: DateTime.new(2021,8,18) }
    let(:multiple_representer) do
      instance_double(Posts::Representers::Multiple, call: posts_array)
    end
    let(:posts_array) { [post, post_2] }

    before do
      allow(Posts::Representers::Multiple)
        .to receive(:new).and_return(multiple_representer)
    end

    it "returns success" do
      get("/posts")
      expect(response.status).to eq(200)
    end

    context "when sample param is set" do
      let(:sample) { 2 }

      it "returns success" do
        get("/posts", params: { sample: 3 })
        expect(response.status).to eq(200)
      end

      it "returns proper number of posts" do
        get("/posts", params: { sample: sample })
        expect(JSON.parse(response.body).count).to eq(sample)
      end

      it "returns proper posts" do
        get("/posts", params: { sample: sample })
        expect(JSON.parse(response.body)).to eq(
          [
            {
              "body"=>post.body,
              "created_at"=>post.created_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
              "id"=>post.id,
              "status"=>post.status,
              "title"=>post.title,
              "updated_at"=>post.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
            },
            {
              "body"=>post_2.body,
              "created_at"=>post_2.created_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
              "id"=>post_2.id,
              "status"=>post_2.status,
              "title"=>post_2.title,
              "updated_at"=>post_2.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
            }
          ]
        )
      end
    end
  end
end