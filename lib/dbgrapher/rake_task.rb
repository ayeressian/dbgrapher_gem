require "dbgrapher/version"
require "dbgrapher/generate"
require "rake"

module Dbgrapher
  class RakeTask
    include Rake::DSL
    def initialize(task_namespace: :dbgrapher, schema_path: './db/dbgrapher.json')
      namespace(task_namespace) do
        desc "Generates dbgrapher.json"
        task gen: :environment do
          Dbgrapher::Generate.new(schema_path: schema_path).run
        end
      end
    end
  end
end
