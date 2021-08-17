FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "Post title no #{n}" }
    body { "Lorem ipsum" }
  end
end