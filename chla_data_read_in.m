
folder=('monthly_chl_modis');
% addpath(genpath('/Users/celiam-b/Desktop/Grad School/Y1/Data Visualization/Final Project/final_project_EESC6664'))
% folder = '/Users/celiam-b/Desktop/Grad School/Y1/Data Visualization/Final Project/monthly_chl_modis';
files = dir(fullfile(folder, '*.nc'));

% Read lat/lon once from the first file
lat = ncread(fullfile(folder, files(1).name), 'lat');
lon = ncread(fullfile(folder, files(1).name), 'lon');
%%
%save('/Users/celiam-b/Desktop/Grad School/Y1/Data Visualization/Final Project/lat', 'lat', '-mat', '-v7.3')
%save('/Users/celiam-b/Desktop/Grad School/Y1/Data Visualization/Final Project/lon', 'lon', '-mat', '-v7.3')

%% allocate table variables
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
    yr = year(dt); 
    mo = month(dt);
    
    % Read data
    chl_data = ncread(fpath, 'chlor_a');
    chl_data(chl_data == -32767) = NaN; % this value is a fill value, so we fill with NaN
    
    years(i)    = yr;
    months(i)   = mo;
    datenums(i) = datenum(yr, mo, 15);
    chla{i}     = chl_data;
    
    fprintf('Done: %d-%02d\n', yr, mo);
end


% ** NOTE HERE THAT I CHANGED IT FROM T TO chl_table **

chl_table = table(years, months, datenums, chla, ...
    'VariableNames', {'Year','Month','datenum','chla'});
chl_table = sortrows(chl_table, 'datenum');
%%

% %   save('/Users/celiam-b/Desktop/Grad School/Y1/Data Visualization/Final Project/Chl', 'chl_table', '-mat', '-v7.3')
% tic
% save('/Users/ilanajacobs/Palevsky_Lab/Classes/EESC6664/Chl', 'chl_table', '-mat', '-v7.3')
% toc
%% plot Chlorophyll Files (to make sure everything read in properly!)
    % 
    % % Select the year and month to plot
    % chl_data = chl_table.chla{chl_table.Year == 2024 & chl_table.Month == 6};
    % 
    % 
    % % Global Map for select month data
    % figure();
    % axesm('MapProjection', 'robinson', 'Grid', 'on');  
    % framem on;  
    % %[lon, lat] = meshgrid(lon, lat); % Use meshgrid because the lats and lons are stored as vectors above
    % pcolorm(lat, lon, log10(chl_data'));
    % load coastlines;
    % plotm(coastlat, coastlon, 'k');
    % colormap(cmocean('algae'))
    % hcb = colorbar('southoutside');
    % xlabel(" chl-a mg/L")
    % title('Monthly Chlorophyll-a (June 2024)');