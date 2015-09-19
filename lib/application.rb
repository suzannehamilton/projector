require_relative "view/task_view_model"
require_relative "view/views"
require_relative "view/model_and_view"

class Application

  def initialize(database, view_model_factory)
    @database = database
    @view_model_factory = view_model_factory
  end

  def list
    tasks = @database.list

    view_models = tasks.map { |t| @view_model_factory.create_view_model(t) }

    ModelAndView.new(view_models, Views::LIST)
  end

  def add(task_name, units = nil, size = nil)
    # TODO: Validate size cannot be zero or negative
    task = @database.add(task_name, units, size)

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

    validate_progress(progress, task.size)

    updated_task = Task.new(task.id, task.name, progress, task.units, task.size)

    if updated_task.complete?
      @database.delete(task.id)

      # TODO: Use updated_task rather than task for consistency
      view_model = @view_model_factory.create_view_model(task)
      view = Views::COMPLETE
    else
      @database.save(updated_task)

      view_model = @view_model_factory.create_view_model(updated_task)
      view = Views::UPDATE
    end

    ModelAndView.new(view_model, view)
  end

  def units(task_id, new_units)
    task = get_task(task_id)

    updated_task_size = new_units.nil? ? nil : task.size

    updated_task = Task.new(task.id, task.name, task.progress, new_units, updated_task_size)
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

  # TODO: Move lots of validation to Task.new and just convert exceptions to Thor exceptions?
  def validate_progress(progress, task_size)
    task_max_progress = task_size.nil? ? 100 : task_size

    if progress < 0 || progress > task_max_progress
      raise Thor::MalformattedArgumentError.new(
        "Cannot update task. Expected progress between 0 and #{task_max_progress}, but got '#{progress}'")
    end
  end
end