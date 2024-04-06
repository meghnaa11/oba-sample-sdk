class CircularRegion
  attr_accessor :latitude, :longitude, :radius

  def initialize(latitude, longitude, radius)
    @latitude = latitude
    @longitude = longitude
    @radius = radius
  end
end
