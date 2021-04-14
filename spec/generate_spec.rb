require "dbgrapher/rake_task"
require "byebug"
require "rake"

RSpec.describe Dbgrapher::Generate do
  let(:path) { "./test.json" }

  subject { Dbgrapher::Generate.new(schema_path: path) }

  before do
    module ActiveRecord
      class Base
        @@connectionTest = Class.new do
        end.new

        def self.connection
          return @@connectionTest
        end
      end
    end

    module JSON
      def self.pretty_generate(hash)
      end
    end

    column1_table1 = double(name: "id", type: "int")
    column2_table1 = double(name: "test_column_fk", type: "string")
    column1_table2 = double(name: "id", type: "int")
    column2_table2 = double(name: "test_column2", type: "string")

    fk = double(options: { column: "test_column_fk", primary_key: "id" }, to_table: "test_table2")

    allow(ActiveRecord::Base::connection).to receive(:tables) { ["test_table1", "test_table2"] }
    allow(ActiveRecord::Base::connection).to receive(:columns).with("test_table1") { [column1_table1, column2_table1] }
    allow(ActiveRecord::Base::connection).to receive(:columns).with("test_table2") { [column1_table2, column2_table2] }
    allow(ActiveRecord::Base::connection).to receive(:foreign_keys).with("test_table1") { [fk] }
    allow(ActiveRecord::Base::connection).to receive(:foreign_keys).with("test_table2") { [] }
    allow(ActiveRecord::Base::connection).to receive(:primary_keys).with("test_table1") { ["id"] }
    allow(ActiveRecord::Base::connection).to receive(:primary_keys).with("test_table2") { ["id"] }
    allow(File).to receive(:write) { }
  end

  it "parses correctlly" do
    expected_result = { tables: [{ columns: [{ name: "id", pk: true, type: "int" },
                                            { fk: { column: "id", table: "test_table2" },
                                              name: "test_column_fk",
                                              type: "string" }],
                                  name: "test_table1" },
                                { columns: [{ name: "id", pk: true, type: "int" },
                                            { name: "test_column2", type: "string" }],
                                  name: "test_table2" }] }
    expect(JSON).to receive(:pretty_generate).with(expected_result)
    subject.run
  end
end
