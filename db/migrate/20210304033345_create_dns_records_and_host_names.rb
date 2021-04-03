class CreateDnsRecordsAndHostNames < ActiveRecord::Migration[6.1]
  def change
    create_table :dns_records do |t|
      t.string :ip
      t.timestamps
    end

    create_table :hostnames do |t|
      t.string :hostname
      t.belongs_to :dns_record
      t.timestamps
    end

    add_index :hostnames, :hostname
  end
end
