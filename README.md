# TodoConsoleApp

[![Build Status](https://travis-ci.com/barmic12/todo_console_app.svg?branch=master)](https://travis-ci.com/barmic12/todo_console_app)

Application provides simple interface to manage you tasks using list.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'todo_console_app'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install todo_console_app

## Usage

You can run application using it in IRB:

Run console:

    $ irb

Require lib:

    $ require 'todo_console_app

Run todo list:

    $ TodoConsoleApp::App.run
    

Application provides user friendly interface using [cli-ui](https://github.com/Shopify/cli-ui).

As a user you can:

* add task
* remove task
* complete task
* list all tasks
* list only completed tasks
* list only uncompleted tasks

List of tasks is stored locally, using sqlite3 database.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/todo_console_app.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
