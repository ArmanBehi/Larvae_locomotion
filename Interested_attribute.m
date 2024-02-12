function data_table = Interested_attribute(inputTable)

%% Function double to NAn
  % Create a copy of the original table to store the updated values
    updatedTable = inputTable;

    %updatedTable = removevars(d150_160, 1:4);
    % Get the size of the table
    [numRows, numCols] = size(updatedTable);

    % Loop through each cell in the table
    for row = 1:numRows
        for col = 1:numCols
            % Get the current cell value as a character
            cellValue = updatedTable{row, col};

            % Convert 'NA' to NaN
            if iscell(cellValue) && strcmpi(cellValue, 'NA')
                
                newtable(row, col) = nan;
                
            
            elseif  iscell(cellValue) && ~strcmpi(cellValue, 'NA')
                 % newtable(row, col) = cell2mat(cellValue);
                  newtable(row, col) = str2double(cellValue);
             else
                  newtable(row, col) = updatedTable{row, col};
            end
        end
    end

    % Get the variable names from the table
variableNames = updatedTable.Properties.VariableNames;
% Create a string array or cell array to store the variable names
% Using string array:
variableNamesArray = string(variableNames);

% Convert the matrix to a table
data_table = array2table(newtable(:,1:end),'VariableNames',variableNamesArray(:,1:end));

%% Calculating interested CV

CV_attribute = [12,20,26,32,38,42,58,74,78,82];
for i=1:length(CV_attribute)
    for j=1:numel(data_table(:,1))
        if isnan(table2array(data_table(j,CV_attribute(i))))
            data_table(j,CV_attribute(i)) = data_table(j,CV_attribute(i));
        else
            data_table(j,CV_attribute(i))=array2table((sqrt(table2array(data_table(j,CV_attribute(i)))))/(table2array(data_table(j,CV_attribute(i)-1)))*100);
        end
    end
end

%% Dropping non-relevant attribute
% Define the column numbers to remove (e.g., columns 2 and 4)
columns_to_remove = [2,3,4,5,6,7,8,10,13,15,14,16,18,22,23,24,27,28,30,33,34,35,36,39,40,44,...
    45,46,47,48,49,50,51,...
    52,53,54,56,59,60,61,62,64,67,69,70,72,75,76,80,83,84,85,86,87,88,89,90,91,92,93,94,...
    96,97,98,99,100,101,102,103]; % Specify the column numbers to remove

% Drop the specified columns
data_table(:, columns_to_remove) = []; % Remove the specified columns

group_condition = updatedTable.group_condition;
%data_table = addvars(updatedTable, group_condition, 'Before', 'bending_angle_mean');

table2 = table(group_condition,'VariableNames',{'group_condition'});

data_table = [table2,data_table(:,2:end)];