require "minitest/autorun"
require "model/progress"

class TestProgress < Minitest::Test

  def test_zero_progress_is_valid
    progress = Progress.new(0)
    assert_equal(0, progress.value)
  end

  def test_default_progress_is_zero
    progress = Progress.new
    assert_equal(0, progress.value)
  end

  def test_negative_progress_is_invalid
    e = assert_raises Thor::MalformattedArgumentError do
      Progress.new(-2)
    end

    assert(e.message.include?("-2"))
  end

  def test_negative_progress_of_task_with_custom_size_is_invalid
    e = assert_raises Thor::MalformattedArgumentError do
      Progress.new(-2, "some units", 10)
    end

    assert(e.message.include?("-2"))
  end

  def test_progress_greater_than_100_percent_is_invalid
    e = assert_raises Thor::MalformattedArgumentError do
      Progress.new(101)
    end

    assert(e.message.include?("101"))
  end

  def test_progress_greater_than_100_is_valid_if_task_is_larger_than_100_units
    progress = Progress.new(120, "some units", 130)
    assert_equal(120, progress.value)
  end

  def test_progress_greater_than_custom_task_size_is_invalid
    e = assert_raises Thor::MalformattedArgumentError do
      Progress.new(41, "some units", 40)
    end

    assert(e.message.include?("41"))
    assert(e.message.include?("40"))
  end

  def test_can_get_units
    progress = Progress.new(33, "some units")
    assert_equal("some units", progress.units)
  end

  def test_can_get_size
    progress = Progress.new(2, "some units", 4)
    assert_equal(4, progress.size)
  end

  # TODO: Work out default size. Currently nil, but should be 100 for a task with units.

  def test_task_with_zero_percent_progress_is_not_complete
    progress = Progress.new(0)
    refute progress.complete?
  end

  def test_task_with_zero_progress_is_not_complete
    progress = Progress.new(0, "some units", 20)
    refute progress.complete?
  end

  def test_task_with_less_than_100_percent_progress_is_not_complete
    progress = Progress.new(99)
    refute progress.complete?
  end

  def test_task_with_less_than_full_progress_is_not_complete
    progress = Progress.new(19, "some units", 20)
    refute progress.complete?
  end

  def test_task_with_100_percent_progress_is_complete
    progress = Progress.new(100)
    assert progress.complete?
  end

  def test_task_with_full_progress_is_complete
    progress = Progress.new(67, "some units", 67)
    assert progress.complete?
  end

  def test_updating_progress_preserves_other_fields
    progress = Progress.new(30, "some units", 90)
    updated_progress = progress.update_progress(82)

    assert_equal("some units", updated_progress.units)
    assert_equal(90, updated_progress.size)
  end

  def test_can_update_progress_of_task_with_default_units
    progress = Progress.new(54)
    updated_progress = progress.update_progress(80)

    assert_equal(80, updated_progress.value)
  end

  def test_can_update_percentage_to_zero
    progress = Progress.new(20)
    updated_progress = progress.update_progress(0)

    assert_equal(0, updated_progress.value)
  end

  def test_progress_cannot_be_negative
    progress = Progress.new(0)

    e = assert_raises Thor::MalformattedArgumentError do
      progress.update_progress(-12)
    end

    assert_equal("Cannot update task. Expected progress between 0 and 100, but got '-12'", e.message)
  end

  def test_percent_done_cannot_be_more_than_100_percent
    progress = Progress.new(0)

    e = assert_raises Thor::MalformattedArgumentError do
      progress.update_progress(101)
    end

    assert_equal("Cannot update task. Expected progress between 0 and 100, but got '101'", e.message)
  end

  def test_progress_of_custom_size_task_cannot_be_negative
    progress = Progress.new(0, "some units", 50)

    e = assert_raises Thor::MalformattedArgumentError do
      progress.update_progress(-1)
    end

    assert_equal("Cannot update task. Expected progress between 0 and 50, but got '-1'", e.message)
  end

  def test_progress_of_custom_size_task_cannot_be_more_than_task_size
    progress = Progress.new(0, "some units", 50)

    e = assert_raises Thor::MalformattedArgumentError do
      progress.update_progress(51)
    end

    assert_equal("Cannot update task. Expected progress between 0 and 50, but got '51'", e.message)
  end

  def test_updating_progress_to_100_percent_marks_task_as_complete
    progress = Progress.new(20)
    updated_progress = progress.update_progress(100)

    assert updated_progress.complete?
  end

  def test_updating_progress_to_size_of_task_marks_task_as_complete
    progress = Progress.new(0, "some units", 14)
    updated_progress = progress.update_progress(14)

    assert updated_progress.complete?
  end

  def test_updating_custom_units_preserves_other_fields
    progress = Progress.new(30, "some units", 90)
    updated_progress = progress.update_units("other units")

    assert_equal(30, updated_progress.value)
    assert_equal(90, updated_progress.size)
  end

  def test_can_add_units_to_a_task_with_no_progress
    progress = Progress.new(0)
    updated_progress = progress.update_units("some units")

    assert_equal("some units", updated_progress.units)
  end

  def test_can_update_units_of_task_in_progress
    progress = Progress.new(80)
    updated_progress = progress.update_units("some units")

    assert_equal("some units", updated_progress.units)
  end

  def test_adding_units_preserves_progress
    progress = Progress.new(80)
    updated_progress = progress.update_units("some units")

    assert_equal(80, updated_progress.value)
  end

  def test_adding_units_sets_size
    progress = Progress.new(80)
    updated_progress = progress.update_units("some units")

    assert_equal(100, updated_progress.size)
  end

  def test_can_update_units_of_task_with_custom_size
    progress = Progress.new(80, "original units", 152)
    updated_progress = progress.update_units("some units")

    assert_equal("some units", updated_progress.units)
  end

  def test_can_updating_units_of_task_with_custom_size_preserves_size_and_progress
    progress = Progress.new(80, "original units", 152)
    updated_progress = progress.update_units("some units")

    assert_equal(152, updated_progress.size)
    assert_equal(80, updated_progress.value)
  end

  def test_removing_units_converts_units_to_percent
    progress = Progress.new(80, "original units")
    updated_progress = progress.update_units(nil)

    assert_nil(updated_progress.units)
    assert_nil(updated_progress.size)
  end

  def test_removing_units_from_task_with_custom_unit_preserves_progress
    progress = Progress.new(80, "original units")
    updated_progress = progress.update_units(nil)

    assert_equal(80, updated_progress.value)
  end

  def test_removing_units_from_task_with_custom_size_converts_units_to_default
    progress = Progress.new(20, "original units", 30)
    updated_progress = progress.update_units(nil)

    assert_nil(updated_progress.units)
    assert_nil(updated_progress.size)
  end

  def test_removing_units_from_task_with_custom_size_converts_progress_to_percent
    progress = Progress.new(1, "original units", 8)
    updated_progress = progress.update_units(nil)

    assert_equal(12.5, updated_progress.value)
  end

  # TODO: Test that units must be specified if the task has a size
  # TODO: Test that size cannot be updated when units are percent
end