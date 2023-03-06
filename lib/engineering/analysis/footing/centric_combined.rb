require 'errors/engineering/analysis/section_direction_error'
require 'engineering/locations/absolute'

module Engineering
  module Analysis
    module Footing
      class CentricCombined
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
          solicitation * @footing.public_send(orthogonal_direction)
        end

        def max_shear_solicitation
          solicitation_load * @footing.public_send(@section_direction)
        end

        def absolute_centroid
          moment_xx, moment_yy, total_load = *moment_and_load_totals

          Engineering::Locations::Absolute.new(
            value_x: moment_xx / total_load,
            value_y: moment_yy / total_load,
            value_z: value_z_mean
          )
        end

        private

        def moment_and_load_totals
          moment_xx = 0
          moment_yy = 0
          total_load = 0

          @loads_from_columns.each do |load_from_column|
            moment_xx += load_from_column.value * load_from_column.location.value_x
            moment_yy += load_from_column.value * load_from_column.location.value_y
            total_load += load_from_column.value
          end

          [moment_xx, moment_yy, total_load]
        end

        def value_z_mean
          @loads_from_columns.sum { |load_from_column| load_from_column.location.value_z } / @loads_from_columns.size
        end

        def solicitation
          @loads_from_columns.sum(&:value) / @footing.horizontal_area
        end

        def orthogonal_direction
          orthogonal = ORTHOGONALITIES - [@cut_direction]
          orthogonal.last
        end
      end
    end
  end
end
