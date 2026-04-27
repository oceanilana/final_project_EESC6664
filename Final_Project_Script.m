%% Read in Data Files 
 addpath(genpath('/Users/celiam-b/Desktop/Grad School/Y1/Data Visualization/Final Project'))
 folder = '/Users/celiam-b/Desktop/Grad School/Y1/Data Visualization/Final Project';
%addpath(genpath('/Users/ilanajacobs/Palevsky_Lab/Classes/EESC6664'))

% run("chla_data_read_in.m")
% run("sst_data_read_in.m")

% load(fullfile(folder, 'sst_table')); 
% load(fullfile(folder, 'chl_table'));
load(fullfile(folder, 'SST')); 
 load(fullfile(folder, 'Chl'));
 load(fullfile(folder, 'lat'));
 load(fullfile(folder, 'lon'));



%% Time Series

% global monthly average SST 
 SST_Global = cellfun(@(x) mean(x(:), 'omitnan'), SST.sst);
 Chl_Global = cellfun(@(x) mean(x(:), 'omitnan'), T.chla);
%SST_Global = cellfun(@(x) mean(x(:), 'omitnan'), sst_table.sst);
%Chl_Global = cellfun(@(x) mean(x(:), 'omitnan'), chl_table.chla);


%% global timer series 
figure(1); clf;


yyaxis left
plot(SST.datenum, SST_Global, 'LineWidth', 2, 'Color', "r"); 
 %plot(sst_table.datenum, SST_Global, 'LineWidth', 2, 'Color', "r"); 
ylabel('SST (°C)');
set(gca, 'YColor', "r"); 

yyaxis right
plot(T.datenum, Chl_Global, 'LineWidth', 2, 'Color', [0 0.4 0.3]); % Green
%plot(chl_table.datenum, Chl_Global, 'LineWidth', 2, 'Color', [0 0.4 0.3]); % Green
ylabel('Chl-A (mg/L)');
set(gca, 'YColor', [0 0.4 0.3]); % Matches axis color to line


datetick('x', 28)
xlabel('Time');
title('Global SST and Chlorophyll-A Trends');

%% Regional time series 



nMonths = height(SST);
 %nMonths = height(sst_table);

SST_Eq = nan(nMonths, 1);
SST_Mid = nan(nMonths, 1);
SST_High = nan(nMonths, 1);

Chl_Eq = nan(nMonths, 1);
Chl_Mid = nan(nMonths, 1);
Chl_High = nan(nMonths, 1);


idx_eq   = find(lat(:,1) >= -5 & lat(:,1) <= 5);
idx_mid  = find(lat(:,1) >= 30 & lat(:,1) <= 59);
idx_high = find(lat(:,1) >= 60 & lat(:,1) <= 90);


for i = 1:nMonths
    SST_i = SST.sst{i}; 
    Chl_i = T.chla{i};
    % SST_i = sst_table.sst{i}; 
    % Chl_i = chl_table.chla{i}; 
    % 
    zonalSST = mean(SST_i, 1, 'omitnan');
    zonalChl = mean(Chl_i, 1, 'omitnan');
    
  
    SST_Eq(i)   = mean(zonalSST(idx_eq), 'omitnan');
    SST_Mid(i)  = mean(zonalSST(idx_mid), 'omitnan');
    SST_High(i) = mean(zonalSST(idx_high), 'omitnan');
    
    Chl_Eq(i)   = mean(zonalChl(idx_eq), 'omitnan');
    Chl_Mid(i)  = mean(zonalChl(idx_mid), 'omitnan');
    Chl_High(i) = mean(zonalChl(idx_high), 'omitnan');
end

%%

% Plotting 
figure(2); clf;

subplot(3,1,1);
yyaxis left;  
plot(SST.datenum, SST_Eq, 'LineWidth', 1.5, "Color", "r"); 
% plot(sst_table.datenum, SST_Eq, 'LineWidth', 1.5, "Color", "r"); 
ylabel('SST (^oC)');
set(gca, 'YColor', "r"); 

yyaxis right; 
 plot(T.datenum, Chl_Eq, 'LineWidth', 1.5, "Color", [0 0.4 0.3]); 
% plot(chl_table.datenum, Chl_Eq, 'LineWidth', 1.5, "Color", [0 0.4 0.3]); 
ylabel('Chl-A (mg/L)');
set(gca, 'YColor', [0 0.4 0.3]);
title('Equator (5°S - 5°N)');
datetick('x', 28);

