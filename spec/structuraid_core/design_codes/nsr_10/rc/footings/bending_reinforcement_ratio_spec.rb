require 'spec_helper'

# rubocop:disable RSpec/FilePath
RSpec.describe StructuraidCore::DesignCodes::NSR10::RC::Footings::BendingReinforcementRatio do
  describe '.call' do
    subject(:result) do
      described_class.call(
        design_compression_strength:,
        design_steel_yield_strength:,
        width:,
        effective_height:,
        flexural_moment:,
        capacity_reduction_factor:
      )
    end

    let(:design_steel_yield_strength) { 420_000_000 } # N/(m**2)
    let(:width) { 2.5 } # m
    let(:effective_height) { 0.45 } # m
    let(:capacity_reduction_factor) { 0.90 }
    
    describe 'when concrete is 28MPa' do
      let(:design_compression_strength) { 28_000_000 } # N/(m**2)

      describe 'when flexural moment is small' do
        let(:flexural_moment) { 50 } # N*m
  
        it 'returns minimal ratio' do
          expect(result).to eq(StructuraidCore::DesignCodes::NSR10::RC::Footings::BendingReinforcementRatio::MINIMUM_RATIO)
        end
      end
    end
  end
end
# rubocop:enable RSpec/FilePath
