class SentinelDatum < ApplicationRecord
  validates :sentinel_id, uniqueness: true
end
