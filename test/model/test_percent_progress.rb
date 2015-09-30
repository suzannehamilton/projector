require "minitest/autorun"
require "model/percent_progress"

class TestPercentProgress < Minitest::Test

  def test_zero_progress_is_valid
    progress = PercentProgress.new(0)
    assert_equal(0, progress.value)
  end

  def test_default_progress_is_zero
    progress = PercentProgress.new
    assert_equal(0, progress.value)
  end

  def test_negative_progress_is_invalid
    e = assert_raises Thor::MalformattedArgumentError do
      PercentProgress.new(-2)
    end

    assert(e.message.include?("-2"))
  end

  def test_progress_greater_than_100_percent_is_invalid
    e = assert_raises Thor::MalformattedArgumentError do
      PercentProgress.new(101)
    end

    assert(e.message.include?("101"))
  end

  def test_size_is_not_defined
    assert_nil(PercentProgress.new.size)
  end

  def test_units_are_not_defined
    assert_nil(PercentProgress.new.units)
  end

  def test_task_with_zero_percent_progress_is_not_complete
    progress = PercentProgress.new(0)
    refute progress.complete?
  end

  def test_task_with_less_than_100_percent_progress_is_not_complete
    progress = PercentProgress.new(99)
    refute progress.complete?
  end

  def test_task_with_100_percent_progress_is_complete
    progress = PercentProgress.new(100)
    assert progress.complete?
  end

  def test_can_update_progress
    progress = PercentProgress.new(54)
    updated_progress = progress.update_progress(80)

    assert_equal(PercentProgress.new(80), updated_progress)
  end

  def test_can_update_percentage_to_zero
    progress = PercentProgress.new(20)
    updated_progress = progress.update_progress(0)

    assert_equal(PercentProgress.new(0), updated_progress)
  end

  def test_progress_cannot_be_negative
    progress = PercentProgress.new(0)

    e = assert_raises Thor::MalformattedArgumentError do
      progress.update_progress(-12)
    end

    assert_equal("Cannot update task. Expected progress between 0 and 100, but got '-12'", e.message)
  end

  def test_percent_done_cannot_be_more_than_100_percent
    progress = PercentProgress.new(0)

    e = assert_raises Thor::MalformattedArgumentError do
      progress.update_progress(101)
    end

    assert_equal("Cannot update task. Expected progress between 0 and 100, but got '101'", e.message)
  end

  def test_updating_progress_to_100_percent_marks_task_as_complete
    progress = PercentProgress.new(20)
    updated_progress = progress.update_progress(100)

    assert updated_progress.complete?
  end

  def test_can_add_units_to_a_task_with_no_progress
    progress = PercentProgress.new(0)
    updated_progress = progress.update_units("some units")

    assert_equal(CustomProgress.new("some units", 0), updated_progress)
  end

  def test_can_add_units_to_a_task_with_progress
    progress = PercentProgress.new(80)
    updated_progress = progress.update_units("some units")

    assert_equal(CustomProgress.new("some units", 80), updated_progress)
  end

  def test_can_adding_units_sets_size_to_100
    progress = PercentProgress.new(80)
    updated_progress = progress.update_units("some units")

    assert_equal(CustomProgress.new("some units", 80, 100), updated_progress)
  end

  def test_removing_units_does_not_change_progress
    original_progress = PercentProgress.new(80)
    updated_progress = original_progress.update_units(nil)

    assert_equal(original_progress, updated_progress)
  end

  percent_combinations = [
    [0, 0],
    [42, 42],
    [100, 100],
    [23.467, 23],
    [23.5, 24],
    [23.84457, 24]
  ]

  percent_combinations.each do |p|
    define_method("test_task_in_percent_and_progress_#{p[0]}_is_#{p[1]}_percent_complete") do
      assert_equal(p[1], PercentProgress.new(p[0]).percent_done)
    end
  end
end