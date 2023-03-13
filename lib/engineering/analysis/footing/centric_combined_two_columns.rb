require 'errors/engineering/analysis/section_direction_error'
require 'engineering/locations/absolute'
require 'engineering/locations/relative'
require 'engineering/vector'

module Engineering
  module Analysis
    module Footing
      class CentricCombinedTwoColumns
        ORTHOGONALITIES = %i[length_1 length_2].freeze

        def initialize(footing:, loads_from_columns:, section_direction:)
          if ORTHOGONALITIES.none?(section_direction)
            raise Engineering::Analysis::SectionDirectionError.new(section_direction, ORTHOGONALITIES)
          end

          @footing = footing
          @loads_from_columns = loads_from_columns
          @section_direction = section_direction
        end

        def solicitation_load
          solicitation * orthogonal_length
        end

        def shear
          geometry
        end

        def absolute_centroid
          moment_xx, moment_yy, total_load = *moment_and_load_totals

          Engineering::Locations::Absolute.new(
            value_x: moment_xx / total_load,
            value_y: moment_yy / total_load,
            value_z: value_z_mean
          )
        end

        def align_axis_1_whit_columns
          relativize_loads_from_columns
          aligner_vector = loads_from_columns.last.relative.to_vector

          loads_from_columns.each do |load_from_column|
            load_from_column.relative.align_axis_1_with(vector: aligner_vector)
          end

          loads_from_columns
        end

        private

        attr_reader :footing, :section_direction, :loads_from_columns

        def geometry; end

        def relativize_loads_from_columns
          @loads_from_columns = loads_from_columns.map do |load|
            {
              load:,
              relative: Engineering::Locations::Relative.from_location_to_location(
                from: absolute_centroid,
                to: load.location
              )
            }
          end
        end

        def section_length
          footing.public_send(section_direction)
        end

        def orthogonal_length
          footing.public_send(orthogonal_direction)
        end

        def moment_and_load_totals
          moment_xx = 0
          moment_yy = 0
          total_load = 0

          loads_from_columns.each do |load_from_column|
            moment_xx += load_from_column.value * load_from_column.location.value_x
            moment_yy += load_from_column.value * load_from_column.location.value_y
            total_load += load_from_column.value
          end

          [moment_xx, moment_yy, total_load]
        end

        def value_z_mean
          loads_from_columns.sum { |load_from_column| load_from_column.location.value_z } / loads_from_columns.size
        end

        def solicitation
          loads_from_columns.sum(&:value) / @footing.horizontal_area
        end

        def orthogonal_direction
          orthogonal = ORTHOGONALITIES - [@cut_direction]
          orthogonal.last
        end
      end
    end
  end
end
