class TestProjectorUpdate < TestProjector

  def test_can_update_progress
    capture_io do
      Projector.new.invoke(:add, ["Comb the rabbit"])
    end

    assert_output("Updated task 1, 'Comb the rabbit' to 60% complete\n") do
      Projector.new.invoke(:update, ["1", "60"])
    end

    assert_task_list_output([TaskViewModel.new(1, "Comb the rabbit", 60)]) do
      Projector.new.invoke(:list)
    end
  end

  def test_updating_rejects_invalid_task_id
    capture_io do
      Projector.new.invoke(:add, ["Comb the rabbit"])
    end

    assert_raises Thor::MalformattedArgumentError do
      Projector.new.invoke(:update, ["invalid_id", "60"])
    end
  end

  def test_updating_rejects_invalid_percent_done
    capture_io do
      Projector.new.invoke(:add, ["Comb the rabbit"])
    end

    assert_raises Thor::MalformattedArgumentError do
      Projector.new.invoke(:update, ["1", "not a percentage"])
    end
  end

  def test_updating_progress_to_100_percent_marks_task_as_complete
    capture_io do
      Projector.new.invoke(:add, ["Shear the sheep"])
    end

    assert_output("Task 1 completed: \"Shear the sheep\"\n") do
      Projector.new.invoke(:update, ["1", "100"])
    end

    assert_output("Nothing left to do!\n") do
      Projector.new.invoke(:list)
    end
  end
end