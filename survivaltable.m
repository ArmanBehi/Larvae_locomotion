function resultTable = survivaltable(data_table,N_start,N_terminal)

N_start = N_start*16;
N_terminal = N_terminal*16;

%% Calculating number of n in each time of experiment and plot it
ID_Group = IDwiseSplit(data_table);

Number_of_frame = zeros([numel(ID_Group),2]);
for i = 1:numel(ID_Group) %making a table that shows first and last frame of each ID
    Number_of_frame(i,1) = ID_Group{i,1}.frame(1);
    Number_of_frame(i,2) = ID_Group{i,1}.frame(end);
end

%% Finding the ID's that have a frame from "N_start" till "N_terminal" by
%defining a table called "include"
include = zeros([numel(ID_Group),1]);
for i=1:numel(ID_Group)
    if Number_of_frame(i,1)<=N_start && Number_of_frame(i,2)>=N_terminal
        include(i,1) = 1;
    else
        include(i,1) = 0;
    end
end

%% Droping the ID's that got zero value in the matrix "include"
filteredCellArray = ID_Group(include ~= 0);

%% Now excluding the data that lay in between N_start and N_terminal
for i=1:numel(filteredCellArray)
    filteredCellArray(i,1) = cellfun(@(t) t(t.frame >= N_start & t.frame <= N_terminal, :), filteredCellArray(i,1), 'UniformOutput', false);
end

% Concatenate all tables into a single table
resultTable = vertcat(filteredCellArray{:}); 