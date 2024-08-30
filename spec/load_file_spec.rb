# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoadFile, type: :class do
  let(:file_name) { 'test_file' }
  let(:file_path) { Rails.root.join('spec', 'fixtures', 'files', "#{file_name}.dat") }
  let(:file_content) { "Sample content in the file\nAnother line of content" }

  before do
    FileUtils.mkdir_p(File.dirname(file_path))
    File.write(file_path, file_content)
  end

  after do
    File.delete(file_path) if File.exist?(file_path)
  end

  subject { described_class.new(file_name) }

  describe '#call' do
    it 'returns the content of the file' do
      expect(subject.call).to eq(file_content)
    end

    it 'raises an error if the file does not exist' do
      non_existent_file = described_class.new('non_existent_file')
      expect { non_existent_file.call }.to raise_error(Errno::ENOENT)
    end
  end

  describe '#file_name' do
    it 'returns the correct file name as a string' do
      expect(subject.file_name).to eq(file_name)
    end
  end

  describe '#file_path' do
    it 'returns the correct file path' do
      expect(subject.send(:file_path)).to eq(file_path)
    end
  end
end
