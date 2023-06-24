module StructuraidCore
  module Elements
    module Helpers
      # This module is used to compute the reinforcement ratio of a layered reinforced element, such as a footing or a slab.
      #
      # A layered reinforced element is an element that has a top and a bottom reinforcement layer, in both directios: lenght_1 and lenght_2.
      module LayeredReinforcedElements
        def length_1_section_effective_area(above_middle:)
          if above_middle
            return @height - cover_bottom unless @longitudinal_top_reinforcement_length_1

            @longitudinal_top_reinforcement_length_1.centroid_height
          else
            return @height - cover_top unless @longitudinal_bottom_reinforcement_length_1

            @height - @longitudinal_bottom_reinforcement_length_1.centroid_height
          end
        end

        def length_2_section_effective_area(above_middle:)
          if above_middle
            return @height - cover_bottom unless @longitudinal_top_reinforcement_length_2

            @longitudinal_top_reinforcement_length_2.centroid_height
          else
            return @height - cover_top unless @longitudinal_bottom_reinforcement_length_2

            @height - @longitudinal_bottom_reinforcement_length_2.centroid_height
          end
        end

        def reinforcement_ratio_length_1(above_middle:)
          if above_middle
            return 0 if @longitudinal_top_reinforcement_length_1.empty?

            reinforcement = @longitudinal_top_reinforcement_length_1.area
          else
            return 0 if @longitudinal_bottom_reinforcement_length_1.empty?

            reinforcement = @longitudinal_bottom_reinforcement_length_1.area
          end

          section_direction = :length_1
          effective_area = width(section_direction:) * effective_height(section_direction:, above_middle:)
          reinforcement / effective_area
        end

        def reinforcement_ratio_length_2(above_middle:)
          if above_middle
            return 0 if @longitudinal_top_reinforcement_length_2.empty?

            reinforcement = @longitudinal_top_reinforcement_length_2.area
          else
            return 0 if @longitudinal_bottom_reinforcement_length_2.empty?

            reinforcement = @longitudinal_bottom_reinforcement_length_2.area
          end

          section_direction = :length_2
          effective_area = width(section_direction:) * effective_height(section_direction:, above_middle:)
          reinforcement / effective_area
        end
      end
    end
  end
end
