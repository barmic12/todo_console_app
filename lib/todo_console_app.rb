require 'sequel'
require 'fileutils'
require 'cli/ui'
ENV['RUBY_ENV'] ||= 'development'

module TodoConsoleApp


  DATABASE_DIRNAME = 'database'
  FileUtils.mkdir_p(DATABASE_DIRNAME)

  DATABASE_NAME = 'todos'
  DATABASE_PATH = "#{DATABASE_DIRNAME}/#{DATABASE_NAME}_#{ENV['RUBY_ENV']}.db"

  puts DATABASE_PATH

  class TodoList
    attr_reader :list, :tasks_table

    DB = Sequel.sqlite(DATABASE_PATH)

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
      if task.nil?
        puts "You provided wrong ID"
      else
        @list.delete(task)
        remove_from_database(task)
      end
    end

    def complete(task)
      if task.nil?
        puts "You provided wrong ID"
      else
        task.complete
        update_in_database(task)
      end
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

  class App
    def self.run
      @running = true
      @todolist = TodoConsoleApp::TodoList.new
      while (@running) do
        CLI::UI::Prompt.ask('What want you do?') do |handler|
          handler.option('Add task')  {
             print "Provide the title: "
             title = gets.chomp
             @todolist.add_to_list(title)
          }
          handler.option('Remove task') {
            print "Provide id of task: "
            id = gets.to_i
            @task = @todolist.list.select { |task| task.id == id }
            @todolist.remove_from_list(@task.first)
          }

          handler.option('Complete task') {
            print "Provide id of task: "
            id = gets.to_i
            @task = @todolist.list.select { |task| task.id == id }
            @todolist.complete(@task.first)
          }

          handler.option('Display all tasks') {
            puts "All tasks:"
            @todolist.filtered_list.each do |task|
              puts task.to_s
            end
          }

          handler.option('Display completed tasks') {
            puts "Completed tasks:"
            @todolist.filtered_list(:completed).each do |task|
              puts task.to_s
            end
          }

          handler.option('Display uncompleted tasks') {
            puts "Uncompleted tasks:"
            @todolist.filtered_list(:incompleted).each do |task|
              puts task.to_s
            end
          }

          handler.option('Exit') {
            @running = false
           }

        end
      end

    end
  end
end
