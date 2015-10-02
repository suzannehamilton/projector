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

    assert e.message.include? "-12"
  end

  def test_progress_cannot_be_more_than_task_size
    progress = CustomProgress.new("some units", 0, 50)

    e = assert_raises Thor::MalformattedArgumentError do
      progress.update_progress(51)
    end

    assert e.message.include? "progress"
    assert e.message.include? "size"
    assert e.message.include? "50"
    assert e.message.include? "51"
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

  def test_can_update_size
    progress = CustomProgress.new("some units", 4, 10)
    updated_progress = progress.update_size(8)

    assert_equal(8, updated_progress.size)
  end

  def test_can_update_size_to_equal_progress
    progress = CustomProgress.new("some units", 4, 10)
    updated_progress = progress.update_size(4)

    assert_equal(4, updated_progress.size)
    assert updated_progress.complete?
  end

  def test_updating_size_preserves_other_fields
    progress = CustomProgress.new("some units", 4, 10)
    updated_progress = progress.update_size(8)

    assert_equal("some units", updated_progress.units)
    assert_equal(4, updated_progress.value)
  end

  def test_size_cannot_be_less_than_progress
    progress = CustomProgress.new("some units", 40, 50)

    e = assert_raises Thor::MalformattedArgumentError do
      progress.update_size(39)
    end

    assert e.message.include? "progress"
    assert e.message.include? "size"
    assert e.message.include? "39"
    assert e.message.include? "40"
  end

  progress_combinations = [
    [0, 100, 0],
    [1, 100, 1],
    [13, 100, 13],
    [100, 100, 100],
    [0, 12, 0],
    [3, 12, 25],
    [12, 12, 100],
    [58.346, 100, 58],
    [58.5, 100, 59],
    [3, 9, 33],
    [6, 9, 67],
    [13.578, 16.467, 82]
  ]

  progress_combinations.each do |p|
    define_method("test_task_with_size_#{p[1]}_and_progress_#{p[0]}_is_#{p[2]}_percent_complete") do
      assert_equal(p[2], CustomProgress.new("some units", p[0], p[1]).percent_done)
    end
  end
end