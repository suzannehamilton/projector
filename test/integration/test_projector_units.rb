class TestProjectorUnits < TestProjector

  def test_can_update_units_of_new_task
    capture_io do
      Projector.new.invoke(:add, ["Shear the sheep"])
    end

    assert_output("Updated units of task 1, 'Shear the sheep' to 'sheep shorn'. 0% complete (0/100 sheep shorn)\n") do
      Projector.new.invoke(:units, ["1", "sheep shorn"])
    end

    assert_task_list_output([TaskViewModel.new(1, "Shear the sheep", 0, "sheep shorn")]) do
      Projector.new.invoke(:list)
    end
  end

  def test_can_update_units_to_percent
    capture_io do
      Projector.new.invoke(:add, ["Shear the sheep"], :units => "sheep shorn")
    end

    assert_output("Updated units of task 1, 'Shear the sheep' to 'percent'. 0% complete\n") do
      Projector.new.invoke(:units, ["1"])
    end

    assert_task_list_output([TaskViewModel.new(1, "Shear the sheep", 0)]) do
      Projector.new.invoke(:list)
    end
  end
end