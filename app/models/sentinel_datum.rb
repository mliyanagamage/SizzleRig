class SentinelDatum < ApplicationRecord
  validates :unique_hash, presence: true, uniqueness: true
end
