%% Determine latency to REM
% Specify folder of interest
myFolder = 'E:\Projects\09 EKo EEG\TSV';

% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(myFolder,'*.tsv'); 
theFiles = dir(filePattern); 

% Find all instances of REM and record the NREM epoch prior to the REM bout
for k = 1 : length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(myFolder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    file = importfile(fullFileName); %external function Brandon made to import data as cell array

    %getDateTime = [file{:,2}];
    %getDateTime = datetime(getDateTime);
    %getDateTime.Format = 'hh:mm:ss';
    %getDateTime = cellstr(getDateTime);
    %getDateTime = reshape(getDateTime,[],1);
        
    %out = str2double(regexp(getDateTime,'\d*','match'));
    %time = str2double(getDateTime);
    %val = cell2mat(file(:,5));
    
    val = cell2mat(file(:,5));
    time = cell2mat(file(:,1));
    
    cellfind = @(string)(@(cell_contents)(strcmp(string,cell_contents)));
    log = cellfun(cellfind('REM'),file(:,4));
    full = [time val];
    rem = [time log];
    rem = rem(all(rem,2),:);

    nrem = zeros(length(rem),1);

        for i = 1:length(rem)
            temp = find(full(:,1) < rem(i));
            temp = temp(end);
            nrem(i,:) = full(temp,2);
        end

    nrem = mean(nrem);
    
    final(:,k) = nrem;
end