class RandomTaskService

  def get_random_task(tasks)
    tasks.empty? ? nil : tasks.sample
  end
end