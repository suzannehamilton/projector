class TestProjectorComplete < TestProjector

  def test_cannot_complete_task_from_empty_list
    e = assert_raises Thor::InvocationError do
      Projector.new.invoke(:complete, ["1"])
    end

    assert_equal("No task with number 1", e.message)
  end

  def test_cannot_complete_non_existent_task
    capture_io do
      Projector.new.invoke(:add, ["Shear the sheep"])
    end

    e = assert_raises Thor::InvocationError do
      Projector.new.invoke(:complete, ["5"])
    end

    assert_equal("No task with number 5", e.message)
  end

  def test_can_complete_single_task
    capture_io do
      Projector.new.invoke(:add, ["Shear the sheep"])
    end

    assert_output("Task 1 completed: \"Shear the sheep\"\n") do
      Projector.new.invoke(:complete, ["1"])
    end

    assert_output("Nothing left to do!\n") do
      Projector.new.invoke(:list)
    end
  end

  def test_can_complete_any_task
    capture_io do
      Projector.new.invoke(:add, ["Shear the sheep"])
      Projector.new.invoke(:add, ["Feed the capybara"])
      Projector.new.invoke(:add, ["Shave the yak"])
    end

    assert_output("Task 2 completed: \"Feed the capybara\"\n") do
      Projector.new.invoke(:complete, ["2"])
    end

    assert_task_list_output([TaskViewModel.new(1, "Shear the sheep", 0), TaskViewModel.new(3, "Shave the yak", 0)]) do
      Projector.new.invoke(:list)
    end
  end

  def test_completion_rejects_invalid_task_id
    assert_raises Thor::MalformattedArgumentError do
      Projector.new.invoke(:complete, ["invalid_task_id"])
    end
  end
end