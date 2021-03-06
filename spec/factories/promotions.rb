FactoryBot.define do
  factory :promotion do
    sequence(:name) { |n| "Natal#{n*10}" }
    sequence(:code) { |n| "NATAL#{n*10}" }
    discount_rate { 10 }
    coupon_quantity { 5 }
    maximum_discount { 50 }
    expiration_date { 1.day.from_now }
    association :creator, email: 'maria@locaweb.com.br', factory: :user

    trait :approved do
      after(:build) do |promotion|
        promotion.curator = create(:user)
        promotion.save
      end
    end

    trait :blank do
      name { '' }
      code { '' }
      discount_rate {  }
      coupon_quantity {  }
      maximum_discount {  }
      expiration_date {  }
    end

    trait :expired do
      expiration_date { 1.day.ago }
    end

    trait :with_product_category do
      transient do
        product_category_count { 1 }
      end

      after(:build) do |promotion, evaluator|
        promotion.product_categories = create_list(:product_category, evaluator.product_category_count)
        promotion.save
      end
    end

    trait :with_coupons do
      after(:create) do |promotion|
        promotion.coupons = create_list(:coupon, promotion.coupon_quantity, promotion: promotion)
      end
    end
  end
end
