class Promotion < ApplicationRecord
  has_many :coupons, dependent: :destroy
  has_many :product_category_promotions
  has_many :product_categories, through: :product_category_promotions

  validates :name, :code, :discount_rate, :maximum_discount,
            :coupon_quantity, :expiration_date,
            presence: true

  validates :code, uniqueness: { case_sensitive: false }

  def product_categories
    super
      .pluck(:name)
      .to_sentence(two_words_connector: ', ', last_word_connector: ' e ')
  end

  def code
    self[:code].upcase if self[:code].present?
  end

  def code=(val)
    self[:code] = val.upcase
  end

  def expired?
    Time.now > expiration_date
  end

  def not_expired?
    !expired?
  end

  def issue_coupons!
    raise 'Cupons já foram gerados!' if coupons.any?
    raise 'A promoção já expirou' if expired?

    coupons
      .create_with(created_at: Time.now, updated_at: Time.now)
      .insert_all!(coupon_codes)
  end
  
  private

  def coupon_codes
    (1..coupon_quantity).map do |amount|
      { code: "#{code}-#{'%04d' % amount}" }
    end
  end
end
