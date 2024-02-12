function [R2, VarNames] = Random_Forest1(data_table,start1,end1,start2,end2)

d0_30 = survivaltable(data_table,start1,end1);
d30_60 = survivaltable(data_table,start2,end2);

d0_30 = Interested_attribute(d0_30);
d30_60 = Interested_attribute(d30_60);

Group_splitTables_0_30 = Delta_calculator(d30_60,d30_60);

% Assuming you have table1, table2, table3, table4, and table5 already defined
X = vertcat(Group_splitTables_0_30{1,1}(:,2:end),Group_splitTables_0_30{2,1}(:,2:end)...
    ,Group_splitTables_0_30{3,1}(:,2:end),Group_splitTables_0_30{4,1}(:,2:end));

% Replace this with your actual class labels
classLabels = [ones(size(Group_splitTables_0_30{1,1}(:,2:end), 1), 1);  % Assuming table1 has 'n' rows
               2*ones(size(Group_splitTables_0_30{2,1}(:,2:end), 1), 1);  % Assuming table2 has 'm' rows
               3*ones(size(Group_splitTables_0_30{3,1}(:,2:end), 1), 1);  % Assuming table3 has 'p' rows
               4*ones(size(Group_splitTables_0_30{4,1}(:,2:end), 1), 1);  % Assuming table4 has 'q' rows
              ]; % Assuming table5 has 'r' rows
%% Train Bagged Ensemble of Regression Trees
%'NumVariablesToSample','all' — Use all predictor variables at each node ...
% to ensure that each tree uses all predictor variables.


%'PredictorSelection','interaction-curvature' — Specify usage...
% of the interaction test to select split predictors.

%'Surrogate','on' — Specify usage of surrogate splits to increase...
% accuracy because the data set includes missing values.

t = templateTree('NumVariablesToSample','all',...
    'PredictorSelection','interaction-curvature','Surrogate','on');
rng(1); % For reproducibility
Mdl = fitrensemble(X,classLabels,'Method','Bag','NumLearningCycles',500, ...
    'Learners',t);

%Estimate the model R2 using out-of-bag predictions:
yHat = oobPredict(Mdl);
R2 = corr(Mdl.Y,yHat)^2; %Mdl explains 87% of the variability around the mean.
%% Predictor Importance Estimation
%Estimate predictor importance values by permuting out-of-bag observations
%among the trees:
impOOB = oobPermutedPredictorImportance(Mdl);  %The estimates are not biased toward predictors containing many levels.

% Sort the numeric values and get the sorting indices
[sortedValues, sortingIndices] = sort(impOOB,'descend');
VarNames = Group_splitTables_0_30{1,1}(:,2:end).Properties.VariableNames;

for i=1:numel(VarNames)
    VarNames_sorted(1,i) = VarNames(sortingIndices(i));
end

%Plot the Compare the predictor importance estimates.
n = 15;
figure(1)
bar(sortedValues(1:n))
title('Attribute Importances from Random Forest')
xlabel('Predictor Attributes')
ylabel('Attribute Importance Score')
h = gca;
h.XTick = 1:n;
h.XTickLabel = VarNames_sorted(1:n);
%h.XTickLabelRotation = 45;
h.TickLabelInterpreter = 'none';
h.FontSize = 15;

%The Predictive Measure of Association is a value that indicates the similarity...
% between decision rules that split observations. Larger values indicate more highly...
% correlated pairs of predictors.
[impGain,predAssociation] = predictorImportance(Mdl);

figure(2)
n = 10;
imagesc(predAssociation(1:n,1:n))
title('Predictor Association Estimates')
colorbar
h = gca;
h.XTickLabel = Mdl.PredictorNames;
h.XTickLabelRotation = 45;
h.TickLabelInterpreter = 'none';
%h.YTickLabel = Mdl.PredictorNames;
h.XTickLabel = VarNames_sorted(1:n);
h.YTickLabel = VarNames_sorted(1:n);
h.XTick = 1:n;
h.YTick = 1:n;

sortedValues_percentage = zeros([1,numel(sortedValues)]);
sortedValues_percentage(1,:)=100;

for i=2:numel(sortedValues)
    sortedValues_percentage(i) = (sortedValues(i)/sortedValues(1)) * 100;
end
    
n = 15;
figure(3)
bar(sortedValues_percentage(1:n))
title('Attribute Importances from Random Forest')
xlabel('Predictor Attributes')
ylabel('Attribute Importance Score')
%ylim([0,110])
h = gca;
h.XTick = 1:n;
h.XTickLabel = VarNames_sorted(1:n);
%h.XTickLabelRotation = 45;
h.TickLabelInterpreter = 'none';
h.FontSize = 15;
