FactoryBot.define do
  factory :post do
    title { "Post title" }
    body { "Post body" }
    status { "draft" }

    trait :published do
      status { "published" }
    end

    trait :empty do
      body { "" }
    end

    trait :with_comments do
      after(:create) do |post, _evaluator|
        create_list(:comment, 3, post: post)
      end
    end
  end
end