subplot(3,1,2);
yyaxis left;  
 plot(SST.datenum, SST_Mid, 'LineWidth', 1.5, "Color", "r"); 
%plot(sst_table.datenum, SST_Mid, 'LineWidth', 1.5, "Color", "r"); 
ylabel('SST (^oC)');
set(gca, 'YColor', "r"); 

yyaxis right; 
 plot(T.datenum, Chl_Mid, 'LineWidth', 1.5, "Color", [0 0.4 0.3]); 
%plot(chl_table.datenum, Chl_Mid, 'LineWidth', 1.5, "Color", [0 0.4 0.3]); 
ylabel('Chl-A (mg/L)');
set(gca, 'YColor', [0 0.4 0.3]);
title('Mid Latidue (30° - 59°N)');
datetick('x', 28);


subplot(3,1,3);
yyaxis left;  
 plot(SST.datenum, SST_High, 'LineWidth', 1.5, "Color", "r"); 
%plot(sst_table.datenum, SST_High, 'LineWidth', 1.5, "Color", "r"); 
ylabel('SST (^oC)');
set(gca, 'YColor', "r"); 

yyaxis right; 
plot(T.datenum, Chl_High, 'LineWidth', 1.5, "Color", [0 0.4 0.3]); 
%plot(chl_table.datenum, Chl_High, 'LineWidth', 1.5, "Color", [0 0.4 0.3]); 
ylabel('Chl-A (mg/L)');
set(gca, 'YColor', [0 0.4 0.3]);
title('High Latiude (60° - 90°N)');
datetick('x', 28);

%% Correlation yippee

% dimensions of array, number of lon and lat
 [nLon, nLat] = size(SST.sst{1});
%[nLon, nLat] = size(sst_table.sst{1});

% makes 3d matrix of nan to stack 12 months of maps 
monthly_maps_r = nan(nLon, nLat, 12); % For correlation
monthly_maps_p = nan(nLon, nLat, 12); % For significance

% runs through each month
for m = 1:12
    % finds where month is equal to m
     idx_month = find(SST.Month == m);
    %idx_month = find(sst_table.Month == m);

    % number of years (based on how many times month m is listed)   
    nYears = numel(idx_month);

    % stacks the 2d maps for each month into 3d matrix
     sst_monthly = cat(3, SST.sst{idx_month});
     chl_monthly = cat(3, T.chla{idx_month});
    % sst_monthly = cat(3, sst_table.sst{idx_month});
    % chl_monthly = cat(3, chl_table.chla{idx_month});


    % each column is is one pixel, each row is a different year 
    sst_flat = reshape(sst_monthly, [], nYears)';  % nYears x nPixels
    chl_flat = reshape(chl_monthly, [], nYears)';

    % NaN mask
    % finds where T/Chl data is missing 
    nan_mask = isnan(sst_flat) | isnan(chl_flat);
    % counts how many years have good data 
    n_valid = sum(~nan_mask, 1);

    % changes each nan value to zero  
    sst_flat(nan_mask) = 0;
    chl_flat(nan_mask) = 0;

    % demean to calculate pearson R (correlation)
    % sums all T/Chl for a specific pixel and divides by years with valid data
    % average T and Chl for every pixel
    sst_mu = sum(sst_flat, 1) ./ n_valid;
    chl_mu = sum(chl_flat, 1) ./ n_valid;
   
    % subtracts SST/Chl average value from measured, centers data around
    % zero
    sst_c = sst_flat - sst_mu;
    chl_c = chl_flat - chl_mu;

    % sets missing data back to zero after the subtracting mean step
    sst_c(nan_mask) = 0;
    chl_c(nan_mask) = 0;

    % Peasron Correlation formula
    % correlation and p-value calculation all pixels at once using matrix math instead
    % of looping over pixel by pixel
    % denominator covarience (T change x Chl change, then summed)
    % numerator (normalization so r between -1 and 1)
  
    r_vec = sum(sst_c .* chl_c, 1) ./ sqrt(sum(sst_c.^2, 1) .* sum(chl_c.^2, 1)); 
    
    % T-test (higher r and higher n means higher t test)
    t_stat = r_vec .* sqrt((n_valid - 2) ./ (1 - r_vec.^2));
   
    % confidence (p < 0.05 is significant) 
    p_vec  = 2 * (1 - tcdf(abs(t_stat), n_valid - 2));

    % back into geographic grid, with third dimension being time 
    monthly_maps_r(:, :, m) = reshape(r_vec, nLon, nLat);
    monthly_maps_p(:, :, m) = reshape(p_vec, nLon, nLat);

    fprintf('Finished month %d of 12\n', m);
