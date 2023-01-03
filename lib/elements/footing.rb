module Elements
  class Footing
    attr_reader :step, :length_x, :length_y, :height, :material

    def initialize(length_x:, length_y:, height:, material:)
      @length_x = length_x.to_f
      @length_y = length_y.to_f
      @height = height.to_f
      @material = material
    end

    def horizontal_area
      length_x * length_y
    end
  end
end
