function [Activities]=Reach_task_cellassembly_comp(Patterns,TimeStamps,trial_marker,Fs_lfp,bin,units,len_bef,len_aft,markertype)

predur=len_bef;
postdur = len_aft;
count_all=0;
count_end=0;
bin2 = [len_bef*-1:bin:len_aft]/Fs_lfp';
units_cnt = 0;

for a = 1: length(units)
    for i = 1:length(units(a).un)
        clear dn_pre ts* trl_datatmp
        unit=units(a).un(i);
        ts_bin=zeros(length(trial_marker),length(bin2));
        ts1=TimeStamps{unit,a+1};
        dN_cell_all=[];
        dN_cell_end=[];
        for j =1:length(trial_marker)
             if ~isnan(trial_marker(j))
            t=[trial_marker(j)-len_bef, trial_marker(j)+len_aft]/Fs_lfp;
            tstmp = ts1(ts1>t(1) & ts1<t(2));
            bin1 = [t(1):bin/Fs_lfp:t(2)];
            ts_bin = histc(tstmp,bin1);            
            dN_cell_all = [dN_cell_all  ts_bin];
            end
        end
        count_all=count_all+1        
        if ~isempty(dN_cell_all)
            Task_bin_all(count_all,:) = dN_cell_all;
        else
            Task_bin_all(count_all,:)=zeros(1,length(Task_bin_all));  
        end
    end
end
    opts.threshold.method = 'MarcenkoPastur';
    opts.Patterns.method = 'PCA';
    opts.Patterns.number_of_iterations = 1000;
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
