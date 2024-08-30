# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExtractFileInfo, type: :model do
  let(:file_name) { 'soccer' }
  let(:file_content) do
    <<~FILE
      \t\t\t\t1. Arsenal         38    26   9   3    79  -  36    87\n
      \t\t\t\t2. Liverpool       38    24   8   6    67  -  30    80\n
      \t\t\t\t3. Manchester_U    38    24   5   9    87  -  45    77\n
    FILE
  end
  let(:load_file) { instance_double('LoadFile', call: file_content) }

  before do
    allow(LoadFile).to receive(:new).with(file_name).and_return(load_file)
  end

  describe '#process' do
    subject(:process_result) { described_class.new(file_name).process }

    it 'extracts the correct information from each line' do
      expected_result = [
        { id: 'Arsenal', values: [79, 36] },
        { id: 'Liverpool', values: [67, 30] },
        { id: 'Manchester_U', values: [87, 45] }
      ]

      expect(process_result).to eq(expected_result)
    end

    context 'when the line is invalid' do
      let(:file_content) do
        <<~FILE
            Invalid line\n
          \t\t\t\t1. Arsenal         38    26   9   3    79  -  36    87\n
        FILE
      end

      it 'ignores the invalid lines' do
        expect(process_result).to eq([{ id: 'Arsenal', values: [79, 36] }])
      end
    end

    context 'when the line contains invalid values' do
      let(:file_content) do
        <<~FILE
          \t\t\t\t1. Arsenal         38    26   9   3    7   -  36    87\n
          \t\t\t\t2. Liverpool       38    24   8   6    67  -  3     80\n
        FILE
      end

      it 'raises an exception indicating the invalid value' do
        extractor = described_class.new(file_name)

        expect { extractor.process }.to raise_error(RuntimeError, 'Invalid value found!')
      end
    end

    context 'when there are blank values in extracted info' do
      let(:file_content) do
        <<~FILE
          \t\t\t\t1. Arsenal         38    26   9   3        -  36    87\n
          \t\t\t\t2. Liverpool       38    24   8   6    67  -       80\n
        FILE
      end

      it 'raises an exception indicating the invalid value' do
        extractor = described_class.new(file_name)

        expect { extractor.process }.to raise_error(RuntimeError, 'Invalid value found!')
      end
    end
  end

  describe '#invalid_line?' do
    subject(:extract_file_info) { described_class.new(file_name) }

    it 'returns true for lines that are blank' do
      expect(extract_file_info.send(:invalid_line?, " \n")).to be true
    end

    it 'returns true for lines that do not match the pattern' do
      expect(extract_file_info.send(:invalid_line?, 'Invalid line')).to be true
    end

    it 'returns false for valid lines' do
      expect(extract_file_info.send(:invalid_line?,
                                    ' 1. Arsenal        38    26   9  3    79  -  36    87')).to be false
    end
  end

  describe '#load_values' do
    subject(:extract_file_info) { described_class.new(file_name) }

    it 'returns the correct values from the line' do
      line = '    1. Arsenal         38    26   9   3    79  -  36    87'
      expect(extract_file_info.send(:extract_values, line)).to eq([79, 36])
    end
  end
end
