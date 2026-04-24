%% Read in Data Files 
addpath(genpath('/Users/celiam-b/Desktop/Grad School/Y1/Data Visualization/Final Project'))
folder = '/Users/celiam-b/Desktop/Grad School/Y1/Data Visualization/Final Project';


load(fullfile(folder, 'SST')); 
load(fullfile(folder, 'Chl'));
load(fullfile(folder, 'lat'));
load(fullfile(folder, 'lon'));



%% Time Series

% global monthly average SST 
SST_Global = cellfun(@(x) mean(x(:), 'omitnan'), SST.sst);
Chl_Global = cellfun(@(x) mean(x(:), 'omitnan'), T.chla);

%% global timer series 
figure(1); clf;

yyaxis left
plot(SST.datenum, SST_Global, 'LineWidth', 2, 'Color', "r"); 
ylabel('SST (°C)');
set(gca, 'YColor', "r"); 

yyaxis right
plot(SST.datenum, Chl_Global, 'LineWidth', 2, 'Color', [0 0.4 0.3]); % Green
ylabel('Chl-A (mg/L)');
set(gca, 'YColor', [0 0.4 0.3]); % Matches axis color to line


datetick('x', 28)
xlabel('Time');
title('Global SST and Chlorophyll-A Trends');


%% Regional time series 



nMonths = height(SST);

SST_Eq = nan(nMonths, 1);
SST_Mid = nan(nMonths, 1);
SST_High = nan(nMonths, 1);

Chl_Eq = nan(nMonths, 1);
Chl_Mid = nan(nMonths, 1);
Chl_High = nan(nMonths, 1);


lat = sort(lat, 'descend');
idx_eq   = find(lat(:,1) >= -5 & lat(:,1) <= 5);
idx_mid  = find(lat(:,1) >= 30 & lat(:,1) <= 60);
idx_high = find(lat(:,1) >= 60 & lat(:,1) <= 90);


for i = 1:nMonths
    SST_i = SST.sst{i}; 
    Chl_i = T.chla{i}; 
    
    zonalSST = mean(SST_i, 2, 'omitnan');
    zonalChl = mean(Chl_i, 2, 'omitnan');
    
  
    SST_Eq(i)   = mean(zonalSST(idx_eq), 'omitnan');
    SST_Mid(i)  = mean(zonalSST(idx_mid), 'omitnan');
    SST_High(i) = mean(zonalSST(idx_high), 'omitnan');
    
    Chl_Eq(i)   = mean(zonalChl(idx_eq), 'omitnan');
    Chl_Mid(i)  = mean(zonalChl(idx_mid), 'omitnan');
    Chl_High(i) = mean(zonalChl(idx_high), 'omitnan');
end


% Plotting 
figure(2); clf;

subplot(1,3,1);
yyaxis left;  
plot(SST.datenum, SST_Eq, 'LineWidth', 1.5); 
ylabel('SST (^oC)');
yyaxis right; 
plot(SST.datenum, Chl_Eq, 'LineWidth', 1.5); 
ylabel('Chl-A (mg/L)');
title('Equator (5°S - 5°N)');
datetick('x', 28);

subplot(1,3,2);
yyaxis left;  
plot(SST.datenum, SST_Mid, 'LineWidth', 1.5); 
ylabel('SST (^oC)');
yyaxis right; 
plot(SST.datenum, Chl_Mid, 'LineWidth', 1.5); 
ylabel('Chl-A (mg/L)');
title('Mid Latidue (30° - 60°N)');
datetick('x', 28);


subplot(1,3,3);
yyaxis left;  
plot(SST.datenum, SST_High, 'LineWidth', 1.5); 
ylabel('SST (^oC)');
yyaxis right; 
plot(SST.datenum, Chl_High, 'LineWidth', 1.5); 
ylabel('Chl-A (mg/L)');
title('High Latiude (60° - 90°N)');
datetick('x', 28);
