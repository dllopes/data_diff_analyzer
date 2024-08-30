# frozen_string_literal: true

class ExtractFileInfo
  MAP_INFO = {
    soccer: {
      id_range: 7..22,
      val1: 43..44,
      val2: 50..51
    },
    w_data: {
      id_range: 2..3,
      val1: 6..7,
      val2: 12..13
    }
  }.freeze

  def initialize(file_name)
    @file_name = file_name.sub('.dat', '')

    key_options = MAP_INFO.keys.map(&:to_s)
    raise "Invalid FileName. Options are: #{key_options}" unless @file_name.in?(key_options)

    @file_info = MAP_INFO[file_name.to_sym]
    @extracted_infos = []
  end

  def process
    file_content.each_line do |line|
      next if invalid_line?(line)

      save_references(line)
    end

    @extracted_infos
  end

  private

  def invalid_line?(line)
    line.strip.blank? || !line.strip.match?(line_content_pattern)
  end

  def line_content_pattern
    /^\d{1,2}(\.|\s)/
  end

  def file_content
    LoadFile.new(@file_name).call
  end

  def extract_values(line)
    values = [@file_info[:val1], @file_info[:val2]].map { |range| line[range] }
    raise 'Invalid value found!' if any_value_invalid?(values)

    values.map(&:to_i)
  end

  def any_value_invalid?(values)
    values.any? do |value|
      !value.match?(/\d{2}/)
    end
  end

  def save_references(line)
    id = line[@file_info[:id_range]].strip
    @extracted_infos << { id:, values: extract_values(line) }
  end
end
