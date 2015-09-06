class TestProjectorUpdate < TestProjector

  def test_can_update_units_of_new_task
    capture_io do
      Projector.new.invoke(:add, ["Shear the sheep"])
    end

    assert_output("Updated units of task 1, 'Shear the sheep' to 'pages'. 0% complete (0/100 pages)\n") do
      Projector.new.invoke(:units, ["1", "pages"])
    end

    assert_task_list_output([TaskViewModel.new(1, "Shear the sheep", 0, "pages")]) do
      Projector.new.invoke(:list)
    end
  end

  # TODO: Test updating of task in progress
  # TODO: Test switching back to percent
  # TODO: Test switching back to percent when max in new units is not 100
end