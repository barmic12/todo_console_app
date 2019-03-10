#require "todo_console_app/version"

module TodoConsoleApp
  class Error < StandardError; end

  class TodoList
    attr_reader :list

    def initialize
      @list = Array.new
    end

    def add_to_list(task)
      @list.push(task)
    end
  end

  class Task
    attr_reader :title, :completed

    def initialize(title)
      @title = title
      @completed = false
    end
  end
end
