require "rails_helper"

RSpec.describe "Posts requests", type: :request do
  describe "GET /posts" do
    context "when no posts in db" do
      before { get("/posts") }

      it "works and return status 200" do
        expect(response.status).to eq(200)
      end

      it "returns proper json response" do
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context "when posts records in db" do
      context "when one post in db" do
        let!(:post) { create :post, created_at: DateTime.new(2021,8,18) }
        let(:post_attr) do
          {
            "id" => post.id,
            "title" => post.title,
            "body" => post.body,
            "created" => "Wednesday, August 18, 2021"
          }
        end
        let(:expected_response) { [post_attr] }

        before { get("/posts") }

        it "works and return status 200" do
          expect(response.status).to eq(200)
        end

        it "returns proper json response" do
          expect(JSON.parse(response.body)).to eq(expected_response)
        end
      end
    end

    context "when sample posts requested" do
      before do
        create_list(:post, 3)
        get("/posts", params: { sample: 2 })
      end

      it "works and return status 200" do
        expect(response.status).to eq(200)
      end

      it "returns proper number of posts in response" do
        expect(JSON.parse(response.body).count).to eq(2)
      end
    end
  end

  describe "GET /posts/:id" do
    let(:post) { create :post }

    it "returns success status" do
      get("/posts/#{post.id}")
      expect(response.status).to eq(200)
    end

    it "returns proper json" do
      get("/posts/#{post.id}")
      expect(JSON.parse(response.body).keys).to match_array(%w(id body title created))
      # expect(JSON.parse(response.body).keys).to eq(%w(id body title)) !!! order
    end

    context "when we mock representer" do
      let(:single_post_representer) do
        instance_double(Posts::Representers::Single, call: { id: "abc" })
      end

      before do
        allow(Posts::Representers::Single)
          .to receive(:new)
          .with(post)
          .and_return(single_post_representer)
      end

      it "calls proper representer" do
        expect(single_post_representer).to receive(:call)

        get("/posts/#{post.id}")
      end

      it "renders body returned by represener" do
        get("/posts/#{post.id}")
        expect(JSON.parse(response.body)).to eq("id" => "abc")
      end
    end
  end

  describe "POST /posts" do
    let(:params) do
      {
        post: {
          title: title,
          body: "body updated"
        }
      }
    end
    let(:title) { "title" }

    subject { post("/posts", params: params) }

    it "retuns created status" do
      subject
      expect(response.status).to eq(201)
    end

    context "when invalid post params" do
      let(:title) { nil }

      it "retuns unprocessable_entity status" do
        subject
        expect(response.status).to eq(422)
      end
    end

    context "when use_case returns invalid post" do
      let(:create_usecase) do
        instance_double("Posts::UseCases::Create", call: invalid_post)
      end
      let(:invalid_post) do
        instance_double("Post", valid?: false, errors: { title: ["can't be blank"] } )
      end

      before do
        allow(Posts::UseCases::Create).to receive(:new).and_return(create_usecase)
      end

      it "retuns unprocessable_entity status" do
        subject
        expect(response.status).to eq(422)
      end
    end
  end

  describe "PUT /posts/:id" do
    let(:post) { create :post, title: "title", body: "body" }
    let(:params) do
      {
        id: post.id,
        post: {
          title: title,
          body: "body updated"
        }
      }
    end
    let(:title) { "title updated" }

    subject { put("/posts/#{post.id}", params: params) }

    context "when params are valid" do
      it "retuns success status" do
        subject
        expect(response.status).to eq(200)
      end

      it "updates post params" do
        expect { subject }
          .to change { post.reload.title }.from("title").to("title updated")
          .and change { post.reload.body }.from("body").to("body updated")
      end
    end

    context "when params not valid" do
      let(:title) { nil }
      let(:expected_response) { { "title"=>["can't be blank"] } }

      it "retuns unprocess entity status" do
        subject
        expect(response.status).to eq(422)
      end

      it "retuns response with error message" do
        subject
        expect(JSON.parse(response.body)).to eq(expected_response)
      end
    end
  end

  describe "DELETE /posts/:id" do
    let(:post) { create :post }

    subject { delete("/posts/#{post.id}") }

    it "retuns no content status" do
      subject
      expect(response.status).to eq(204)
    end
  end
end