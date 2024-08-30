# frozen_string_literal: true

namespace :data_diff do
  desc 'Analyze the data files and find the smallest differences'
  task analyze: :environment do
    file_name = ENV['FILE_NAME']

    if file_name.nil? || file_name.strip.empty?
      abort <<~ERROR_MSG
        Error: Please provide a FILE_NAME.
        Usage: rake data_diff:analyze FILE_NAME=your_file_name

        Available options:
        - soccer
        - w_data
      ERROR_MSG
    end

    begin
      extractor = ExtractFileInfo.new(file_name)
      extractor.process

      calculator = CalculateDiff.new(file_name)
      smallest_diff_id = calculator.find_smallest

      puts "The ID with the smallest difference is: #{smallest_diff_id}"
    rescue StandardError => e
      puts "An error occurred: #{e.message}"
    end
  end
end