end

% correlation if p < 0.05
significant_r = monthly_maps_r;
significant_r(monthly_maps_p > 0.05) = NaN;

%% Saving 
% Save the final correlation, p-values, and the filtered significant results
%save('/Users/celiam-b/Desktop/Grad School/Y1/Data Visualization/Final Project/SST_CHL_Correlation_Results','monthly_maps_r', 'monthly_maps_p', 'significant_r', '-mat', '-v7.3');

%% Plot global map of correlation for each month (only significant)

month_names = {'January', 'February', 'March', 'April', 'May', 'June', ...
               'July', 'August', 'September', 'October', 'November', 'December'};

for m = 1:12
    figure();
    axesm('MapProjection', 'robinson', 'Grid', 'on');
    framem on;
    pcolorm(lat, lon, significant_r(:,:,m)');
    load coastlines;
    plotm(coastlat, coastlon, 'k');
    colormap(cmocean('balance'))
    clim([-1 1]);
    hcb = colorbar('southoutside');
    xlabel(hcb, 'Pearson r')
    title(['SST vs Chl-a Correlation (', month_names{m}, ')']);
end


%% Plot global map of correlation for each month (all)

    figure();
    axesm('MapProjection', 'robinson', 'Grid', 'on');
    framem on;
    pcolorm(lat, lon, monthly_maps_r(:,:,12)');
    load coastlines;
    plotm(coastlat, coastlon, 'k');
    colormap(cmocean('balance'))
    clim([-1 1]);
    hcb = colorbar('southoutside');
    xlabel(hcb, 'Pearson r')
    title('SST vs Chl-a Correlation December');

%%
figure(3); clf;
imagesc(1:12, lat(:), r); 
set(gca, 'YDir', 'normal'); 
colormap(cmocean('balance'))
hcb = colorbar('southoutside');
xlabel('Month'); 
ylabel('Latitude');
set(gca, 'XTick', 1:12, 'XTickLabel', {'J','F','M','A','M','J','J','A','S','O','N','D'});
title('Seasonal Correlation of SST/Chl-a ');


%% Time series 

% Make the bin, arrays for 12 months for each region
r_eq   = nan(12, 1);
r_mid  = nan(12, 1);
r_high = nan(12, 1);


% Pre-allocate the heatmap matrix: [Latitudes x 12 Months]
nLat = size(monthly_maps_r, 2);
zonal_heatmap = nan(nLat, 12);

% goes through each layer of the correlation data (month by month)
for m = 1:12
    % map for current month
    current_map = monthly_maps_r(:,:,m);

    % average across longitude 
    zonal_r = mean(current_map, 1, 'omitnan');
    
    
    zonal_heatmap(:, m) = zonal_r';

    % use idx from before, to average across regions 
    r_eq(m)   = mean(zonal_r(idx_eq), 'omitnan');
    r_mid(m)  = mean(zonal_r(idx_mid), 'omitnan');
    r_high(m) = mean(zonal_r(idx_high), 'omitnan');
end
% plot
figure(4); clf;
months = 1:12;
plot(months, r_eq, '-r', 'LineWidth', 2, 'DisplayName', 'Equator'); hold on;
plot(months, r_mid, '-g', 'LineWidth', 2, 'DisplayName', 'Mid-Latitude');
plot(months, r_high, '-b', 'LineWidth', 2, 'DisplayName', 'High-Latitude');
xlim([1, 12]);
xticks(1:12);
xticklabels({'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'});
ylabel('Correlation Coefficient (r)');
xlabel('Month of Year');
title(' SST vs Chl-a Correlation');
legend('Location', 'best');


%% Heat Map - works? 
figure(5); clf;
imagesc(1:12, lat(:), zonal_heatmap); 
set(gca, 'YDir', 'normal'); 
colormap(cmocean('-balance'))
hcb = colorbar('southoutside');
xlabel('Month'); 
ylabel('Latitude');
set(gca, 'XTick', 1:12, 'XTickLabel', {'J','F','M','A','M','J','J','A','S','O','N','D'});
title('Monthly Correlation of SST/Chl-a ');
