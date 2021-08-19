FactoryBot.define do
  factory :comment do
    post
    sequence(:author) { |n| "author no #{n}" }
    body { "Comment body" }
  end
end