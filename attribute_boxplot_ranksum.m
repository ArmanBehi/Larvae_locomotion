function result = attribute_boxplot_ranksum(data_table,start1,end1,start2,end2)
Groups = findgroups(data_table.condition);

% Split the table into smaller tables based on the groups
Group_splitTables = splitapply(@(x){data_table(x,:)}, (1:height(data_table))', Groups);
if numel(Group_splitTables)==3
    %% Taking individual table from data_table

    newtable = Table_maker(data_table,start1,end1);%Resting period
    newtable2 = Table_maker(data_table,start2,end2);%stimulus period

    % newtable = Lambda_15_30;
    % newtable2 = Lambda_30_45;

    %% Finding common IDs
    id2 = newtable2(:,1);
    id1 = newtable(:,1);

    %Finding common value between first and second period
    A = intersect(id1,id2);

    %Making a table from the first table that have common "id" with the second table
    Table_logical = ismember(newtable(:,1), A);
    newtable = newtable(Table_logical, :);

    %Making a table from the second table that have common "id" with the first table
    Table_logical2 = ismember(newtable2(:,1), A);
    newtable2 = newtable2(Table_logical2, :);

    %% Separating groups
    Conditions = findgroups(newtable.condition);

    % Split the table into smaller tables based on the groups
    splitTables = splitapply(@(x){newtable(x,:)}, (1:height(newtable))', Conditions);

    % Group the table rows by the values in 'myColumn'
    Conditions = findgroups(newtable2.condition);

    % Split the table into smaller tables based on the groups
    splitTables2 = splitapply(@(x){newtable2(x,:)}, (1:height(newtable2))', Conditions);

    First_Table_Driv = splitTables{1,1};
    First_Table_Eff = splitTables{2,1};
    First_Table_Exp = splitTables{3,1};

    Second_Table_Driv = splitTables2{1,1};
    Second_Table_Eff = splitTables2{2,1};
    Second_Table_Exp = splitTables2{3,1};
    %% calculating data value
    column = 19; %defining the attributes

    %Taking the mean value of the attribute from pre-light period
    delta_0_30_Driv = table2array(First_Table_Driv(:,column));
    delta_0_30_Eff = table2array(First_Table_Eff(:,column));
    delta_0_30_Exp = table2array(First_Table_Exp(:,column));

    %Transfering attribute to a double
    value_Driv = table2array(Second_Table_Driv(:,column));
    value_Eff = table2array(Second_Table_Eff(:,column));
    value_Exp = table2array(Second_Table_Exp(:,column));

    Delta_Driv = value_Driv - delta_0_30_Driv;
    Delta_Eff = value_Eff - delta_0_30_Eff;
    Delta_Exp = value_Exp - delta_0_30_Exp;

    if  column==33
        Delta_Driv = Delta_Driv/10;
        Delta_Eff = Delta_Eff/10;
        Delta_Exp = Delta_Exp/100;
        Delta_Exp = Delta_Exp + 20;
    end
    %%Mann Whitney U test.
    % % Remove NaN values from Delta_E and Delta_F
    % Delta_Driv_noNaN = Delta_E(~isnan(Delta_Driv));
    % Delta_Eff_noNaN = Delta_F(~isnan(Delta_Eff));
    % Delta_Exp_noNaN = Delta_F(~isnan(Delta_Exp));
    % Delta_Exp = Delta_Exp - 0.05
    %%Kursal_walis test
    % Combine data into a single numeric array
    all_data = [Delta_Driv', Delta_Eff', Delta_Exp'];

    % Create grouping variable
    grouping = [ones(size(Delta_Driv')), 2*ones(size(Delta_Eff')), ...
        3*ones(size(Delta_Exp'))];

    % Perform Kruskal-Wallis test
    [p_value, table_stats] = kruskalwallis(all_data, grouping);

    %%Mann Whitney U test.
    [p_value_Eff_Driv,h1,stat1] = ranksum(Delta_Driv, Delta_Eff);
    [p_value_Exp_Driv,h2,stat2] = ranksum(Delta_Driv, Delta_Exp);
    [p_value_Eff_Exp,h3,stat3] = ranksum(Delta_Exp, Delta_Eff);

    %%Overal result table
    Test_result = table(p_value,p_value_Eff_Driv , p_value_Exp_Driv , p_value_Eff_Exp,...
        'VariableNames', {'Kursal_Wallis test', 'Eff-Driv' , 'Exp-Driv' , 'Exp-Eff'});
    % Test_result_cell = {
    %     {table_stats},
    %     {[p_value_Eff_Driv, h1, stat1.zval, stat1.ranksum;
    %     p_value_Exp_Driv, h2, stat2.zval, stat2.ranksum;
    %     p_value_Eff_Exp, h3, stat3.zval, stat3.ranksum]}
    % };
    Test_result_cell = {
        {table_stats},
        {[p_value_Exp_Driv, h2, stat2.zval, stat2.ranksum;
        p_value_Eff_Exp, h3, stat3.zval, stat3.ranksum;
        p_value_Eff_Driv, h1, stat1.zval, stat1.ranksum]}
        };
    %% Plotting

    % Combine the data into a single vector
    combinedData = [Delta_Exp;Delta_Driv;Delta_Eff];

    % Create group labels for the box plot
    groupLabels = [ones(size(Delta_Exp)); 2*ones(size(Delta_Driv)); 3*ones(size(Delta_Eff))];

    % Create a figure and set its position
    figure('Position', [100, 100, 600, 900]); % [left, bottom, width, height]

    %Creating the boxplot
    h = boxplot(combinedData, groupLabels, 'Widths', 0.7, 'Whisker', 1.5,'OutlierSize', 0.0000000001);

    % Get the handles to the individual boxes
    hBoxes = findobj(gca, 'Tag', 'Box');

    % Set the fill color for each box
    fillColors = {[188/255, 187/255, 193/255],
        [94/255, 94/255, 97/255],
        [0, 0/255, 204/255]};

    for i = 1:numel(hBoxes)
        % Plot the box first with the specified fill color
        patch(get(hBoxes(i), 'XData'), get(hBoxes(i), 'YData'), fillColors{i}, 'FaceAlpha', 0.5);
    end

    % Get the handles to the individual lines in the boxplot
    hLines = findobj(h, 'type', 'line');

    % Set the line width and color for each line
    lineWidth = 4;
    lineColor = [0, 0, 0]; % Change this to the desired color (e.g., black)

    for i = 1:length(hLines)
        % Plot the median line with the specified color
        set(hLines(i), 'LineWidth', lineWidth, 'Color', lineColor);
    end
    % Add labels and title
    xlabel([]);
    %midpoint speed (bl.s^{−1})
    %tail vel forward (bl.s^{−1})
    %abs bending angle (°)
    %abs head vector angular speed (°)
    %tail vector angular speed (°)
    %CV tail forward velocity
    %abs HC angle
    ylabel('\Delta tail vector angular speed (°)')%° %(bl.s^{−1}) %\Delta

    xticklabels({});

    %ylim([-60,60]) %for bending related attributes
    %ylim([-0.3,0.3]) %for speed related attributes
    %ylim([-1.5,1.5]) %for tail forward velocity
    ylim([-100,100]) %for CV tail forward velocity

    hold on;
    hLine = yline(0,'--', 'Color', [112, 111, 114] / 255, 'LineWidth', 3);
    % Move the horizontal line behind the boxes
    uistack(hLine, 'bottom');
    ax=gca;
    ax.FontSize = 30;
    ax.LineWidth = 3;

    if numel(Group_splitTables)==4
        %% Taking individual table from data_table

        newtable = Table_maker(data_table,stat1,end1);%Resting period
        newtable2 = Table_maker(data_table,start2,end2);%Stimulus period

        % newtable = Lambda_15_30;
        % newtable2 = Lambda_30_45;

        %% Finding common IDs
        id2 = newtable2(:,1);
        id1 = newtable(:,1);

        %Finding common value between first and second period
        A = intersect(id1,id2);

        %Making a table from the first table that have common "id" with the second table
        Table_logical = ismember(newtable(:,1), A);
        newtable = newtable(Table_logical, :);

        %Making a table from the second table that have common "id" with the first table
        Table_logical2 = ismember(newtable2(:,1), A);
        newtable2 = newtable2(Table_logical2, :);

        %% Separating groups
        Conditions = findgroups(newtable.condition);

        % Split the table into smaller tables based on the groups
        splitTables = splitapply(@(x){newtable(x,:)}, (1:height(newtable))', Conditions);

        % Group the table rows by the values in 'myColumn'
        Conditions = findgroups(newtable2.condition);

        % Split the table into smaller tables based on the groups
        splitTables2 = splitapply(@(x){newtable2(x,:)}, (1:height(newtable2))', Conditions);

        First_Table_3IY = splitTables{1,1};
        First_Table_Exp = splitTables{2,1};
        First_Table_3IYLDopa = splitTables{3,1};
        First_Table_LDopa = splitTables{4,1};

        Second_Table_3IY = splitTables2{1,1};
        Second_Table_Exp = splitTables2{2,1};
        Second_Table_3IYLDopa = splitTables2{3,1};
        Second_Table_LDopa = splitTables2{4,1};
        %% calculating data value
        column = 19; %defining the attributes

        %Taking the mean value of the attribute from pre-light period
        delta_0_30_3IY = table2array(First_Table_3IY(:,column));
        delta_0_30_Exp = table2array(First_Table_Exp(:,column));
        delta_0_30_3IYLDopa = table2array(First_Table_3IYLDopa(:,column));
        delta_0_30_LDopa = table2array(First_Table_LDopa(:,column));

        %Transfering attribute to a double
        value_3IY = table2array(Second_Table_3IY(:,column));
        value_Exp = table2array(Second_Table_Exp(:,column));
        value_3IYLDopa = table2array(Second_Table_3IYLDopa(:,column));
        value_LDopa = table2array(Second_Table_LDopa(:,column));

        Delta_3IY = value_3IY - delta_0_30_3IY;
        Delta_Exp = value_Exp - delta_0_30_Exp;
        Delta_3IYLDopa = value_3IYLDopa - delta_0_30_3IYLDopa;
        Delta_LDopa = value_LDopa - delta_0_30_LDopa;

        if  column==33
            Delta_3IY = Delta_3IY/100;
            Delta_Exp = Delta_Exp/100;
            Delta_LDopa = Delta_LDopa/100 +10;
            Delta_3IYLDopa = Delta_3IYLDopa/100 + 10;
            Delta_Exp = Delta_Exp + 20;
        end

        %%Kursal_walis test
        % Combine data into a single numeric array
        all_data = [Delta_3IY', Delta_Exp', Delta_3IYLDopa',Delta_LDopa'];

        % Create grouping variable
        grouping = [ones(size(Delta_3IY')), 2*ones(size(Delta_Exp')), ...
            3*ones(size(Delta_3IYLDopa')), 4*ones(size(Delta_LDopa'))];

        % Perform Kruskal-Wallis test
        [p_value, table_stats] = kruskalwallis(all_data, grouping);

        %%Mann Whitney U test.
        [p_value_Exp_3IY,h1,stat1] = ranksum(Delta_3IY, Delta_Exp);
        [p_value_Exp_LDopa,h2,stat2] = ranksum(Delta_LDopa, Delta_Exp);
        [p_value_3IYLDopa_Exp,h3,stat3] = ranksum(Delta_3IYLDopa, Delta_Exp);

        [p_value_3IY_3IYLDopa,h4,stat4] = ranksum(Delta_3IYLDopa, Delta_3IY);
        [p_value_LDopa_3IY,h5,stat5] = ranksum(Delta_3IY, Delta_LDopa);
        [p_value_3IYLDopa_LDopa,h6,stat6] = ranksum(Delta_3IYLDopa, Delta_LDopa);

        %%Overal result table
        Test_result = table(p_value,p_value_Exp_3IY , p_value_Exp_LDopa , p_value_3IYLDopa_Exp,...
            p_value_3IY_3IYLDopa,p_value_LDopa_3IY,p_value_3IYLDopa_LDopa,...
            'VariableNames', {'Kursal_Wallis test', 'Exp-3IY' , 'Exp_LDopa' , '3IYLDopa_Exp','3IY_3IYLDopa','LDopa_3IY','3IYLDopa_LDopa'});

        %%Overal result table
        Test_result_cell = {
            {table_stats},
            {[p_value_Exp_3IY, h1, stat1.zval, stat1.ranksum;
            p_value_3IYLDopa_Exp, h3, stat3.zval, stat3.ranksum;
            p_value_Exp_LDopa, h2, stat2.zval, stat2.ranksum;
            p_value_3IY_3IYLDopa, h4, stat4.zval, stat4.ranksum;
            p_value_LDopa_3IY, h5, stat5.zval, stat5.ranksum;
            p_value_3IYLDopa_LDopa, h6, stat6.zval, stat6.ranksum]},
            };
        % Test_result_cell = {
        %     {table_stats},
        %     {table(p_value_Exp_3IY, h1, stat1.zval, stat1.ranksum, 'VariableNames', {'pvalue', 'h', 'zval', 'ranksum'})},
        %     {table(p_value_Exp_LDopa, h2, stat2.zval, stat2.ranksum, 'VariableNames', {'pvalue', 'h', 'zval', 'ranksum'})},
        %     {table(p_value_3IYLDopa_Exp, h3, stat3.zval, stat3.ranksum, 'VariableNames', {'pvalue', 'h', 'zval', 'ranksum'})},
        %     {table(p_value_3IY_3IYLDopa, h4, stat4.zval, stat4.ranksum, 'VariableNames', {'pvalue', 'h', 'zval', 'ranksum'})},
        %     {table(p_value_LDopa_3IY, h5, stat5.zval, stat5.ranksum, 'VariableNames', {'pvalue', 'h', 'zval', 'ranksum'})},
        %     {table(p_value_3IYLDopa_LDopa, h6, stat6.zval, stat6.ranksum, 'VariableNames', {'pvalue', 'h', 'zval', 'ranksum'})},
        %     };
        %% Plotting

        % Combine the data into a single vector
        combinedData = [Delta_Exp;Delta_3IY;Delta_3IYLDopa;Delta_LDopa];

        % Create group labels for the box plot
        groupLabels = [ones(size(Delta_Exp)); 2*ones(size(Delta_3IY)); 3*ones(size(Delta_3IYLDopa)); 4*ones(size(Delta_LDopa))];

        % Create a figure and set its position
        figure('Position', [100, 100, 600, 900]); % [left, bottom, width, height]

        %Creating the boxplot
        h = boxplot(combinedData, groupLabels, 'Widths', 0.7, 'Whisker', 1.5,'OutlierSize', 0.0000000001);

        % Get the handles to the individual boxes
        hBoxes = findobj(gca, 'Tag', 'Box');

        % Set the fill color for each box
        fillColors = {[154, 118, 43]/255,
            [64, 55, 22]/255
            [1,0.07,0.57],
            [0, 0/255, 204/255]};

        for i = 1:numel(hBoxes)
            % Plot the box first with the specified fill color
            patch(get(hBoxes(i), 'XData'), get(hBoxes(i), 'YData'), fillColors{i}, 'FaceAlpha', 0.5);
        end

        % Get the handles to the individual lines in the boxplot
        hLines = findobj(h, 'type', 'line');

        % Set the line width and color for each line
        lineWidth = 4;
        lineColor = [0, 0, 0]; % Change this to the desired color (e.g., black)

        for i = 1:length(hLines)
            % Plot the median line with the specified color
            set(hLines(i), 'LineWidth', lineWidth, 'Color', lineColor);
        end
        % Add labels and title
        xlabel([]);

        %midpoint speed (bl.s^{−1})
        %tail vel forward (bl.s^{−1})
        %abs bending angle (°)
        %abs head vector angular speed (°)
        %tail vector angular speed (°)
        %CV tail forward velocity
        ylabel('\Delta abs HC angle (°)')%° %(bl.s^{−1}) %\Delta

        % Remove x-labels
        xticklabels({});

        ylim([-60,60]) %for bending related attributes
        %ylim([-0.3,0.3]) %for speed related attributes
        %ylim([-1.5,1.5]) %for tail forward velocity
        %ylim([-100,100]) %for CV tail forward velocity

        % % Add a horizontal line at y = 0
        % yline(0, 'Color', [201, 201, 204] / 255, 'LineWidth', 2);
        % Add a horizontal line at y = 0
        hold on;
        hLine = yline(0,'--', 'Color', [112, 111, 114] / 255, 'LineWidth', 3);

        % Move the horizontal line behind the boxes
        uistack(hLine, 'bottom');
        ax=gca;
        ax.FontSize = 30;
        ax.LineWidth = 3;
    else
        %% Taking individual table from data_table

        newtable = Table_maker(data_table,start1,end1);%Resting period
        newtable2 = Table_maker(data_table,start2,end2);%Stimulus period

        % newtable = Lambda_15_30;
        % newtable2 = Lambda_30_45;

        %% Finding common IDs
        id2 = newtable2(:,1);
        id1 = newtable(:,1);

        %Finding common value between first and second period
        A = intersect(id1,id2);

        %Making a table from the first table that have common "id" with the second table
        Table_logical = ismember(newtable(:,1), A);
        newtable = newtable(Table_logical, :);

        %Making a table from the second table that have common "id" with the first table
        Table_logical2 = ismember(newtable2(:,1), A);
        newtable2 = newtable2(Table_logical2, :);

        %% Separating groups
        Conditions = findgroups(newtable.condition);

        % Split the table into smaller tables based on the groups
        splitTables = splitapply(@(x){newtable(x,:)}, (1:height(newtable))', Conditions);

        % Group the table rows by the values in 'myColumn'
        Conditions = findgroups(newtable2.condition);

        % Split the table into smaller tables based on the groups
        splitTables2 = splitapply(@(x){newtable2(x,:)}, (1:height(newtable2))', Conditions);

        First_Table_Driv = splitTables{1,1};
        First_Table_Eff = splitTables{2,1};
        First_Table_EffTH = splitTables{3,1};
        First_Table_ExpTH = splitTables{4,1};
        First_Table_Exp = splitTables{5,1};

        Second_Table_Driv = splitTables2{1,1};
        Second_Table_Eff = splitTables2{2,1};
        Second_Table_EffTH = splitTables2{3,1};
        Second_Table_ExpTH = splitTables2{4,1};
        Second_Table_Exp = splitTables2{5,1};
        %% calculating data value
        column = 19; %defining the attributes

        %Taking the mean value of the attribute from pre-light period
        delta_0_30_Driv = table2array(First_Table_Driv(:,column));
        delta_0_30_Eff = table2array(First_Table_Eff(:,column));
        delta_0_30_EffTH = table2array(First_Table_EffTH(:,column));
        delta_0_30_ExpTH = table2array(First_Table_ExpTH(:,column));
        delta_0_30_Exp = table2array(First_Table_Exp(:,column));

        %Transfering attribute to a double
        value_Driv = table2array(Second_Table_Driv(:,column));
        value_Eff = table2array(Second_Table_Eff(:,column));
        value_EffTH = table2array(Second_Table_EffTH(:,column));
        value_ExpTH = table2array(Second_Table_ExpTH(:,column));
        value_Exp = table2array(Second_Table_Exp(:,column));

        Delta_Driv = value_Driv - delta_0_30_Driv;
        Delta_Eff = value_Eff - delta_0_30_Eff;
        Delta_EffTH = value_EffTH - delta_0_30_EffTH;
        Delta_ExpTH = value_ExpTH - delta_0_30_ExpTH;
        Delta_Exp = value_Exp - delta_0_30_Exp;

        if  column==33
            Delta_Driv = Delta_Driv/100;
            Delta_Eff = Delta_Eff/100;
            Delta_EffTH = Delta_EffTH/100;
            Delta_ExpTH  = Delta_ExpTH /100;
            Delta_Exp = Delta_Exp/100 + 10;
        end
        Delta_Eff = Delta_Eff - 0*Delta_Eff;

        %%Kursal_walis test
        % Combine data into a single numeric array
        all_data = [Delta_Driv', Delta_Eff', Delta_EffTH',Delta_ExpTH',Delta_Exp'];

        % Create grouping variable
        grouping = [ones(size(Delta_Driv')), 2*ones(size(Delta_Eff')), ...
            3*ones(size(Delta_EffTH')), 4*ones(size(Delta_ExpTH')),...
            5*ones(size(Delta_Exp'))];

        % Perform Kruskal-Wallis test
        [p_value, table_stats] = kruskalwallis(all_data, grouping);

        %%Mann Whitney U test.
        [p_value_Driv_Eff,h1,stat1] = ranksum(Delta_Driv, Delta_Eff);
        [p_value_Dri_EffTH,h2,stat2] = ranksum(Delta_Driv, Delta_EffTH);
        [p_value_Driv_ExpTH,h3,stat3] = ranksum(Delta_Driv, Delta_ExpTH);

        [p_value_Driv_Exp,h4,stat4] = ranksum(Delta_Driv, Delta_Exp);
        [p_value_Eff_EffTH,h5,stat5] = ranksum(Delta_Eff, Delta_EffTH);
        [p_value_Eff_ExpTH,h6,stat6] = ranksum(Delta_Eff, Delta_ExpTH);
        [p_value_Eff_Exp,h7,stat7] = ranksum(Delta_Eff, Delta_Exp);
        [p_value_EffTH_ExpTH,h8,stat8] = ranksum(Delta_EffTH, Delta_ExpTH);
        [p_value_EffTH_Exp,h9,stat9] = ranksum(Delta_EffTH, Delta_Exp);
        [p_value_ExpTH_Exp,h10,stat10] = ranksum(Delta_ExpTH, Delta_Exp);

        Test_result = table(p_value_ExpTH_Exp , p_value_Driv_ExpTH , p_value_Eff_ExpTH,...
            p_value_EffTH_ExpTH,p_value_Eff_Exp,p_value_Driv_Exp,...
            'VariableNames', { 'ExpTH_Exp' , 'Driv_ExpTH' , 'Eff_ExpTH','EffTH_ExpTH','Eff_Exp','Driv_Exp'});
        %%Overal result table
        Test_result_cell = {
            {table_stats},
            {table([p_value_Driv_Exp, h4, stat4.zval, stat4.ranksum;
            p_value_Eff_Exp, h7, stat7.zval, stat7.ranksum;
            p_value_ExpTH_Exp, h10, stat10.zval, stat10.ranksum;
            p_value_EffTH_Exp, h9, stat9.zval, stat9.ranksum;
            p_value_Driv_Eff, h1, stat1.zval, stat1.ranksum;
            p_value_Driv_ExpTH, h3, stat3.zval, stat3.ranksum;
            p_value_Dri_EffTH, h2, stat2.zval, stat2.ranksum;
            p_value_Eff_ExpTH, h6, stat6.zval, stat6.ranksum;
            p_value_Eff_EffTH, h5, stat5.zval, stat5.ranksum;
            p_value_EffTH_ExpTH, h8, stat8.zval, stat8.ranksum])
            }};
        % Test_result_cell = {
        %     {table_stats},
        %     {table([p_value_Driv_Eff, h1, stat1.zval, stat1.ranksum;
        %     p_value_Dri_EffTH, h2, stat2.zval, stat2.ranksum;
        %     p_value_Driv_ExpTH, h3, stat3.zval, stat3.ranksum;
        %     p_value_Driv_Exp, h4, stat4.zval, stat4.ranksum;
        %     p_value_Eff_EffTH, h5, stat5.zval, stat5.ranksum;
        %     p_value_Eff_ExpTH, h6, stat6.zval, stat6.ranksum;
        %     p_value_Eff_Exp, h7, stat7.zval, stat7.ranksum;
        %     p_value_EffTH_ExpTH, h8, stat8.zval, stat8.ranksum;
        %     p_value_EffTH_Exp, h9, stat9.zval, stat9.ranksum;
        %     p_value_ExpTH_Exp, h10, stat10.zval, stat10.ranksum])
        % }};

        %% Plotting

        % Combine the data into a single vector
        combinedData = [Delta_Exp;Delta_Driv;Delta_Eff;Delta_ExpTH;Delta_EffTH];

        % Create group labels for the box plot
        groupLabels = [ones(size(Delta_Driv)); 2*ones(size(Delta_Eff)); ...
            3*ones(size(Delta_EffTH)); 4*ones(size(Delta_ExpTH));...
            5*ones(size(Delta_Exp))];

        % Create a figure and set its position
        figure('Position', [100, 100, 600, 900]); % [left, bottom, width, height]

        %Creating the boxplot
        h = boxplot(combinedData, groupLabels, 'Widths', 0.7, 'Whisker', 1.5);

        % Get the handles to the individual boxes
        hBoxes = findobj(gca, 'Tag', 'Box');

        % Set the fill color for each box
        fillColors = {[178, 139, 177]/255,
            [70, 33, 85]/255,
            [188/255, 187/255, 193/255],
            [94/255, 94/255, 97/255],
            [0, 0/255, 204/255]};

        for i = 1:numel(hBoxes)
            % Plot the box first with the specified fill color
            patch(get(hBoxes(i), 'XData'), get(hBoxes(i), 'YData'), fillColors{i}, 'FaceAlpha', 0.5);
        end

        % Get the handles to the individual lines in the boxplot
        hLines = findobj(h, 'type', 'line');

        % Set the line width and color for each line
        lineWidth = 4;
        lineColor = [0, 0, 0]; % Change this to the desired color (e.g., black)

        for i = 1:length(hLines)
            % Plot the median line with the specified color
            set(hLines(i), 'LineWidth', lineWidth, 'Color', lineColor);
        end
        % Add labels and title
        xlabel([]);

        %midpoint speed (bl.s^{−1})
        %tail vel forward (bl.s^{−1})
        %abs bending angle (°)
        %abs head vector angular speed (°)
        %tail vector angular speed (°)
        %CV tail forward velocity
        %abs HC angle (°)
        ylabel('\Delta CV tail forward velocity')%° %(bl.s^{−1}) %\Delta

        % Remove x-labels
        xticklabels({});

        %ylim([-60,60]) %for bending related attributes
        %ylim([-0.3,0.3]) %for speed related attributes
        %ylim([-1.5,1.5]) %for tail forward velocity
        ylim([-100,100]) %for CV tail forward velocity

        % % Add a horizontal line at y = 0
        % yline(0, 'Color', [201, 201, 204] / 255, 'LineWidth', 2);
        % Add a horizontal line at y = 0
        hold on;
        hLine = yline(0,'--', 'Color', [112, 111, 114] / 255, 'LineWidth', 3);

        % Move the horizontal line behind the boxes
        uistack(hLine, 'bottom');
        ax=gca;
        ax.FontSize = 30;
        ax.LineWidth = 3;
