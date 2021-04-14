[![CI](https://github.com/ayeressian/dbgrapher_gem/actions/workflows/ci.yml/badge.svg)](https://github.com/ayeressian/dbgrapher_gem/actions/workflows/ci.yml)

# Dbgrapher

This is a library that provides rake task to be used with rails application to generate dbgrapher.com db schema file.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dbgrapher'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install dbgrapher

In the lib/tasks directory create dbgrapher.rake file with the following content

```ruby
require "dbgrapher/rake_task"

Dbgrapher::RakeTask.new()
```

Then run rake

    dbgrapher:gen

In the `db/schema directory` it will generate `dbgrapher.json` file.
Now in your browser (preferably chrome) navigate to [dbgrapher.com](https://dbgrapher.com). In the "Please select a cloud provider." dialog select "None". In the following dialog select "Open". Open the `db/schema/dbgrapher.json` file. Move the tables to appropriate positions. Then from "File" top menu select save. In case you're not using chrome you should select "Download" from "File" top menu and copy the downloaded file to the `db/schema/dbgrapher.json`.
Every time a new table is being added to the database the top procedure should be performed. Note its only necessary to position the newly added tables, the previously positioned table positions are persisted.
Don't forget to commit your dbgrapher.json file. It contains information about the table positions.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dbgrapher.

