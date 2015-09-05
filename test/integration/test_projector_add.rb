class TestProjectorAdd < TestProjector

  def test_adding_a_task_to_list_returns_task_name
    assert_output("Added 'Shear the sheep'\n") do
      Projector.new.invoke(:add, ["Shear the sheep"])
    end
  end

  def test_adding_a_task_adds_it_to_list_of_tasks
    capture_io do
      Projector.new.invoke(:add, ["Shear the sheep"])
    end

    assert_task_list_output([Task.new(1, "Shear the sheep", 0)]) do
      Projector.new.invoke(:list)
    end
  end
end