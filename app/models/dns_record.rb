class DnsRecord < ApplicationRecord
  has_many :hostnames, inverse_of: :dns_record, dependent: :destroy

  accepts_nested_attributes_for :hostnames

  validates :ip, presence: true, uniqueness: true
  validate :ip_v4

  private

  def ip_v4
    ipAddress = IPAddr.new(ip)

    return true if ipAddress.ipv4?

    errors.add(:ip, :invalid, message: 'is an invalid IP V4 address' )
  rescue IPAddr::InvalidAddressError => _e
    errors.add(:ip, :invalid, message: 'is an invalid address' )
  end
end
