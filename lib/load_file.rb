# frozen_string_literal: true

class LoadFile
  attr_reader :file_name, :path

  def initialize(file_name)
    @file_name = file_name.to_s
  end

  def call
    file_content
  end

  private

  def file_path
    Rails.root.join('spec', 'fixtures', 'files', "#{file_name}.dat")
  end

  def file_content
    File.read(file_path)
  end
end
