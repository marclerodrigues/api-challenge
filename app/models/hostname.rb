class Hostname < ApplicationRecord
  belongs_to :dns_record

  validates :hostname, presence: true
end
