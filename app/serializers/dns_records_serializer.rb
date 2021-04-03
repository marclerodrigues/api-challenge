class DnsRecordsSerializer
  def initialize(records:, total:)
    @records = records
    @total = total
  end

  def as_json
    {
      total_records: total,
    }.merge(records.slice(:records, :related_hostnames))
  end

  private

  attr_reader :total

  def records
    return @_records if defined?(@_records)

    @_records ||= @records.as_json.reduce({
      records: [],
      hostnames: {},
      related_hostnames: []
    }) do |acc, r|
      record = r.slice("id", "ip_address")
      hostnames = r["related_hostnames"]

      acc[:records].push(record)

      hostnames.each do |hostname|
        hostname_key = hostname.keys.first

        if acc[:hostnames][hostname_key]
          acc[:hostnames][hostname_key] += 1
        else
          acc[:hostnames][hostname_key] = 1
        end
      end

      acc[:related_hostnames] = []

      acc[:hostnames].each do |k, v|
        acc[:related_hostnames].push( { hostname: k, count: v })
      end

      acc
    end
  end
end
