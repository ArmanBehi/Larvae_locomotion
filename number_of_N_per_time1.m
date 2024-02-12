function [] = number_of_N_per_time1(data_table)

Groups = findgroups(data_table.condition);

% Split the table into smaller tables based on the groups
Group_splitTables = splitapply(@(x){data_table(x,:)}, (1:height(data_table))', Groups);
if numel(Group_splitTables)==3
    %% Calculating number of n in each time of experiment and plot it

    ID_Group_E = IDwiseSplit(Group_splitTables{1,1});
    ID_Group_F = IDwiseSplit(Group_splitTables{2,1});
    ID_Group_X = IDwiseSplit(Group_splitTables{3,1});

    %%For Group E
    for i = 1:numel(ID_Group_E) %making a table that shows first and last frame of each ID
        Number_of_frame_E(i,1) = ID_Group_E{i,1}.frame(1);
        Number_of_frame_E(i,2) = ID_Group_E{i,1}.frame(end);
    end

    %max(Number_of_frame(:,2))
    caluculating_matrix = zeros(numel(ID_Group_E),4800);
    for i=1:numel(caluculating_matrix(:,1))
        caluculating_matrix(i,Number_of_frame_E(i,1):Number_of_frame_E(i,2)) = 1;
    end

    N_of_data_time_E = sum(caluculating_matrix,1);

    %%For Group F
    for i = 1:numel(ID_Group_F) %making a table that shows first and last frame of each ID
        Number_of_frame_F(i,1) = ID_Group_F{i,1}.frame(1);
        Number_of_frame_F(i,2) = ID_Group_F{i,1}.frame(end);
    end

    %max(Number_of_frame(:,2))
    caluculating_matrix = zeros(numel(ID_Group_F),4800);
    for i=1:numel(caluculating_matrix(:,1))
        caluculating_matrix(i,Number_of_frame_F(i,1):Number_of_frame_F(i,2)) = 1;
    end

    N_of_data_time_F = sum(caluculating_matrix,1);

    %%For Group X
    for i = 1:numel(ID_Group_X) %making a table that shows first and last frame of each ID
        Number_of_frame_X(i,1) = ID_Group_X{i,1}.frame(1);
        Number_of_frame_X(i,2) = ID_Group_X{i,1}.frame(end);
    end

    %max(Number_of_frame(:,2))
    caluculating_matrix = zeros(numel(ID_Group_X),4800);
    for i=1:numel(caluculating_matrix(:,1))
        caluculating_matrix(i,Number_of_frame_X(i,1):Number_of_frame_X(i,2)) = 1;
    end

    N_of_data_time_X = sum(caluculating_matrix,1);
    %%Plotting
    figure()
    subplot(2,1,1)
    plot(N_of_data_time_E,'r','LineWidth',3)
    title('Number of IDs per time','Group E')
    xlabel('Time(s)')
    ylabel('Number of IDs') %° %(mm.s^{−1}) %\Delta
    xticks([480,960,1440,1920,2400,2880,3360,3840,4320,4800])
    xticklabels({'30','60','90','120','150','180','210','240','270','300'})
    ax=gca;
    ax.FontSize = 20
    grid on;
    axis([0 4800 0 320])

    subplot(2,1,2)
    plot(N_of_data_time_F,'r','LineWidth',3)
    title('Group F')
    xlabel('Time(s)')
    ylabel('Number of IDs') %° %(mm.s^{−1}) %\Delta
    xticks([480,960,1440,1920,2400,2880,3360,3840,4320,4800])
    xticklabels({'30','60','90','120','150','180','210','240','270','300'})
    ax=gca;
    ax.FontSize = 20
    grid on;
    axis([0 4800 0 320])

    %% Calculating number of unique survival
    %%FOR group E
    z = 0;
    for i=1:numel(Number_of_frame_E(:,1))
        if Number_of_frame_E(i,1) ==1 %if the first frame of the ID is 1
            z = z+1;
            unique_survived_frame_E(z,:)=Number_of_frame_E(i,:);
        end
    end



    caluculating_matrix_2_E = zeros(numel(unique_survived_frame_E(:,1)),4800);
    for i=1:numel(caluculating_matrix_2_E(:,1))
        caluculating_matrix_2_E(i,unique_survived_frame_E(i,1):unique_survived_frame_E(i,2)) = 1;
    end

    N_of_data_time_2_E = sum(caluculating_matrix_2_E,1);

    %%FOR group F
    z = 0;
    for i=1:numel(Number_of_frame_F(:,1))
        if Number_of_frame_F(i,1) ==1 %if the first frame of the ID is 1
            z = z+1;
            unique_survived_frame_F(z,:)=Number_of_frame_F(i,:);
        end
    end



    caluculating_matrix_2_F = zeros(numel(unique_survived_frame_F(:,1)),4800);
    for i=1:numel(caluculating_matrix_2_F(:,1))
        caluculating_matrix_2_F(i,unique_survived_frame_F(i,1):unique_survived_frame_F(i,2)) = 1;
    end

    N_of_data_time_2_F = sum(caluculating_matrix_2_F,1);

    %%FOR group X
    z = 0;
    for i=1:numel(Number_of_frame_X(:,1))
        if Number_of_frame_X(i,1) ==1 %if the first frame of the ID is 1
            z = z+1;
            unique_survived_frame_X(z,:)=Number_of_frame_X(i,:);
        end
    end



    caluculating_matrix_2_X = zeros(numel(unique_survived_frame_X(:,1)),4800);
    for i=1:numel(caluculating_matrix_2_F(:,1))
        caluculating_matrix_2_X(i,unique_survived_frame_X(i,1):unique_survived_frame_X(i,2)) = 1;
    end

    N_of_data_time_2_X = sum(caluculating_matrix_2_X,1);

    %Plotting
    figure()
    subplot(2,1,1)
    plot(N_of_data_time_2_E,'m','LineWidth',3)
    title('Number of IDs tracked from the initiation of experiment','Group E')
    xlabel('Time(s)')
    ylabel('Number of IDs') %° %(mm.s^{−1}) %\Delta
    xticks([480,960,1440,1920,2400,2880,3360,3840,4320,4800])
    xticklabels({'30','60','90','120','150','180','210','240','270','300'})
    ax=gca;
    ax.FontSize = 20
    grid on;
    axis([0 4800 0 300])

    subplot(2,1,2)
    plot(N_of_data_time_2_F,'m','LineWidth',3)
    title('Group F')
    xlabel('Time(s)')
    ylabel('Number of IDs') %° %(mm.s^{−1}) %\Delta
    xticks([480,960,1440,1920,2400,2880,3360,3840,4320,4800])
    xticklabels({'30','60','90','120','150','180','210','240','270','300'})
    ax=gca;
    ax.FontSize = 20
    grid on;
    axis([0 4800 0 300])
else if numel(Group_splitTables)==4
        %% Calculating number of n in each time of experiment and plot it

        ID_Group_G = IDwiseSplit(Group_splitTables{1,1});
        ID_Group_H = IDwiseSplit(Group_splitTables{2,1});
        ID_Group_I = IDwiseSplit(Group_splitTables{3,1});
        ID_Group_J = IDwiseSplit(Group_splitTables{4,1});

        %% For Group G
        for i = 1:numel(ID_Group_G) %making a table that shows first and last frame of each ID
            Number_of_frame_G(i,1) = ID_Group_G{i,1}.frame(1);
            Number_of_frame_G(i,2) = ID_Group_G{i,1}.frame(end);
        end

        %max(Number_of_frame(:,2))
        caluculating_matrix = zeros(numel(ID_Group_G),4800);
        for i=1:numel(caluculating_matrix(:,1))
            caluculating_matrix(i,Number_of_frame_G(i,1):Number_of_frame_G(i,2)) = 1;
        end

        N_of_data_time_G = sum(caluculating_matrix,1);


        %% For Group F
        for i = 1:numel(ID_Group_H) %making a table that shows first and last frame of each ID
            Number_of_frame_H(i,1) = ID_Group_H{i,1}.frame(1);
            Number_of_frame_H(i,2) = ID_Group_H{i,1}.frame(end);
        end

        %max(Number_of_frame(:,2))
        caluculating_matrix = zeros(numel(ID_Group_H),4800);
        for i=1:numel(caluculating_matrix(:,1))
            caluculating_matrix(i,Number_of_frame_H(i,1):Number_of_frame_H(i,2)) = 1;
        end

        N_of_data_time_H = sum(caluculating_matrix,1);

        %% For Group I
        for i = 1:numel(ID_Group_I) %making a table that shows first and last frame of each ID
            Number_of_frame_I(i,1) = ID_Group_I{i,1}.frame(1);
            Number_of_frame_I(i,2) = ID_Group_I{i,1}.frame(end);
        end

        %max(Number_of_frame(:,2))
        caluculating_matrix = zeros(numel(ID_Group_I),4800);
        for i=1:numel(caluculating_matrix(:,1))
            caluculating_matrix(i,Number_of_frame_I(i,1):Number_of_frame_I(i,2)) = 1;
        end

        N_of_data_time_I = sum(caluculating_matrix,1);

        %% For Group J
        for i = 1:numel(ID_Group_J) %making a table that shows first and last frame of each ID
            Number_of_frame_J(i,1) = ID_Group_J{i,1}.frame(1);
            Number_of_frame_J(i,2) = ID_Group_J{i,1}.frame(end);
        end

        %max(Number_of_frame(:,2))
        caluculating_matrix = zeros(numel(ID_Group_J),4800);
        for i=1:numel(caluculating_matrix(:,1))
            caluculating_matrix(i,Number_of_frame_J(i,1):Number_of_frame_J(i,2)) = 1;
        end

        N_of_data_time_J = sum(caluculating_matrix,1);

        %% Plotting
        figure(1)
        subplot(4,1,1)
        plot(N_of_data_time_G,'color',Eff_color,'LineWidth',3)
        title('Number of IDs per time','Eff')
        xlabel('Time(s)')
        ylabel('Number of IDs') %° %(mm.s^{−1}) %\Delta
        xticks([480,960,1920,2400,3360,3840,4800])
        xticklabels({'0','30','60','120','150','210','240','300'})
        ax=gca;
        ax.FontSize = 20
        grid on;
        axis([0 4800 0 400])

        subplot(4,1,2)
        plot(N_of_data_time_H,'color',EX_color,'LineWidth',3)
        title('Exp')
        xlabel('Time(s)')
        ylabel('Number of IDs') %° %(mm.s^{−1}) %\Delta
        xticks([480,960,1920,2400,3360,3840,4800])
        xticklabels({'0','30','60','120','150','210','240','300'})
        ax=gca;
        ax.FontSize = 20
        grid on;
        axis([0 4800 0 400])

        subplot(4,1,3)
        plot(N_of_data_time_I,'color',IY_color,'LineWidth',3)
        title('Exp  + 3IY')
        xlabel('Time(s)')
        ylabel('Number of IDs') %° %(mm.s^{−1}) %\Delta
        xticks([480,960,1920,2400,3360,3840,4800])
        xticklabels({'0','30','60','120','150','210','240','300'})
        ax=gca;
        ax.FontSize = 20
        grid on;
        axis([0 4800 0 400])

        subplot(4,1,4)
        plot(N_of_data_time_J,'color',Driv_color,'LineWidth',3)
        title('Driv')
        xlabel('Time(s)')
        ylabel('Number of IDs') %° %(mm.s^{−1}) %\Delta
        xticks([480,960,1920,2400,3360,3840,4800])
        xticklabels({'0','30','60','120','150','210','240','300'})
        ax=gca;
        ax.FontSize = 20
        grid on;
        axis([0 4800 0 400])
        %% Calculating number of unique survival
        %% FOR group G
        z = 0;
        for i=1:numel(Number_of_frame_G(:,1))
            if Number_of_frame_G(i,1) ==1 %if the first frame of the ID is 1
                z = z+1;
                unique_survived_frame_G(z,:)=Number_of_frame_G(i,:);
            end
        end



        caluculating_matrix_2_G = zeros(numel(unique_survived_frame_G(:,1)),4800);
        for i=1:numel(caluculating_matrix_2_G(:,1))
            caluculating_matrix_2_G(i,unique_survived_frame_G(i,1):unique_survived_frame_G(i,2)) = 1;
        end

        N_of_data_time_2_G = sum(caluculating_matrix_2_G,1);

        %% FOR group H
        z = 0;
        for i=1:numel(Number_of_frame_H(:,1))
            if Number_of_frame_H(i,1) ==1 %if the first frame of the ID is 1
                z = z+1;
                unique_survived_frame_H(z,:)=Number_of_frame_H(i,:);
            end
        end



        caluculating_matrix_2_H = zeros(numel(unique_survived_frame_H(:,1)),4800);
        for i=1:numel(caluculating_matrix_2_H(:,1))
            caluculating_matrix_2_H(i,unique_survived_frame_H(i,1):unique_survived_frame_H(i,2)) = 1;
        end

        N_of_data_time_2_H = sum(caluculating_matrix_2_H,1);

        %% FOR group I
        z = 0;
        for i=1:numel(Number_of_frame_I(:,1))
            if Number_of_frame_I(i,1) ==1 %if the first frame of the ID is 1
                z = z+1;
                unique_survived_frame_I(z,:)=Number_of_frame_I(i,:);
            end
        end



        caluculating_matrix_2_I = zeros(numel(unique_survived_frame_I(:,1)),4800);
        for i=1:numel(caluculating_matrix_2_I(:,1))
            caluculating_matrix_2_I(i,unique_survived_frame_I(i,1):unique_survived_frame_I(i,2)) = 1;
        end

        N_of_data_time_2_I = sum(caluculating_matrix_2_I,1);

        %% FOR group J
        z = 0;
        for i=1:numel(Number_of_frame_J(:,1))
            if Number_of_frame_J(i,1) ==1 %if the first frame of the ID is 1
                z = z+1;
                unique_survived_frame_J(z,:)=Number_of_frame_J(i,:);
            end
        end



        caluculating_matrix_2_J = zeros(numel(unique_survived_frame_J(:,1)),4800);
        for i=1:numel(caluculating_matrix_2_J(:,1))
            caluculating_matrix_2_J(i,unique_survived_frame_J(i,1):unique_survived_frame_J(i,2)) = 1;
        end

        N_of_data_time_2_J = sum(caluculating_matrix_2_J,1);


        %% Plotting
        figure(2)
        subplot(4,1,1)
        plot(N_of_data_time_2_G,'color',Eff_color,'LineWidth',3)
        title('Number of IDs tracked from the initiation of experiment','Eff')
        xlabel('Time(s)')
        ylabel('Number of IDs') %° %(mm.s^{−1}) %\Delta
        xticks([480,960,1920,2400,3360,3840,4800])
        xticklabels({'0','30','60','120','150','210','240','300'})
        ax=gca;
        ax.FontSize = 20
        grid on;
        axis([0 4800 0 400])

        subplot(4,1,2)
        plot(N_of_data_time_2_H,'color',EX_color,'LineWidth',3)
        title('Exp')
        xlabel('Time(s)')
        ylabel('Number of IDs') %° %(mm.s^{−1}) %\Delta
        xticks([480,960,1920,2400,3360,3840,4800])
        xticklabels({'0','30','60','120','150','210','240','300'})
        ax=gca;
        ax.FontSize = 20
        grid on;
        axis([0 4800 0 400])

        subplot(4,1,3)
        plot(N_of_data_time_2_I,'color',IY_color,'LineWidth',3)
        title('Exp + 3IY')
        xlabel('Time(s)')
        ylabel('Number of IDs') %° %(mm.s^{−1}) %\Delta
        xticks([480,960,1920,2400,3360,3840,4800])
        xticklabels({'0','30','60','120','150','210','240','300'})
        ax=gca;
        ax.FontSize = 20
        grid on;
        axis([0 4800 0 400])

        subplot(4,1,4)
        plot(N_of_data_time_2_J,'color',Driv_color,'LineWidth',3)
        title('Driv')
        xlabel('Time(s)')
        ylabel('Number of IDs') %° %(mm.s^{−1}) %\Delta
        xticks([480,960,1920,2400,3360,3840,4800])
        xticklabels({'0','30','60','120','150','210','240','300'})
        ax=gca;
        ax.FontSize = 20
        grid on;
        axis([0 4800 0 400])
else
    %Color code
    IY_color = [1,0.07,0.57];
    EX_color = 'b';
    Eff_color = [183/255, 201/255, 226/255];
    Driv_color = [77/255,107/255,83/255];
    LDopa_color = [195/255, 179/255, 142/255];
    LDopa_3IY =[248/255, 222/255, 156/255];
    %LDopa_3IY =[248/255, 160/255, 155/255];
    THRNi_exp = [184/255, 101/255, 220/255];
    THRNi_eff = [236/255, 213/255, 246/255];

    %% Calculating number of n in each time of experiment and plot it

    ID_Group_G = IDwiseSplit(Group_splitTables{1,1});
    ID_Group_H = IDwiseSplit(Group_splitTables{2,1});
    ID_Group_I = IDwiseSplit(Group_splitTables{3,1});
    ID_Group_J = IDwiseSplit(Group_splitTables{4,1});
    ID_Group_K = IDwiseSplit(Group_splitTables{5,1});
    %% For Group G
    for i = 1:numel(ID_Group_G) %making a table that shows first and last frame of each ID
        Number_of_frame_G(i,1) = ID_Group_G{i,1}.frame(1);
        Number_of_frame_G(i,2) = ID_Group_G{i,1}.frame(end);
    end

    %max(Number_of_frame(:,2))
    caluculating_matrix = zeros(numel(ID_Group_G),4800);
    for i=1:numel(caluculating_matrix(:,1))
        caluculating_matrix(i,Number_of_frame_G(i,1):Number_of_frame_G(i,2)) = 1;
    end

    N_of_data_time_G = sum(caluculating_matrix,1);


    %% For Group F
    for i = 1:numel(ID_Group_H) %making a table that shows first and last frame of each ID
        Number_of_frame_H(i,1) = ID_Group_H{i,1}.frame(1);
        Number_of_frame_H(i,2) = ID_Group_H{i,1}.frame(end);
    end

    %max(Number_of_frame(:,2))
    caluculating_matrix = zeros(numel(ID_Group_H),4800);
    for i=1:numel(caluculating_matrix(:,1))
        caluculating_matrix(i,Number_of_frame_H(i,1):Number_of_frame_H(i,2)) = 1;
    end

    N_of_data_time_H = sum(caluculating_matrix,1);

    %% For Group I
    for i = 1:numel(ID_Group_I) %making a table that shows first and last frame of each ID
        Number_of_frame_I(i,1) = ID_Group_I{i,1}.frame(1);
        Number_of_frame_I(i,2) = ID_Group_I{i,1}.frame(end);
    end

    %max(Number_of_frame(:,2))
    caluculating_matrix = zeros(numel(ID_Group_I),4800);
    for i=1:numel(caluculating_matrix(:,1))
        caluculating_matrix(i,Number_of_frame_I(i,1):Number_of_frame_I(i,2)) = 1;
    end

    N_of_data_time_I = sum(caluculating_matrix,1);

    %% For Group J
    for i = 1:numel(ID_Group_J) %making a table that shows first and last frame of each ID
        Number_of_frame_J(i,1) = ID_Group_J{i,1}.frame(1);
        Number_of_frame_J(i,2) = ID_Group_J{i,1}.frame(end);
    end

    %max(Number_of_frame(:,2))
    caluculating_matrix = zeros(numel(ID_Group_J),4800);
    for i=1:numel(caluculating_matrix(:,1))
        caluculating_matrix(i,Number_of_frame_J(i,1):Number_of_frame_J(i,2)) = 1;
    end

    N_of_data_time_J = sum(caluculating_matrix,1);

    %% For Group K
    for i = 1:numel(ID_Group_K) %making a table that shows first and last frame of each ID
        Number_of_frame_K(i,1) = ID_Group_K{i,1}.frame(1);
        Number_of_frame_K(i,2) = ID_Group_K{i,1}.frame(end);
    end

    %max(Number_of_frame(:,2))
    caluculating_matrix = zeros(numel(ID_Group_K),4800);
    for i=1:numel(caluculating_matrix(:,1))
        caluculating_matrix(i,Number_of_frame_K(i,1):Number_of_frame_K(i,2)) = 1;
    end

    N_of_data_time_K = sum(caluculating_matrix,1);


    %% Plotting
    figure(1)
    subplot(5,1,1)
    plot(N_of_data_time_G,'color',Driv_color,'LineWidth',3)
    title('Number of IDs per time','Driv')
    xlabel('Time(s)')
    ylabel('Number of IDs') %° %(mm.s^{−1}) %\Delta
    xticks([480,960,1920,2400,3360,3840,4800])
    xticklabels({'0','30','60','120','150','210','240','300'})
    ax=gca;
    ax.FontSize = 20
    grid on;
    axis([0 4800 0 400])

    subplot(5,1,2)
    plot(N_of_data_time_H,'color',Eff_color,'LineWidth',3)
    title('Eff')
    xlabel('Time(s)')
    ylabel('Number of IDs') %° %(mm.s^{−1}) %\Delta
    xticks([480,960,1920,2400,3360,3840,4800])
    xticklabels({'0','30','60','120','150','210','240','300'})
    ax=gca;
    ax.FontSize = 20
    grid on;
    axis([0 4800 0 400])

    subplot(5,1,3)
    plot(N_of_data_time_I,'color',THRNi_eff,'LineWidth',3)
    title('Eff TH-RNAi')
    xlabel('Time(s)')
    ylabel('Number of IDs') %° %(mm.s^{−1}) %\Delta
    xticks([480,960,1920,2400,3360,3840,4800])
    xticklabels({'0','30','60','120','150','210','240','300'})
    ax=gca;
    ax.FontSize = 20
    grid on;
    axis([0 4800 0 400])

    subplot(5,1,4)
    plot(N_of_data_time_J,'color',THRNi_exp,'LineWidth',3)
    title('Exp TH-RNAi')
    xlabel('Time(s)')
    ylabel('Number of IDs') %° %(mm.s^{−1}) %\Delta
    xticks([480,960,1920,2400,3360,3840,4800])
    xticklabels({'0','30','60','120','150','210','240','300'})
    ax=gca;
    ax.FontSize = 20
    grid on;
    axis([0 4800 0 400])

    subplot(5,1,5)
    plot(N_of_data_time_K,'color',EX_color,'LineWidth',3)
    title('Exp')
    xlabel('Time(s)')
    ylabel('Number of IDs') %° %(mm.s^{−1}) %\Delta
    xticks([480,960,1920,2400,3360,3840,4800])
    xticklabels({'0','30','60','120','150','210','240','300'})
    ax=gca;
    ax.FontSize = 20
    grid on;
    axis([0 4800 0 400])
    %% Calculating number of unique survival
    %% FOR group G
    z = 0;
    for i=1:numel(Number_of_frame_G(:,1))
        if Number_of_frame_G(i,1) ==1 %if the first frame of the ID is 1
            z = z+1;
            unique_survived_frame_G(z,:)=Number_of_frame_G(i,:);
        end
    end



    caluculating_matrix_2_G = zeros(numel(unique_survived_frame_G(:,1)),4800);
    for i=1:numel(caluculating_matrix_2_G(:,1))
        caluculating_matrix_2_G(i,unique_survived_frame_G(i,1):unique_survived_frame_G(i,2)) = 1;
    end

    N_of_data_time_2_G = sum(caluculating_matrix_2_G,1);

    %% FOR group H
    z = 0;
    for i=1:numel(Number_of_frame_H(:,1))
        if Number_of_frame_H(i,1) ==1 %if the first frame of the ID is 1
            z = z+1;
            unique_survived_frame_H(z,:)=Number_of_frame_H(i,:);
        end
    end



    caluculating_matrix_2_H = zeros(numel(unique_survived_frame_H(:,1)),4800);
    for i=1:numel(caluculating_matrix_2_H(:,1))
        caluculating_matrix_2_H(i,unique_survived_frame_H(i,1):unique_survived_frame_H(i,2)) = 1;
    end

    N_of_data_time_2_H = sum(caluculating_matrix_2_H,1);

    %% FOR group I
    z = 0;
    for i=1:numel(Number_of_frame_I(:,1))
        if Number_of_frame_I(i,1) ==1 %if the first frame of the ID is 1
            z = z+1;
            unique_survived_frame_I(z,:)=Number_of_frame_I(i,:);
        end
    end



    caluculating_matrix_2_I = zeros(numel(unique_survived_frame_I(:,1)),4800);
    for i=1:numel(caluculating_matrix_2_I(:,1))
        caluculating_matrix_2_I(i,unique_survived_frame_I(i,1):unique_survived_frame_I(i,2)) = 1;
    end

    N_of_data_time_2_I = sum(caluculating_matrix_2_I,1);

    %% FOR group J
    z = 0;
    for i=1:numel(Number_of_frame_J(:,1))
        if Number_of_frame_J(i,1) ==1 %if the first frame of the ID is 1
            z = z+1;
            unique_survived_frame_J(z,:)=Number_of_frame_J(i,:);
        end
    end



    caluculating_matrix_2_J = zeros(numel(unique_survived_frame_J(:,1)),4800);
    for i=1:numel(caluculating_matrix_2_J(:,1))
        caluculating_matrix_2_J(i,unique_survived_frame_J(i,1):unique_survived_frame_J(i,2)) = 1;
    end

    N_of_data_time_2_J = sum(caluculating_matrix_2_J,1);

    %% FOR group K
    z = 0;
    for i=1:numel(Number_of_frame_K(:,1))
        if Number_of_frame_K(i,1) ==1 %if the first frame of the ID is 1
            z = z+1;
            unique_survived_frame_K(z,:)=Number_of_frame_K(i,:);
        end
    end



    caluculating_matrix_2_K = zeros(numel(unique_survived_frame_K(:,1)),4800);
    for i=1:numel(caluculating_matrix_2_K(:,1))
        caluculating_matrix_2_K(i,unique_survived_frame_K(i,1):unique_survived_frame_K(i,2)) = 1;
    end

    N_of_data_time_2_K = sum(caluculating_matrix_2_K,1);

    %% Plotting
    figure(2)
    subplot(5,1,1)
    plot(N_of_data_time_2_G,'color',Driv_color,'LineWidth',3)
    title('Number of IDs tracked from the initiation of experiment','Driv')
    xlabel('Time(s)')
    ylabel('Number of IDs') %° %(mm.s^{−1}) %\Delta
    xticks([480,960,1920,2400,3360,3840,4800])
    xticklabels({'0','30','60','120','150','210','240','300'})
    ax=gca;
    ax.FontSize = 20
    grid on;
    axis([0 4800 0 400])

    subplot(5,1,2)
    plot(N_of_data_time_2_H,'color',Eff_color,'LineWidth',3)
    title('Eff')
    xlabel('Time(s)')
    ylabel('Number of IDs') %° %(mm.s^{−1}) %\Delta
    xticks([480,960,1920,2400,3360,3840,4800])
    xticklabels({'0','30','60','120','150','210','240','300'})
    ax=gca;
    ax.FontSize = 20
    grid on;
    axis([0 4800 0 400])

    subplot(5,1,3)
    plot(N_of_data_time_2_I,'color',THRNi_eff,'LineWidth',3)
    title('Eff TH-RNAi')
    xlabel('Time(s)')
    ylabel('Number of IDs') %° %(mm.s^{−1}) %\Delta
    xticks([480,960,1920,2400,3360,3840,4800])
    xticklabels({'0','30','60','120','150','210','240','300'})
    ax=gca;
    ax.FontSize = 20
    grid on;
    axis([0 4800 0 400])

    subplot(5,1,4)
    plot(N_of_data_time_2_J,'color',THRNi_exp,'LineWidth',3)
    title('Exp TH-RNAi')
    xlabel('Time(s)')
    ylabel('Number of IDs') %° %(mm.s^{−1}) %\Delta
    xticks([480,960,1920,2400,3360,3840,4800])
    xticklabels({'0','30','60','120','150','210','240','300'})
    ax=gca;
    ax.FontSize = 20
    grid on;
    axis([0 4800 0 400])

    subplot(5,1,5)
    plot(N_of_data_time_2_J,'color',EX_color,'LineWidth',3)
    title('Exp')
    xlabel('Time(s)')
    ylabel('Number of IDs') %° %(mm.s^{−1}) %\Delta
    xticks([480,960,1920,2400,3360,3840,4800])
    xticklabels({'0','30','60','120','150','210','240','300'})
    ax=gca;
    ax.FontSize = 20
    grid on;
    axis([0 4800 0 400])