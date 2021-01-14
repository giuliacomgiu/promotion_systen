class Coupon < ApplicationRecord
  belongs_to :promotion

  enum status: { active: 0, archived: 1 }

  def name
    "#{code} (#{Coupon.human_attribute_name("status.#{status}")})"
  end
end
