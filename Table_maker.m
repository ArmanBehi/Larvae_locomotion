function newtable = Table_maker(data_table,Start_time,End_time)

% Start_time = 30;
% End_time = 60;

Etime = End_time*16;
Stime = Start_time*16;
ID_splitTables = IDwiseSplit(data_table);

%Finding individuals that have data in between start and end time
counter = 0;
for i=1:numel(ID_splitTables)
   % if min(ID_splitTables{i}.frame)<Etime || max(ID_splitTables{i}.frame)>Stime

        if max(ID_splitTables{i}.frame)>Stime && min(ID_splitTables{i}.frame)<Stime && max(ID_splitTables{i}.frame)<Etime
            counter = counter+1;
            B{counter,1} = ID_splitTables{i}(find(ID_splitTables{i}.frame == Stime):end,:);
            

        elseif max(ID_splitTables{i}.frame)>Etime && min(ID_splitTables{i}.frame)>Stime && min(ID_splitTables{i}.frame)<Etime
            counter = counter+1;
            B{counter,1} = ID_splitTables{i}(1:find(ID_splitTables{i}.frame == Etime),:);
            

        elseif max(ID_splitTables{i}.frame)>Etime && min(ID_splitTables{i}.frame)<Stime
            counter = counter+1;
            B{counter,1} = ID_splitTables{i}(find(ID_splitTables{i}.frame == Stime):find(ID_splitTables{i}.frame == Etime),:);
            

        elseif max(ID_splitTables{i}.frame)<Etime && min(ID_splitTables{i}.frame)>Stime
            counter = counter+1;
            B{counter,1} = ID_splitTables{i};
            

        end
        
    %end
end


columnsToKeep = zeros([1,numel(B{1}(1,:))]);
turn_to_one = [1,12,13,15,16,93,94,98,99,100,101,102,103,104,105,109,110,188,192,193,198,...
    199,201,202,203,208,209];
columnsToKeep(1,turn_to_one) = 1;
columnsToKeep = logical(columnsToKeep);
for i=1:numel(B)
    B{i} = B{i}(:, columnsToKeep);
end

%% Calculating mean value
variableNames = B{1}(1, 6:27);
for i=1:numel(B)
    meanValuesTable(i,:) = array2table(nanmean(B{i}{:, 6:27}), 'VariableNames', variableNames.Properties.VariableNames); 

    IDs(i,:) = B{i}(1,2:5);
    %Abs_bending_angle
    Var_Abs_bending_angle = nanstd(B{i}.abs_bending_angle);
    Mean_Abs_bending_angle = nanmean(B{i}.abs_bending_angle);
    CV_Bending_angle = (Var_Abs_bending_angle/Mean_Abs_bending_angle)*100;
    CV_Bending_angle_table(i,:) = table(CV_Bending_angle,'VariableNames',{'CV_Bending_angle'});
    %CV_HV
    Var_AHV = nanstd(B{i}.abs_head_vector_angular_speed);
    Mean_HV = nanmean(B{i}.abs_head_vector_angular_speed);
    CV_HV = (Var_AHV/Mean_HV)*100;
    CV_HV_table(i,:) = table(CV_HV,'VariableNames',{'CV absolute HV angular speed'});
    %CV_absolute TV angular speed
    Var_TV = nanstd(B{i}.abs_tail_vector_angular_speed);
    Mean_TV = nanmean(B{i}.abs_tail_vector_angular_speed);
    CV_TV = (Var_TV/Mean_TV)*100;
    CV_TV_table(i,:) = table(CV_TV,'VariableNames',{'CV absolute TV angular speed'});
    %CV absolute IS angle
    Var_IS = nanstd(B{i}.Abs_IS_angle);
    Mean_IS = nanmean(B{i}.Abs_IS_angle);
    CV_IS = (Var_IS/Mean_IS)*100;
    CV_IS_table(i,:) = table(CV_IS,'VariableNames',{'CV absolute IS angle'});
    %CV absolute HC angle
    Var_HC = nanstd(B{i}.Abs_HC_angle);
    Mean_HC = nanmean(B{i}.Abs_HC_angle);
    CV_HC = (Var_HC/Mean_HC)*100;
    CV_HC_table(i,:) = table(CV_HC,'VariableNames',{'CV absolute HC angle'});
     %CV midpoint speed
    Var_midpoint = nanstd(B{i}.midpoint_speed);
    Mean_midpoint = nanmean(B{i}.midpoint_speed);
    CV_midpoint = (Var_midpoint/Mean_midpoint)*100;
    CV_midpoint_table(i,:) = table(CV_midpoint,'VariableNames',{'CV absolute HC angle'});
       %CV head forward velocity
    Var_head_vel = nanstd(B{i}.head_vel_forward);
    Mean_head_vel = nanmean(B{i}.head_vel_forward);
    CV_head_vel = (Var_head_vel/Mean_head_vel)*100;
    CV_head_vel_table(i,:) = table(CV_head_vel,'VariableNames',{'CV head forward velocity'});
     %CV tail forward velocity
    Var_tail_vel = nanstd(B{i}.tail_vel_forward);
    Mean_tail_vel = nanmean(B{i}.tail_vel_forward);
    CV_tail_vel = (Var_tail_vel/Mean_tail_vel)*100;
    CV_tail_vel_table(i,:) = table(CV_tail_vel,'VariableNames',{'CV tail forward velocity'});
      %CV IS distance
    Var_IS_distance = nanstd(B{i}.IS_distance);
    Mean_IS_distance = nanmean(B{i}.IS_distance);
    CV_IS_distance = (Var_IS_distance/Mean_IS_distance)*100;
    CV_IS_distance_table(i,:) = table(CV_IS_distance,'VariableNames',{'CV IS distance'});
%      %CV IS speed
%     Var_IS_distance = nanstd(B{i}.IS_);
%     Mean_IS_distance = nanmean(B{i}.IS_distance);
%     CV_IS_distance = (Var_IS_distance/Mean_IS_distance)*100;
%     CV_IS_distance_table = table(CV_IS_distance,'VariableNames',{'CV IS distance'});
    
end

% variableNames = B{1}(1, 6:27);
% meanValuesTable = array2table(meanValues, 'VariableNames', variableNames.Properties.VariableNames)

newtable = [IDs , meanValuesTable,CV_Bending_angle_table,CV_HV_table,CV_TV_table,CV_IS_table,CV_midpoint_table,...
    CV_head_vel_table,CV_tail_vel_table,CV_IS_distance_table];


