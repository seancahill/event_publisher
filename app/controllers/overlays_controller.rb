class OverlaysController < ApplicationController

# On the surface of the Earth, there are no straight lines. Due to the spherical
# shape of the Earth, all distance calculations must take into account the arc
# described by a distance between two points. Simple trigonometry does not apply
# and we need to look more into spherical and hyperbolic geometry to achieve
# this.
# The Earth is not perfectly circular either, with the shape being more ellipsoid
# making calculations even more complex. added to this, the arc is not the same
# at various meridians. To simplify this a median radius of the Earth will be
# used for calculations. Unless you need to calculate to within a meter of a
# given point, this method will suffice.
# Bernhard Riemann, in the nineteenth century, gave rise to spherical geometry
# from which the Great Circle Distance formulae evolved. It is this Great Circle
# Distance formulae that will be used in this action.
# Armed with this information, here is the way to calculate the distance between
# two give points, give the latitude and longitude.

  def index
    # passed parameters are distance => the distance from the point of interest
    # e.g. this could be the lat long of an event location
    # this method assumes meters e.g. 0.5 will be 500 meters
    # the latitude and longitude of the point of interest
    # the service we are interested in :value e.g. eating, atm, pub
    # the sql statement uses the lat and long on the database file to compare
    # with the lat long of the point of interest
    @typeof = params[:value].gsub("_"," ")
    @distance = params[:distance]
    @lon = params[:lon]
    @lat = params[:lat]
    # 6371 is the radius of the earth in kms

    @distcalc = "( 6371 * ACOS( COS( RADIANS(#{@lat}) ) * COS( RADIANS( lat ) ) * COS( RADIANS( lon ) - RADIANS(#{@lon}) ) + SIN( RADIANS(#{@lat}) ) * SIN( RADIANS( lat ) ) ) ) "
    @grouping = "GROUP BY id,lon,lat,name,amenity,operator,typeof"
    @sql = "SELECT *," + @distcalc + " AS distance FROM overlays " + @grouping + " HAVING " + @distcalc + " < #{@distance} and typeof = '#{@typeof}' "
    begin
       @overlays = Overlay.find_by_sql(@sql)
    rescue => e
      redirect_to(error_path, :notice => "Error: #{e.message}")
    end
    # clean data 
    @overlays.each do
     |ol |
     ol.name = ol.name.gsub("&apos;","'")
     ol.name = ol.name.gsub("&amp;","&")
    end

    respond_to do |format|
       format.xml  { render :xml => @overlays }
       format.json  { render :json => @overlays }
    end

  end
  
  def show
    respond_to do |format|
      format.html
      format.xml  { render :xml => @overlays }
      format.json  { render :json => @overlays }
    end

  end
end
