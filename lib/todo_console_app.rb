#require "todo_console_app/version"
require 'sequel'
ENV['RUBY_ENV'] ||= 'development'

module TodoConsoleApp


  class TodoList
    attr_reader :list, :tasks_table

    database_path = "database/todos_#{ENV['RUBY_ENV']}.db"
    DB = Sequel.sqlite(database_path)

    def initialize
      @list = Array.new

      unless DB.table_exists? :tasks
        DB.create_table(:tasks) do
            primary_key :id
        String :title
        Boolean :completed
        end

      end

      @tasks_table = DB[:tasks]

    end

    def add_to_list(task)
      @list.push(task)
      save_to_database(task)
    end

    def remove_from_list(task)
      @list.delete(task)
      remove_from_database(task)
    end

    def complete(task)
      task.complete
      update_in_database(task)
    end

    def filtered_list(filter=:all)
      case filter
      when :all then @list
      when :completed then @list.select { |task| task.completed? }
      when :incompleted then @list.select { |task| !task.completed? }
      else
        raise ArgumentError.new("Wrong argument. Only :all, :completed, :incompleted are allowed.")
      end
    end

    private

    def save_to_database(task)
      DB[:tasks].insert(title: task.title, completed: task.completed)
    end

    def remove_from_database(task)
      DB[:tasks].where(title: task.title).delete
    end

    def update_in_database(task)
      DB[:tasks].where(title: task.title).update(completed: true)
    end

  end

  class Task
    attr_reader :title, :completed

    def initialize(title)
      @title = title
      @completed = false
    end

    def completed?
      @completed ? true : false
    end

    def complete
      @completed = true
    end

  end
end
