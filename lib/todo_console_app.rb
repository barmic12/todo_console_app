require 'sequel'
ENV['RUBY_ENV'] ||= 'development'

module TodoConsoleApp


  class TodoList
    attr_reader :list, :tasks_table

    database_path = "database/todos_#{ENV['RUBY_ENV']}.db"
    DB = Sequel.sqlite(database_path)

    def initialize
      @list = Array.new
      @next_id = 1

      if DB.table_exists? :tasks
        DB[:tasks].select.each do |row|
          @list << Task.new(row[:title], row[:id], row[:completed])
        end
        @next_id = DB[:tasks].max(:id).nil? ? @next_id : DB[:tasks].max(:id) + 1
        puts "Data have been loaded from database!"
      else
        DB.create_table(:tasks) do
            primary_key :id
        String :title
        Boolean :completed
        end
      end

      @tasks_table = DB[:tasks]

    end

    def add_to_list(title)
      task = Task.new(title, @next_id)
      @list.push(task)
      save_to_database(task)
      @next_id += 1
      task
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
      DB[:tasks].where(id: task.id).delete
    end

    def update_in_database(task)
      DB[:tasks].where(id: task.id).update(completed: true)
    end

  end

  class Task
    attr_reader :id, :title, :completed

    def initialize(title, id, completed = false)
      @id = id
      @title = title
      @completed = completed
    end

    def completed?
      @completed ? true : false
    end

    def complete
      @completed = true
    end

    def to_s
      "##{@id} #{@title} (#{@completed ? "+" : "-"})"
    end

  end
end
