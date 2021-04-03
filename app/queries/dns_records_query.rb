class DnsRecordsQuery
  def self.all(params)
    new(params).all
  end

  def initialize(params)
    @excluded = params.fetch(:excluded, nil)
    @included = params.fetch(:included, [])
  end

  def all
    including_records
      .where.not(ip: dns_records_ips(excluded))
      .where.not(hostnames(included))
      .group(by_records_id)
      .select(fields)
  end

  private

  attr_reader :included, :excluded

  def including_records
    if included.any?
      relation
        .where(ip: dns_records_ips(included))
    else
      relation
    end
  end

  def fields
    @_fields ||= <<-HEREDOC
      dns_records.id,
      dns_records.ip as ip_address,
      json_agg(
        json_build_object(hostnames.hostname, 1)
      ) as related_hostnames
    HEREDOC
  end

  def by_records_id
    @_by_records_id ||= 'dns_records.id'
  end

  def hostnames(records)
    ["hostnames.hostname IN (?)", records&.any? ? records : ['']]
  end

  def dns_records_ips(records)
    relation.where(hostnames(records)).select(:ip)
  end

  def relation
    @_relation ||= DnsRecord.joins(:hostnames)
  end
end
