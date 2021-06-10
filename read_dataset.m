function data = read_dataset(filename,rangeData)
    % dengan READMATRIX() -> tidak support tipe string
        % range = detectImportOptions('Minerals_Database.csv');
        % range.SelectedVariableNames = (rangeData); % -> kolom 3-10
        % data = readmatrix('Minerals_Database.csv',range);

    % dengan READTABLE() -> support semua
        data = readtable(filename,'Range',rangeData);
        data = table2cell(data);
end