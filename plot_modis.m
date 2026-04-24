%% Read Chlorophyll Files 
addpath(genpath('/Users/ilanajacobs/Palevsky_Lab/Classes/EESC6664'))
ncdisp('AQUA_MODIS.20020101_20021231.L3m.YR.CHL.chlor_a.4km.nc')

filename = 'AQUA_MODIS.20020101_20021231.L3m.YR.CHL.chlor_a.4km.nc';

    % Read the data and coordinates
    chl_data = ncread(filename, 'chlor_a');
    lat = ncread(filename, 'lat');
    lon = ncread(filename, 'lon');
    
    % Global Map from 2002 data
    figure();
    axesm('MapProjection', 'robinson', 'Grid', 'on');  % Initialize map axes FIRST
    framem on;  % optional: draws a frame around the map
    [lon, lat] = meshgrid(lon, lat); % Use meshgrid because the lats and lons are stored as vectors
    pcolorm(lat, lon, log10(chl_data'));
    load coastlines;
    plotm(coastlat, coastlon, 'k'); % Adds coastlines
    colormap(cmocean('algae'))
    hcb = colorbar('southoutside');
    xlabel(" chl-a mg/L")
    title('2002 Annual Average Chlorophyll-a');
