function [Activities, Patterns, eigenvalues, lambda_max]=Reach_task_cellassemblyM1Str(TimeStamps,trial_marker,Fs_lfp,bin,units1,units2,percblock,len_bef,len_aft,markertype)

predur=len_bef;
postdur = len_aft;
trl_len=round(predur+postdur); % in units of seconds (i.e. 0.5 for 500 mseconds).
trl_num = length(trial_marker) - round(length(trial_marker)*percblock); %perblock is what percentage of trials will be used to create task_assembly - all, last half, last third, etc.
count_all=0;
count_end=0;
bin2 = [len_bef*-1:bin:len_aft]/Fs_lfp';
units_cnt = 0;

for a = 1: length(units1)
    for i = 1:length(units1(a).un)
        clear dn_pre ts* trl_datatmp
        unit=units1(a).un(i);
        ts_bin=zeros(length(trial_marker),length(bin2));
        ts1=TimeStamps{unit,a+1};
        ts1 = ts1';
        dN_cell_all=[];
        dN_cell_end=[];
        for j =1:length(trial_marker)
            if ~isnan(trial_marker(j))
                t=[trial_marker(j)-len_bef, trial_marker(j)+len_aft]/Fs_lfp;
                tstmp = ts1(ts1>t(1) & ts1<t(2));
                bin1 = [t(1):bin/Fs_lfp:t(2)];
                ts_bin = histc(tstmp,bin1);
                dN_cell_all = [dN_cell_all  ts_bin];
                if j>= trl_num
                    dN_cell_end = [dN_cell_end  ts_bin];
                end
            end
        end
        count_all=count_all+1;
        if ~isempty(dN_cell_all)
            Task_bin_all(count_all,:) = dN_cell_all;
%         else
%             Task_bin_all(count_all,:)=zeros(1,length(Task_bin_all));
         end
        
        if ~isempty(dN_cell_end)
            Task_bin_end(count_all,:) = dN_cell_end;
%         else
%             Task_bin_end(count_all,:)=zeros(1,length(Task_bin_end));
        end
    end
end

for a = 1: length(units2)
    for i = 1:length(units2(a).un)
        clear dn_pre ts* trl_datatmp
        unit=units2(a).un(i);
        ts_bin=zeros(length(trial_marker),length(bin2));
        ts1=TimeStamps{unit,a+1};
        ts1 = ts1';
        dN_cell_all=[];
        dN_cell_end=[];
        for j =1:length(trial_marker)
            if ~isnan(trial_marker(j))
                t=[trial_marker(j)-len_bef, trial_marker(j)+len_aft]/Fs_lfp;
                tstmp = ts1(ts1>t(1) & ts1<t(2));
                bin1 = [t(1):bin/Fs_lfp:t(2)];
                ts_bin = histc(tstmp,bin1);
                dN_cell_all = [dN_cell_all  ts_bin];
                if j>= trl_num
                    dN_cell_end = [dN_cell_end  ts_bin];
                end
            end
        end
        count_all=count_all+1;
        if ~isempty(dN_cell_all)
            Task_bin_all(count_all,:) = dN_cell_all;
        else
            Task_bin_all(count_all,:)=zeros(1,length(Task_bin_all));
        end
        
        if ~isempty(dN_cell_end)
            Task_bin_end(count_all,:) = dN_cell_end;
        else
            Task_bin_end(count_all,:)=zeros(1,length(Task_bin_end));
        end
    end
end


correlationmat = corr(Task_bin_end');
figure(1), clf
imagesc(correlationmat); colorbar;
title('Correlation Matrix of Single Units During Last Third of Forelimb Reach Task')
tit = strcat('Corr_mat_Bin',num2str(bin),markertype);
saveas (gcf, tit,'tiff');
%pause;
close all;

opts.threshold.method = 'MarcenkoPastur';
opts.Patterns.method = 'PCA';
opts.Patterns.number_of_iterations = 1000;
[Patterns, eigenvalues, lambda_max] = assembly_patterns(Task_bin_end,opts);

if size(Patterns,2)>0
    Activities = assembly_activity(Patterns,Task_bin_all);
    figure(1), clf
    subplot(211)
    imagesc(Task_bin_all)
    subplot(212)
    plot(Activities')
    tit = strcat('PCATask_Activation_Bin',num2str(bin),markertype); title(tit);
    saveas(gcf,tit,'tiff');
    for i =1:size(Patterns,2)
        stem(Patterns(:,i));title ('Task Ensemble'); tit = strcat('PCATask_Ensemble_Bin', num2str(bin),markertype); saveas(gcf,tit,'tiff');
    end
else
    Activities='NaN';
end
close all;
