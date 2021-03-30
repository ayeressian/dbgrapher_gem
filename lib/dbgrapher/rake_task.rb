require "dbgrapher/version"
require "rake"

module Dbgrapher
  class RakeTask
    include Rake::DSL
    def initialize(task_namespace: :dbgrapher, schema_path: './db/dbgrapher.json')
      namespace(task_namespace) do
        desc "TODO"
        task gen: :environment do
          @result = File.exists?(schema_path) ?
            JSON.parse(File.read(schema_path), {:symbolize_names => true}) :
            {tables: []}

          @deleted_tables = @result[:tables].map {|table| table[:name]}
          ActiveRecord::Base.connection.tables.each(&self.method(:parse_table))
          @result[:tables] = @result[:tables].filter {|table| !@deleted_tables.find {|deleted_table| table[:name] === deleted_table}} 
          File.write(schema_path, @result.to_json)
        end
      end
    end

    private

    def parse_column(column, table_name)
      fks = ActiveRecord::Base.connection.foreign_keys(table_name)
      pks = ActiveRecord::Base.connection.primary_keys(table_name)
      formatted_column = {
        name: column.name,
        type: column.type,
      }

      fk = fks.find {|fk| fk.options[:column] === column.name}

      if !fk.nil?
        formatted_column[:fk] = {
          table: fk.to_table,
          column: fk.options[:primary_key]
        }
      end

      formatted_column[:pk] = true if pks.find {|pk| pk === column.name}

      formatted_column
    end

    def parse_table(table_name)
      table = @result[:tables].find {|table| table[:name] === table_name }
      new_table = table.nil?
      @deleted_tables.delete_if { |deleted_table| deleted_table === table_name }
      table ||= {
        name: table_name,
      }
      
      table[:columns] = ActiveRecord::Base.connection.columns(table_name).map {|column| parse_column(column, table_name)}
      @result[:tables].push(table) if new_table
    end
  end
end
