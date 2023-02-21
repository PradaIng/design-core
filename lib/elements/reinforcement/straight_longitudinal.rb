require 'elements/reinforcement/base'
require 'elements/reinforcement/straight_longitudinal_layer'
require 'errors/reinforcement/empty_layers'

module Elements
  module Reinforcement
    class StraightLongitudinal < Base
      def initialize(distribution_direction:, above_middle: false)
        @above_middle = above_middle
        @layers = []
        @distribution_direction = distribution_direction
      end

      def add_layer(start_location:, end_location:, amount_of_rebars:, rebar:)
        id = @layers.empty? ? 1 : @layers.last.id
        start_location = modify_value_3_of_location(start_location, 0.5 * rebar.diameter)
        end_location = modify_value_3_of_location(end_location, 0.5 * rebar.diameter)
        @layers << Elements::Reinforcement::StraightLongitudinalLayer.new(
          start_location:,
          end_location:,
          amount_of_rebars:,
          rebar:,
          id:,
          distribution_direction: @distribution_direction
        )

        @layers.last
      end

      def change_layer_rebar_configuration(
        id_of_layer_to_change:,
        amount_of_new_rebars:,
        new_rebar:
      )
        straight_longitudinal_layer = find(id_of_layer_to_change)

        offset = (straight_longitudinal_layer.diameter - new_rebar.diameter) / 2
        offset *= -1 unless @above_middle

        straight_longitudinal_layer.modify_rebar_configuration(
          amount_of_new_rebars:,
          new_rebar:,
          offset:
        )

        straight_longitudinal_layer
      end

      def centroid_height
        if @layers.empty?
          raise Elements::Reinforcement::EmptyLayers, "can't complete centroid height calculation"
        end

        inertia = 0
        total_area = 0

        @layers.each do |layer|
          total_area += layer.area
          inertia += layer.inertia
        end

        inertia / total_area
      end

      def area
        @layers.map(&:area).reduce(:+)
      end

      private

      def update_z_base_of_layers
        @layers.each do |straight_longitudinal_layer|
          straight_longitudinal_layer.start_location.value_3 = @z_base
          straight_longitudinal_layer.end_location.value_3 = @z_base
        end
      end

      def find(id_of_layer_to_change)
        @layers.find do |existing_straight_longitudinal_layer|
          existing_straight_longitudinal_layer.id == id_of_layer_to_change
        end
      end

      def modify_value_3_of_location(location, offset)
        location.value_3 = above_middle ? location.value_3 - offset : location.value_3 + offset
      end
    end
  end
end
