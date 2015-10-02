class TestProjectorSize < TestProjector

  def test_can_update_size_of_a_new_task
    capture_io do
      Projector.new.invoke(:add, ["Shear the sheep"], :units => "sheep shorn")
    end

    assert_output("Updated size of task 1, 'Shear the sheep', to 30. 0% complete (0/30 sheep shorn)\n") do
      Projector.new.invoke(:size, ["1", "30"])
    end

    # TODO: Test list
  end

  # TODO: Test cannot update size of task with no units
  # TODO: Test updating size when of task in progress
end