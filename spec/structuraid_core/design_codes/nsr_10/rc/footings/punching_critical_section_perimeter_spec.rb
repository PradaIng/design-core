require 'spec_helper'

# rubocop:disable RSpec/FilePath
class FakeFooting < StructuraidCore::Elements::Footing
  def effective_height
    450
  end
end

RSpec.describe StructuraidCore::DesignCodes::NSR10::RC::Footings::PunchingCriticalSectionPerimeter do
  let(:length_1) { 2500 }
  let(:length_2) { 1000 }
  let(:height) { 300 }
  let(:cover_lateral) { 50 }
  let(:cover_top) { 50 }
  let(:cover_bottom) { 75 }
  let(:section_direction) { :length_1 }

  let(:footing) do
    FakeFooting.new(
      length_1:,
      length_2:,
      height:,
      material: StructuraidCore::Materials::Concrete.new(
        elastic_module: 1800,
        design_compression_strength: 28,
        specific_weight: 2.4
      ),
      cover_lateral:,
      cover_top:,
      cover_bottom:,
      longitudinal_bottom_reinforcement_length_1: nil,
      longitudinal_bottom_reinforcement_length_2: nil
    )
  end

  let(:lcs) do
    StructuraidCore::Engineering::Locations::CoordinatesSystem.new(
      anchor_location: StructuraidCore::Engineering::Locations::Absolute.new(
        value_x: 0,
        value_y: 0,
        value_z: 0
      )
    )
  end

  before do
    footing.add_coordinates_system(lcs)
  end

  describe '.call' do
    subject(:result) do
      described_class.call(
        column_section_length_1:,
        column_section_length_2:,
        column_absolute_location:,
        footing:
      )
    end

    let(:column_section_length_1) { 450 }
    let(:column_section_length_2) { 250 }

    describe 'column case: A' do
      let(:column_absolute_location) do
        StructuraidCore::Engineering::Locations::Absolute.new(
          value_x: -1025,
          value_y: 375,
          value_z: 0
        )
      end
      let(:expected_perimeter) { 1150 }

      it "updates local system's relative_locations" do
        result
      end

      it 'returns the right perimeter' do
        expect(result).to eq(expected_perimeter)
      end
    end

    describe 'column case: B' do
      let(:column_absolute_location) do
        StructuraidCore::Engineering::Locations::Absolute.new(
          value_x: 0,
          value_y: 375,
          value_z: 0
        )
      end
      let(:expected_perimeter) { 1850 }

      it "updates local system's relative_locations" do
        result
      end

      it 'returns the right perimeter' do
        expect(result).to eq(expected_perimeter)
      end
    end

    describe 'column case: C' do
      let(:column_absolute_location) do
        StructuraidCore::Engineering::Locations::Absolute.new(
          value_x: 1025,
          value_y: 375,
          value_z: 0
        )
      end
      let(:expected_perimeter) { 1150 }

      it "updates local system's relative_locations" do
        result
      end

      it 'returns the right perimeter' do
        expect(result).to eq(expected_perimeter)
      end
    end

    describe 'column case: D' do
      let(:column_absolute_location) do
        StructuraidCore::Engineering::Locations::Absolute.new(
          value_x: -1025,
          value_y: 0,
          value_z: 0
        )
      end
      let(:expected_perimeter) { 2050 }

      it "updates local system's relative_locations" do
        result
      end

      it 'returns the right perimeter' do
        expect(result).to eq(expected_perimeter)
      end
    end

    describe 'column case: E' do
      let(:column_absolute_location) do
        StructuraidCore::Engineering::Locations::Absolute.new(
          value_x: 0,
          value_y: 0,
          value_z: 0
        )
      end
      let(:expected_perimeter) { 3200 }

      it "updates local system's relative_locations" do
        result
      end

      it 'returns the right perimeter' do
        expect(result).to eq(expected_perimeter)
      end
    end

    describe 'column case: F' do
      let(:column_absolute_location) do
        StructuraidCore::Engineering::Locations::Absolute.new(
          value_x: 1025,
          value_y: 0,
          value_z: 0
        )
      end
      let(:expected_perimeter) { 2050 }

      it "updates local system's relative_locations" do
        result
      end

      it 'returns the right perimeter' do
        expect(result).to eq(expected_perimeter)
      end
    end

    describe 'column case: G' do
      let(:column_absolute_location) do
        StructuraidCore::Engineering::Locations::Absolute.new(
          value_x: -1025,
          value_y: -375,
          value_z: 0
        )
      end
      let(:expected_perimeter) { 1150 }

      it "updates local system's relative_locations" do
        result
      end

      it 'returns the right perimeter' do
        expect(result).to eq(expected_perimeter)
      end
    end

    describe 'column case: H' do
      let(:column_absolute_location) do
        StructuraidCore::Engineering::Locations::Absolute.new(
          value_x: 0,
          value_y: -375,
          value_z: 0
        )
      end
      let(:expected_perimeter) { 1850 }

      it "updates local system's relative_locations" do
        result
      end

      it 'returns the right perimeter' do
        expect(result).to eq(expected_perimeter)
      end
    end

    describe 'column case: I' do
      let(:column_absolute_location) do
        StructuraidCore::Engineering::Locations::Absolute.new(
          value_x: 1025,
          value_y: -375,
          value_z: 0
        )
      end
      let(:expected_perimeter) { 1150 }

      it "updates local system's relative_locations" do
        result
      end

      it 'returns the right perimeter' do
        expect(result).to eq(expected_perimeter)
      end
    end
  end
end
# rubocop:enable RSpec/FilePath
