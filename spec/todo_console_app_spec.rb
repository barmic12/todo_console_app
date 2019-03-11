RSpec.describe TodoConsoleApp do
  it "has a version number" do
    expect(TodoConsoleApp::VERSION).not_to be nil
  end

  describe TodoConsoleApp::TodoList do
    let(:todolist) { TodoConsoleApp::TodoList.new }
    let(:task) { TodoConsoleApp::Task.new('Example task') }

    it { expect(todolist).to respond_to :list }

    describe '#initialize' do
      it 'should return empty list' do
        expect(todolist.list).to be_empty
      end


      it 'should create database' do
        expect(File).to exist('database/todos.db')
      end

      it 'should create table in database' do
        expect(todolist.tasks_table).to_not be_nil
      end

    end

    describe '#add_to_list' do
      before do
        task = TodoConsoleApp::Task.new('Example task')
        todolist.add_to_list(task)
      end

      it 'should return not empty list' do
        expect(todolist.list).to_not be_nil
      end

      it 'should return array with 1 element' do
        expect(todolist.list.count).to eq(1)
      end

      it 'should create record in database' do
        expect(todolist.tasks_table.count).to eq(1)
      end

    end

    describe '#remove_from_list' do
      before do
        task_title = 'Example task'
        @task = TodoConsoleApp::Task.new(task_title)
        todolist.add_to_list(@task)
      end

      it 'should remove task from array' do
        expect(todolist.list.count).to eq(1)
        todolist.remove_from_list(@task)
        expect(todolist.list.count).to eq(0)
      end

      it 'should remove record from database' do
        expect(todolist.tasks_table.count).to eq(1)
        todolist.remove_from_list(@task)
        expect(todolist.tasks_table.count).to eq(0)
      end

    end

    describe "#complete" do
      before do
        todolist.add_to_list(task)
      end

      it 'should can complete task' do
        expect(task.completed?).to eq(false)
        todolist.complete(task)
        expect(task.completed?).to eq(true)
      end

    end

    describe "#filtered_list" do

      before do
        2.times do
          task = TodoConsoleApp::Task.new('Example task')
          todolist.add_to_list(task)
        end
        todolist.list[0].complete
      end

      context 'all filter' do

        it 'should returns all tasks' do
          expect(todolist.filtered_list.count).to eq(2)
        end

      end

      context 'uncompleted filter' do

        it 'should returns only uncompleted tasks' do
          expect(todolist.filtered_list(:incompleted).count).to eq(1)
          expect(todolist.filtered_list(:incompleted).first.completed?).to eq(false)
        end

      end

      context 'completed filter' do

        it 'should returns only completed tasks' do
          expect(todolist.filtered_list(:completed).count).to eq(1)
          expect(todolist.filtered_list(:completed).first.completed?).to eq(true)
        end

      end

      context 'undefined filter' do

        it 'should returns exception' do
          expect{ todolist.filtered_list(:undefined) }.to raise_error(ArgumentError)
        end

      end

    end

    describe "#save_to_database" do

      @task_title = 'Example task'

      it 'should create valid record in database' do
        task = TodoConsoleApp::Task.new(@task_title)
        todolist.instance_eval{ save_to_database(task) }
        expect(todolist.tasks_table.first[:title]).to eq(task.title)
        expect(todolist.tasks_table.first[:completed]).to eq(task.completed)
      end
    end

    describe "#remove_from_database" do
      it 'should remove record from databse' do
        task = TodoConsoleApp::Task.new('Example title')
        todolist.instance_eval{ save_to_database(task) }
        expect(todolist.tasks_table.count).to eq(1)
        todolist.instance_eval{ remove_from_database(task) }
        expect(todolist.tasks_table.count).to eq(0)
      end
    end

    describe "#update_in_database" do
      it 'should update record in database' do
        task = TodoConsoleApp::Task.new('Example title')
        todolist.instance_eval{ save_to_database(task) }
        status = task.completed
        todolist.instance_eval{ update_in_database(task) }
        expect(todolist.tasks_table.first[:completed]).to eq(!status)
      end
    end

  end

  describe "Task class" do
    let(:task) {TodoConsoleApp::Task.new('Test')}

    it { expect(task).to respond_to :title }
    it { expect(task).to respond_to :completed }

    describe "#initialize" do
      before do
        @title = "Init title"
        @task = TodoConsoleApp::Task.new(@title)
      end

      it 'should has the title' do
        expect(@task.title).to eq(@title)
      end

      it 'should be uncompleted' do
        expect(task.completed).to be false
      end
    end

    describe "#complete" do
      before { task.complete }

      it { expect(task.completed).to eq(true) }

    end

    describe "#completed?" do
      context "Completed task" do

        before { task.complete }

        it 'should return true' do
          expect(task.completed?).to eq(true)
        end
      end

      context "Uncompleted task" do

        it 'should return true' do
          expect(task.completed?).to eq(false)
        end
      end
    end

  end
end
