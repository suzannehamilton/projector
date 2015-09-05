class TestProjectorUpdate < TestProjector

  def test_can_update_done_percentage
    capture_io do
      Projector.new.invoke(:add, ["Comb the rabbit"])
    end

    assert_output("Updated task 1, 'Comb the rabbit' to 60%\n") do
      Projector.new.invoke(:update, ["1", "60"])
    end

    assert_task_list_output([Task.new(1, "Comb the rabbit", 60)]) do
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
end