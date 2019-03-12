require 'cli/ui'
require_relative 'todo_console_app'

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
