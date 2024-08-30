# frozen_string_literal: true

class CalculateDiff
  def initialize(file_name)
    @file_name = file_name
    @id = nil
    @lowest_result = nil
  end

  def find_smallest
    ExtractFileInfo.new(@file_name).process.each do |info|
      process(info)
    end

    @id
  end

  private

  def process(info)
    diff = calculate_difference(info)
    save_smallest_references(info, diff) if @lowest_result.nil? || diff < @lowest_result
  end

  def save_smallest_references(info, diff)
    @lowest_result = diff
    @id = info[:id]
  end

  def calculate_difference(info)
    return Float::INFINITY if info[:values].size < 2

    (info[:values].first - info[:values].last).abs
  end
end
