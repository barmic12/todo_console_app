RSpec.describe TodoConsoleApp do
  it "has a version number" do
    expect(TodoConsoleApp::VERSION).not_to be nil
  end

  describe TodoConsoleApp::TodoList do
    let(:todolist) { TodoConsoleApp::TodoList.new }

    it { expect(todolist).to respond_to :list }

    describe '#initialize' do
      it 'should return empty list' do
        expect(todolist.list).to be_empty
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

    end

    describe "#save_to_database" do

    end

    describe "#load_from_database" do

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

    describe "#change_status" do

      context 'from uncompleted to completed' do

      end

      context 'from completed to uncompleted' do

      end

    end
    
    describe "#completed?" do
      context "Completed task" do

        it 'should return true' do

        end
      end

      context "Uncompleted task" do

        it 'should return true' do

        end
      end
    end

  end
end
