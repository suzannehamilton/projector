class TestProjectorList < TestProjector

  def test_listing_empty_task_list_identifies_that_no_tasks_are_available
    assert_output("Nothing left to do!\n") do
      Projector.new.invoke(:list)
    end
  end

  def test_list_lists_multiple_added_tasks
    capture_io do
      Projector.new.invoke(:add, ["Shear the sheep"])
      Projector.new.invoke(:add, ["Feed the capybaras"], :units => "capybaras fed")
    end

    assert_task_list_output([TaskViewModel.new(1, "Shear the sheep", 0), TaskViewModel.new(2, "Feed the capybaras", 0, "capybaras fed")]) do
      Projector.new.invoke(:list)
    end
  end

  def test_lists_task_with_progress
    capture_io do
      Projector.new.invoke(:add, ["Walk the guinea pigs"], :units => "guinea pigs", :size => 10)
      Projector.new.invoke(:update, ["1", "4"])
    end

    assert_task_list_output([TaskViewModel.new(1, "Walk the guinea pigs", 4, "guinea pigs", 10, 40)]) do
      Projector.new.invoke(:list)
    end
  end
end