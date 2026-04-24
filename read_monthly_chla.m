function T = read_monthly_chla(folder_path)
% READ_MONTHLY_CHLA  Read MODIS monthly chl-a .nc files into a table.
%
%   T = read_monthly_chla('monthly_global_chla')
%
%   Output table columns: Year, Month, datenum, chla_mean

    files = dir(fullfile(folder_path, '*.nc'));
    if isempty(files), error('No .nc files found in: %s', folder_path); end


n = numel(files);
    years    = nan(n,1);
    months   = nan(n,1);
    datenums = nan(n,1);
    chla     = cell(n,1);
 
    for i = 1:n
        fpath = fullfile(files(i).folder, files(i).name);
        fprintf('Reading: %s\n', files(i).name);
 
        tok = regexp(files(i).name, '(\d{4})(\d{2})\d{2}', 'tokens', 'once');
        if isempty(tok)
            warning('Skipping %s — cannot parse date', files(i).name);
            continue;
        end
        yr = str2double(tok{1});
        mo = str2double(tok{2});
 
        try
            data = double(ncread(fpath, 'chlor_a'));  % [lon x lat]
            data(data == -32767) = NaN;
            data(data < 0.001 | data > 100) = NaN;
        catch ME
            warning('Skipping %s — %s', files(i).name, ME.message);
            continue;
        end
 
        chla{i}      = data;
        years(i)     = yr;
        months(i)    = mo;
        datenums(i)  = datenum(yr, mo, 15);
    end
    good = ~isnan(years);
 T = table(years(good), months(good), datenums(good), chla(good), ...
        'VariableNames', {'Year','Month','datenum','chla'});
    T = sortrows(T, 'datenum');
end