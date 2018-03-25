class ShortLink < ApplicationRecord
  #has_secure_password validations: false
  validates :url, presence: true, format: URI::regexp(%w(http https))
end
