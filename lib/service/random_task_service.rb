class RandomTaskService

  def get_random_task(tasks)
    !tasks.empty? or return nil

    weighted_tasks = []

    tasks.each do |task|

      # Weight the task by it's percent complete, with a minimum weighting of 1% so that there's still a small
      # chance that new tasks (with zero progress) are selected
      ceiling_percent_done = task.progress.percent_done > 1 ? task.progress.percent_done : 1

      ceiling_percent_done.times do
        weighted_tasks << task
      end
    end

    weighted_tasks.sample
  end
end