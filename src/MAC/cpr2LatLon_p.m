function [lon, lat] = cpr2LatLon_p(LAT, LON, CPRFlag, refLat, refLon)
    Dlat = 360/(60 - CPRFlag);
    j = floor(refLat / Dlat) + floor(.5 + mod(refLat, Dlat)/Dlat - LAT/131072);
    lat = Dlat * (j + LAT/131072);
    nl = cprNL(lat);
    if nl - CPRFlag > 0
        Dlon = 360/(nl - CPRFlag);
    else
        Dlon = 360;
    end
    m = floor(refLon/Dlon) + floor(.5 + mod(refLon, Dlon)/Dlon - LON/131072);
    lon = Dlon * (m + LON/131072);
end