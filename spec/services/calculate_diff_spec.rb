# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalculateDiff do
  subject { described_class.new(file_name) }

  let(:file_name) { nil }

  context 'when soccer' do
    let(:file_name) { 'soccer' }

    it 'returns the team with the smallest goal difference' do
      expect(subject.find_smallest).to eq('Aston_Villa')
    end
  end

  context 'when weather' do
    let(:file_name) { 'w_data' }

    it 'returns the day number with the smallest weather difference' do
      expect(subject.find_smallest).to eq('14')
    end
  end
end
