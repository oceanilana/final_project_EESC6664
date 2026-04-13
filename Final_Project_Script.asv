%% SST Data
% naming nc file 
filename = "erdMH1sstdmdayR20190SQ_6b4c_8e8f_4707_U1776108901207.nc";
% displaying nc file 
ncdisp(filename);

% read in lat lon and SST
lat_SST = ncread(filename, "latitude");
lon_SST = ncread(filename, "longitude");
SST = ncread(filename, "sstMasked");
time = ncread(filename, "time");

% raw time to matlab time 
time_days = time / 86400;
time0 = datenum("1970-01-01 00:00:00");
time = time0 + time_days;
Datestring = datestr(time);
clear time0;
clear time_days;
