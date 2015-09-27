require "minitest/autorun"
require "model/custom_progress"

class TestCustomProgress < Minitest::Test

  # TODO: Validate presence of units

  def test_zero_progress_is_valid
    progress = CustomProgress.new("some units", 0)
    assert_equal(0, progress.value)
  end

  def test_default_progress_is_zero
    progress = CustomProgress.new("some units")
    assert_equal(0, progress.value)
  end

  def test_can_get_non_zero_progress
    progress = CustomProgress.new("some units", 65)
    assert_equal(65, progress.value)
  end

  def test_negative_progress_is_invalid
    e = assert_raises Thor::MalformattedArgumentError do
      CustomProgress.new("units", -2)
    end

    assert(e.message.include?("-2"))
  end

  def test_progress_greater_than_100_is_valid_if_task_is_larger_than_100_units
    progress = CustomProgress.new("some units", 120, 130)
    assert_equal(120, progress.value)
  end

  def test_progress_greater_than_size_is_invalid
    e = assert_raises Thor::MalformattedArgumentError do
      CustomProgress.new("some units", 41, 40)
    end

    assert(e.message.include?("41"))
    assert(e.message.include?("40"))
  end

  def test_can_get_units
    progress = CustomProgress.new("some units")
    assert_equal("some units", progress.units)
  end

  def test_can_get_size
    progress = CustomProgress.new("some units", 2, 4)
    assert_equal(4, progress.size)
  end

  def test_default_size_is_100
    progress = CustomProgress.new("some units", 2)
    assert_equal(100, progress.size)
  end

  def test_task_with_zero_progress_is_not_complete
    progress = CustomProgress.new("some units", 0, 20)
    refute progress.complete?
  end

  def test_task_with_less_than_full_progress_is_not_complete
    progress = CustomProgress.new("some units", 19, 20)
    refute progress.complete?
  end

  def test_task_with_full_progress_is_complete
    progress = CustomProgress.new("some units", 67, 67)
    assert progress.complete?
  end

  def test_can_update_progress
    progress = CustomProgress.new("some units", 30, 90)
    updated_progress = progress.update_progress(82)

    assert_equal(CustomProgress.new("some units", 82, 90), updated_progress)
  end

  def test_can_update_progreess_to_zero
    progress = CustomProgress.new("some units", 20)
    updated_progress = progress.update_progress(0)

    assert_equal(CustomProgress.new("some units", 0), updated_progress)
  end

  def test_progress_cannot_be_negative
    progress = CustomProgress.new("units", 0, 20)

    e = assert_raises Thor::MalformattedArgumentError do
      progress.update_progress(-12)
    end

    assert_equal("Cannot update task. Expected progress between 0 and 20, but got '-12'", e.message)
  end

  def test_progress_cannot_be_more_than_task_size
    progress = CustomProgress.new("some units", 0, 50)

    e = assert_raises Thor::MalformattedArgumentError do
      progress.update_progress(51)
    end

    assert_equal("Cannot update task. Expected progress between 0 and 50, but got '51'", e.message)
  end

  def test_updating_progress_to_size_of_task_marks_task_as_complete
    progress = CustomProgress.new("some units", 0, 14)
    updated_progress = progress.update_progress(14)

    assert updated_progress.complete?
  end

  def test_updating_units_preserves_other_fields
    progress = CustomProgress.new("some units", 30, 90)
    updated_progress = progress.update_units("other units")

    assert_equal(CustomProgress.new("other units", 30, 90), updated_progress)
  end

  def test_removing_units_converts_units_to_percent_and_preserves_progress
    progress = CustomProgress.new("original units", 80)
    updated_progress = progress.update_units(nil)

    assert_equal(PercentProgress.new(80), updated_progress)
  end

  def test_removing_units_from_task_with_custom_size_converts_progress_to_percent
    progress = CustomProgress.new("original units", 1, 8)
    updated_progress = progress.update_units(nil)

    assert_equal(PercentProgress.new(12.5), updated_progress)
  end

  # TODO: Test that units must be specified if the task has a size
  # TODO: Test that size cannot be updated when units are percent
end