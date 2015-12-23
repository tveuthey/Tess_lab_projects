function [Activities, Patterns, eigenvalues, lambda_max]=Reach_task_cellassemblyb_TV(TimeStamps,trial_marker,Fs_lfp,bin,units,percblock,len_bef,len_aft,markertype)

predur=len_bef; %length of the block before (pellet drop)
postdur = len_aft; %length of the block after
trl_len=round(predur+postdur); % in units of seconds (i.e. 0.5 for 500 mseconds).
trl_num = length(trial_marker) - round(length(trial_marker)*percblock); %perblock is what percentage of trials will be used to create task_assembly - all, last half, last third, etc.
count_all=0;
count_end=0;
bin2 = [len_bef*-1:bin:len_aft]/Fs_lfp';
units_cnt = 0;

for a = 1: length(units) %a is the number of sort codes with data
    for i = 1:length(units(a).un) %i is the number of channels with data
        clear dn_pre ts* trl_datatmp
        unit=units(a).un(i); %this is the total number of units (for all channels and all sort codes with data)
        ts_bin=zeros(length(trial_marker),length(bin2));
        ts1=TimeStamps{unit,a+1};
        dN_cell_all=[]; %100 percent of the data (whole trial, since before rats would do 200 trials)
        dN_cell_end=[]; %just the later portion (here 100%) of the data (because Dhak used to analyse all data or just last portion of the recording)
        for j =1:length(trial_marker)
             if ~isnan(trial_marker(j))
                t=[trial_marker(j)-len_bef, trial_marker(j)+len_aft]/Fs_lfp;
%              else
%                 t = [(trial_start(j)+1017 -len_bef),(trial_start(j)+1017+len_aft)]/Fs_lfp;
%              end
            tstmp = ts1(ts1>t(1) & ts1<t(2)); %hold data for the window of time (500 before and after) in which we are looking at the data?
            bin1 = [t(1):bin/Fs_lfp:t(2)];
            ts_bin = histc(tstmp,bin1);   %histc is the way to bin the data         
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

        %end
    end
end

% above have created a matrix with information from units concatenated
% together over time?

    correlationmat = corr(Task_bin_end');
    figure(1), clf
    imagesc(correlationmat); colorbar;
    title('Correlation Matrix of Single Units During Last Third of Forelimb Reach Task')
    tit = strcat('Corr_mat_Bin',num2str(bin),markertype);
    saveas (gcf, tit,'tiff');
    %pause;
    close all;
  keyboard
  
    
    opts.threshold.method = 'MarcenkoPastur'; %for a matrix of this size, what is the max variance that can be explained by a random set of units (=lower limit of variance explained by random units)
    opts.Patterns.method = 'PCA'; %no real reason why we use PCA instead of ICA
    opts.Patterns.number_of_iterations = 1000;
    [Patterns, eigenvalues, lambda_max] = assembly_patterns(Task_bin_end,opts); %patters: neuron weights for each ensemble; eigenvalues: how much variance can be explained by this emsemble out of total variance; lambda_max: max variance explained by random set of neurons 
      
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
    