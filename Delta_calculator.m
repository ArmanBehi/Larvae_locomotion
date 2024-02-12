function data_table = Delta_calculator(data1,data2)
%data1 must be the non-stimulated period 
%data2 must be the simulated period
data1 = d0_30;
data2 = d30_60;

cell1 = GroupwiseSplitBinnedData(data1);
cell2 = GroupwiseSplitBinnedData(data2);
% 
% for i=1:numel(cell1)
%     meanValue1(i,:) = nanmean(table2array(cell1{i,:}(:,2:end)));
% end
% 
% for i=1:numel(cell2) %Group
%     for j=1:numel(cell2{i,:}(:,1)) %number of rows
%         for Z=2:numel(cell2{i,:}(1,:))-1 %number of columns
%             if isnan(table2array(cell2{i,:}(j,Z)))
%                 cell2{i,:}(j,Z) = array2table(nan);
%             else
%                 cell2{i,:}(j,Z) = array2table(table2array(cell2{i,:}(j,Z))/meanValue1(i,Z));
%             end
%         end
%     end
% end
% 
% data_table = cell2;
for i=1:numel(cell1) %foe reach group
    for j=1:numel(cell1{i,1}(:,1))%number of rows
        for z=2:numel(cell1{i,1}(1,:))%number of columns
            cell1{i,1}(j,z) = table(table2array(cell2{i,1}(j,z)) - table2array(cell1{i,1}(j,z)));
        end
    end
end
data_table = cell1;
Group_splitTables_0_30  = data_table;