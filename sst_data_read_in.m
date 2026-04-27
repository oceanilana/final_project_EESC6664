
folder=('monthly_sst_modis');
% addpath(genpath('/Users/celiam-b/Desktop/Grad School/Y1/Data Visualization/Final Project/final_project_EESC6664'))
% folder = '/Users/celiam-b/Desktop/Grad School/Y1/Data Visualization/Final Project/monthly_chl_modis';
files = dir(fullfile(folder, '*.nc'));

% Read lat/lon once from the first file
lat = ncread(fullfile(folder, files(1).name), 'lat');
lon = ncread(fullfile(folder, files(1).name), 'lon');

%%
%save('/Users/celiam-b/Desktop/Grad School/Y1/Data Visualization/Final Project/lat', 'lat', '-mat', '-v7.3')
%save('/Users/celiam-b/Desktop/Grad School/Y1/Data Visualization/Final Project/lon', 'lon', '-mat', '-v7.3')


% tic
% save('/Users/ilanajacobs/Palevsky_Lab/Classes/EESC6664/Chl', 'lon', '-mat', '-v7.3')
% save('/Users/ilanajacobs/Palevsky_Lab/Classes/EESC6664/Chl', 'lat', '-mat', '-v7.3')
% toc

%% allocate table variables
n = numel(files);
years    = nan(n,1);
months   = nan(n,1);
datenums = nan(n,1);
sst     = cell(n,1);

for i = 1:n
    fpath = fullfile(folder, files(i).name);
    
    % Get year/month from metadata
    t_start = ncreadatt(fpath, '/', 'time_coverage_start');
    dt = datetime(t_start(1:10), 'InputFormat', 'yyyy-MM-dd');
    yr = year(dt); 
    mo = month(dt);
    
    % Read data
    sst_data = ncread(fpath, 'sst');
    qual_sst = ncread(fpath, 'qual_sst');
    sst_data(sst_data == -32767 | qual_sst == 255) = NaN; % this value is a fill value, so we fill with NaN, select for high quality data

    years(i)    = yr;
    months(i)   = mo;
    datenums(i) = datenum(yr, mo, 15);
    sst{i}     = sst_data;
    
    fprintf('Done: %d-%02d\n', yr, mo);
end


% ** NOTE HERE THAT I CHANGED IT FROM T TO sst_table **

sst_table = table(years, months, datenums, sst, ...
    'VariableNames', {'Year','Month','datenum','sst'});
sst_table = sortrows(sst_table, 'datenum');
%%

%   save('/Users/celiam-b/Desktop/Grad School/Y1/Data Visualization/Final Project/Chl', 'sst_table', '-mat', '-v7.3')

% save('/Users/ilanajacobs/Palevsky_Lab/Classes/EESC6664/Chl', 'sst_table', '-mat', '-v7.3')

% %% plot Chlorophyll Files (to make sure everything read in properly!)
% 
%     % Select the year and month to plot
%     sst_data = sst_table.sst{sst_table.Year == 2024 & sst_table.Month == 6};
% 
% %     % downsample to be able to plot
% %     step = 10;
% % sst_sub = sst_data(1:step:end, 1:step:end);
% % lat_sub = lat(1:step:end);
% % lon_sub = lon(1:step:end);
% 
%     % Global Map for select month data
%     figure();
%     axesm('MapProjection', 'robinson', 'Grid', 'on');  
%     framem on;  
%     %[lon, lat] = meshgrid(lon, lat); % Use meshgrid because the lats and
%     %lons are stored as vectors above comment this out after the first time
%     %plotting.
%     pcolorm(lat, lon, (sst_data'));
%     load coastlines;
%     plotm(coastlat, coastlon, 'k');
%     colormap(cmocean('thermal'))
%     hcb = colorbar('southoutside');
%     xlabel("SST ºC")
%     title('Monthly Sea Surface Temperature (June 2024)');