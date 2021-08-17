require "rails_helper"

RSpec.describe Posts::UseCases::Update do
  let!(:post) { create :post, title: "title", body: "body" }
  let(:params) do
    {
      title: title,
      body: "body updated"
    }
  end
  let(:title) { "title updated" }
  let(:instance) { described_class.new(post.id, params) }

  subject { instance.call }

  describe ".call" do
    it "updates post" do
      expect { subject }
        .to change { post.reload.title }.from("title").to("title updated")
        .and change { post.reload.body }.from("body").to("body updated")
    end

    it "retuns post object" do
      expect(subject).to eq(post)
    end

    it "returns post object without errors" do
      expect(subject.errors).to be_empty
    end

    # it { is_expected.to eq true }
    # it { is_expected.to be_truthy } # !!!
    # it { expect("siema").to be_truthy } # !!!

    context "when params invalid" do
      let(:title) { nil }

      it "doesn't update post" do
        expect { subject }.not_to change { post.reload.title }
      end

      it { is_expected.to eq post }

      it "returns post object with errors array not empty" do
        expect(subject.errors).not_to be_empty
      end

      it "returns post object with proper errors" do
        expect(subject.errors).to match_array(["Title can't be blank"])
      end
    end
  end
end