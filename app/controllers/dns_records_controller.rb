class DnsRecordsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def index
    @query = DnsRecordsQuery.all(params)
    @pagy, @dns_records = pagy(@query, items: 2, page: params[:page])
    @serialized_records = DnsRecordsSerializer.new(records: @dns_records, total: @pagy.count)

    render json: @serialized_records.as_json
  end

  def create
    @dns_record = DnsRecord.new(permitted_attributes)

    if @dns_record.save
      render json: { id: @dns_record.id }
    else
      render json: { errors: @dns_record.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def permitted_attributes
    params.require(:dns_records).permit(
      :ip,
      hostnames_attributes: [
        :hostname
      ]
    )
  end
end
