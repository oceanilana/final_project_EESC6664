folder = 'monthly_chl_modis';
files = dir(fullfile(folder, '*.nc'));

% Read lat/lon once from the first file
lat = ncread(fullfile(folder, files(1).name), 'lat');
lon = ncread(fullfile(folder, files(1).name), 'lon');

% allocate table variables
n = numel(files);
years    = nan(n,1);
months   = nan(n,1);
datenums = nan(n,1);
chla     = cell(n,1);

for i = 1:n
    fpath = fullfile(folder, files(i).name);
    
    % Get year/month from metadata
    t_start = ncreadatt(fpath, '/', 'time_coverage_start');
    dt = datetime(t_start(1:10), 'InputFormat', 'yyyy-MM-dd');
    yr = year(dt); mo = month(dt);
    
    % Read data
    chl_data = ncread(fpath, 'chlor_a');
    chl_data(chl_data == -32767) = NaN; % this value is a fill value, so we fill with NaN
    
    years(i)    = yr;
    months(i)   = mo;
    datenums(i) = datenum(yr, mo, 15);
    chla{i}     = chl_data;
    
    fprintf('Done: %d-%02d\n', yr, mo);
end

T = table(years, months, datenums, chla, ...
    'VariableNames', {'Year','Month','datenum','chla'});
T = sortrows(T, 'datenum');



%% plot Chlorophyll Files 

    % Select the year and month to plot
    chl_data = T.chla{T.Year == 2024 & T.Month == 6};
   
    
    % Global Map for select month data
    figure();
    axesm('MapProjection', 'robinson', 'Grid', 'on');  
    framem on;  
    [lon, lat] = meshgrid(lon, lat); % Use meshgrid because the lats and lons are stored as vectors above
    pcolorm(lat, lon, log10(chl_data'));
    load coastlines;
    plotm(coastlat, coastlon, 'k');
    colormap(cmocean('algae'))
    hcb = colorbar('southoutside');
    xlabel(" chl-a mg/L")
    title('Monthly Chlorophyll-a');