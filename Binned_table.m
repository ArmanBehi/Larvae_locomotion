function newcell = Binned_table(data_table,Start_time,End_time)

newcell = cell(3,1);%something
%%Dividing based on the frames
Conditions = findgroups(data_table.condition);

% Split the table into smaller tables based on the groups
groupsplittedData = splitapply(@(x){data_table(x,:)}, (1:height(data_table))', Conditions);
for l=1:numel(groupsplittedData)
    
    %%You have to import the table which splitted based on the Groups
    data=groupsplittedData{l,1};
    %%Dividing based on the frames
    Conditions = findgroups(data.frame);

    % Split the table into smaller tables based on the groups
    splitTables = splitapply(@(x){data(x,:)}, (1:height(data))', Conditions);

    variableNames = [{'tail_vel_forward_bl'},...
        {'abs_tail_vector_angular_speed'},{'abs_bending_angle'},{'midpoint_speed_bl'},{'abs_head_vector_angular_speed'},{'bending_angle'},...
        {'tail_vector_angular_speed'},{'head_vel_forward_bl'},{'head_vector_angular_speed'},{'Abs_HC_angle'},...
        {'HC_angle'}];
    st_time = Start_time*16;
    end_time = End_time*16;
    Time_difference = End_time - Start_time;

    splitTables2 = splitTables(st_time:end_time);
    variables_name = splitTables2{1,:}.Properties.VariableNames;

    for i=1:numel(splitTables2)
        splitTables2{i,:} = splitTables2{i,:}(:, variableNames);
    end

    for i=1:numel(splitTables2) %number of tables
        newtable_1(i,:) = varfun(@nanmean, splitTables2{i,:});

    end
    z=1;
    for i=1:Time_difference
        new_value(i,:) = nanmean(table2array(newtable_1(z:z+15,:)));
        z=z+16;
    end
    newtable = array2table(new_value,"VariableNames",variableNames);
    newcell{l,:} = newtable;
end

