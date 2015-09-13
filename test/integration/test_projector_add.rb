class TestProjectorAdd < TestProjector

  def test_adding_a_task_to_list_returns_task_id_and_name
    assert_output("Added task 1: 'Shear the sheep', 0% complete\n") do
      Projector.new.invoke(:add, ["Shear the sheep"])
    end
  end

  def test_adding_a_task_adds_it_to_list_of_tasks
    capture_io do
      Projector.new.invoke(:add, ["Shear the sheep"])
    end

    assert_task_list_output([TaskViewModel.new(1, "Shear the sheep", 0)]) do
      Projector.new.invoke(:list)
    end
  end

  def test_can_specify_progress_units
    assert_output("Added task 1: 'Shear the sheep', 0% complete (0/100 sheep shorn)\n") do
      Projector.new.invoke(:add, ["Shear the sheep"], :units => "sheep shorn")
    end

    assert_task_list_output([TaskViewModel.new(1, "Shear the sheep", 0, "sheep shorn")]) do
      Projector.new.invoke(:list)
    end
  end

  def test_can_specify_task_size
    assert_output("Added task 1: 'Pet the capybaras', 0% complete (0/5 capybaras petted)\n") do
      Projector.new.invoke(:add, ["Pet the capybaras"], :units => "capybaras petted", :size => 5)
    end

    assert_task_list_output([TaskViewModel.new(1, "Pet the capybaras", 0, "capybaras petted", 5)]) do
      Projector.new.invoke(:list)
    end
  end

  # TODO: Allow task size to be updated later
end