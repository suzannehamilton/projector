class TestProjectorRandom < TestProjector

  def test_random_task_is_nothing_if_there_are_no_tasks
    assert_output("Nothing left to do!\n") do
      Projector.new.invoke(:random)
    end
  end

  # TODO: Test that random returns the only test
  # TODO: Test that random returns one of the tests added
  # TODO: Test (in unit test) that tasks are returned with probability related to percent done
end