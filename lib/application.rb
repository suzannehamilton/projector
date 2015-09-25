require_relative "model/task_factory"
require_relative "view/task_view_model"
require_relative "view/views"
require_relative "view/model_and_view"

class Application

  def initialize(database, task_factory, view_model_factory)
    @database = database
    @task_factory = task_factory
    @view_model_factory = view_model_factory
  end

  def list
    tasks = @database.list

    view_models = tasks.map { |t| @view_model_factory.create_view_model(t) }

    ModelAndView.new(view_models, Views::LIST)
  end

  def add(task_name, units = nil, size = nil)
    validate_task_size(size)

    task = @database.add(@task_factory.task(nil, task_name, 0, units, size))

    view_model = @view_model_factory.create_view_model(task)

    ModelAndView.new(view_model, Views::ADD)
  end

  def complete(task_id)
    task = get_task(task_id)

    @database.delete(task.id)

    view_model = @view_model_factory.create_view_model(task)

    ModelAndView.new(view_model, Views::COMPLETE)
  end

  def update(task_id, progress)
    task = get_task(task_id)

    updated_task = task.update_progress(progress)

    if updated_task.complete?
      @database.delete(task_id)
      view = Views::COMPLETE
    else
      @database.save(updated_task)
      view = Views::UPDATE
    end

    view_model = @view_model_factory.create_view_model(updated_task)
    ModelAndView.new(view_model, view)
  end

  def units(task_id, new_units)
    task = get_task(task_id)

    updated_task = task.update_units(new_units)
    @database.save(updated_task)

    view_model = @view_model_factory.create_view_model(updated_task)

    ModelAndView.new(view_model, Views::UNITS)
  end

  private

  def get_task(task_id)
    task = @database.get(task_id)

    if task.nil?
      raise Thor::InvocationError.new("No task with number #{task_id}")
    else
      task
    end
  end

  def validate_task_size(task_size)
    if !task_size.nil? && task_size <= 0
      raise Thor::MalformattedArgumentError.new(
        "Cannot create task. Task size must be a postive value, but got '#{task_size}'")
    end
  end
end