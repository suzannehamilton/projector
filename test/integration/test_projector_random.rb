class TestProjectorRandom < TestProjector

  def test_random_task_is_nothing_if_there_are_no_tasks
    assert_output("Nothing left to do!\n") do
      Projector.new.invoke(:random)
    end
  end

  def test_random_task_is_only_task
    capture_io do
      Projector.new.invoke(:add, ["Shear the sheep"])
    end

    assert_output("1, Shear the sheep, 0% complete\n") do
      Projector.new.invoke(:random, ["Shear the sheep"])
    end
  end

  def test_random_task_returns_one_of_the_added_tasks
    capture_io do
      Projector.new.invoke(:add, ["Shear the sheep"])
      Projector.new.invoke(:add, ["Walk the capybaras"])
      Projector.new.invoke(:add, ["Pet the rabbits"])
    end

    cli_output = capture_io do
      Projector.new.invoke(:random)
    end
    random_task = cli_output[0].strip

    # TODO: Run multiple time and check that each task is returned at least once? 50 times is more than enough for statistical validity
    assert(
      (random_task == "1, Shear the sheep, 0% complete" ||
        random_task == "2, Walk the capybaras, 0% complete" ||
        random_task == "3, Pet the rabbits, 0% complete"),
      "Expected random task to be one of the added tasks, but got #{random_task}")
  end

  # TODO: Test (in unit test) that tasks are returned with probability related to percent done
end