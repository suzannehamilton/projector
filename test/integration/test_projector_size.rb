class TestProjectorSize < TestProjector

  def test_can_update_size_of_a_new_task
    capture_io do
      Projector.new.invoke(:add, ["Shear the sheep"], :units => "sheep shorn")
    end

    assert_output("Updated size of task 1, 'Shear the sheep', to 30. 0% complete (0/30 sheep shorn)\n") do
      Projector.new.invoke(:size, ["1", "30"])
    end

    assert_task_list_output([TaskViewModel.new(1, "Shear the sheep", 0, "sheep shorn", 30, 0)]) do
      Projector.new.invoke(:list)
    end
  end

  def test_can_update_size_of_a_task_in_progress
    capture_io do
      Projector.new.invoke(:add, ["Shear the sheep"], :units => "sheep shorn", :size => 4)
      Projector.new.invoke(:update, ["1", "2"])
    end

    assert_output("Updated size of task 1, 'Shear the sheep', to 5. 40% complete (2/5 sheep shorn)\n") do
      Projector.new.invoke(:size, ["1", "5"])
    end

    assert_task_list_output([TaskViewModel.new(1, "Shear the sheep", 2, "sheep shorn", 5, 40)]) do
      Projector.new.invoke(:list)
    end
  end
end