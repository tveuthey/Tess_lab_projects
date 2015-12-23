function [Activities Patterns]=taskblock_spk_spk_coherence(TimeStamps,start,Fs_lfp,bin, units, units2)

close all; 
trl_len=round(Fs_lfp*4);
trl_num = round(length(start)/3);
inctrls = [round(trl_num/3)*2:trl_num];
trls=zeros(length(inctrls),trl_len);
% count = 1;
% for i = inctrls
% trls(count,:) = round(start(i):pelletdrop1(i)+trl_len);
% end
count_all=0;
count_end=0;
for i = 1:(length(units)+length(units2))
    clear dn_pre ts* trl_datatmp
    if i <= length(units)
        unit=units(i);
        ts1tmp1=TimeStamps{unit,2}*Fs_lfp;
    else
        unit=units2(i-length(units));
        ts1tmp1=TimeStamps{unit,3}*Fs_lfp;
    end
        dN_cell_all=[];
        dN_cell_end=[];
    for j =1:length(start) 
        tstmp1 = ts1tmp1(ts1tmp1>start(j) & ts1tmp1<start(j)+trl_len);
        tstmp1=(tstmp1-(start(j)))/Fs_lfp;
        %tsall=[tsall tstmp1];
        [dN_tmp,~]=binspikes(tstmp1,1017,[0 (trl_len/1017)]);
        dN_cell_all = [dN_cell_all; dN_tmp];
        if j>= trl_num*2
        dN_cell_end = [dN_cell_end; dN_tmp];
        end
    end
    ts1 = find(dN_cell_all)';
    ts2 = find(dN_cell_end)';
    %if ~isempty(ts1)
        edge = 1:bin:length(dN_cell_all);
        count_all=count_all+1;
        Task_bin_all(count_all,:) = histc(ts1, edge);
    %end
    
    %if ~isempty(ts2)
        edge = 1:bin:length(dN_cell_end);
        count_end=count_end+1;
        Task_bin_end(count_end,:) = histc(ts2, edge);
    %end
end

 

correlationmat = corr(Task_bin_end');
figure(1), clf
imagesc(correlationmat); colorbar;
title('Correlation Matrix of Single Units During Last Third of BMI Task')
tit = strcat('Corr_mat_Bin',num2str(bin));
saveas (gcf, tit,'tiff');
%pause;
close all;

opts.threshold.method = 'MarcenkoPastur';
opts.Patterns.method = 'ICA';
opts.Patterns.number_of_iterations = 1000;
Patterns = assembly_patterns(Task_bin_end,opts);

figure(2), clf
if size(Patterns,2)>0
    if size(Patterns,2)==1
    stem(Patterns(:,1));title ('Task Ensemble'); tit = strcat('Task_Ensemble_Bin', num2str(bin)); saveas(gcf,tit,'tiff');
 %   pause;
    Activities = assembly_activity(Patterns,Task_bin_all);
    figure(1), clf
    subplot(211)
    imagesc(Task_bin_all)
    subplot(212)
    plot(Activities')
    tit = strcat('Task_Activation_Bin',num2str(bin)); title(tit);
    saveas(gcf,tit,'tiff');   
    %pause;    
    elseif size(Patterns,2)==2
        
    subplot(211); stem(Patterns(:,1)); tit = strcat('Task_Ensembles_Bin', num2str(bin)); title (tit); 
    subplot(212); stem(Patterns(:,2));saveas(gcf,tit,'tiff'); close all;
    
    Activities = assembly_activity(Patterns,Task_bin_all);
    figure(1), clf
    subplot(211)
    imagesc(Task_bin_all)
    subplot(212)
    plot(Activities')
    tit = strcat('Task_Activation_Strengths', num2str(bin))
    saveas(gcf,tit,'tiff');    
    end
else 
%    Patterns='NaN';
    Assembly = 'NaN';
end

%xlim([0 length(B1_bin50)])
%xlim([0 length(B1_bin50)])
%figure;
%subplot(211); hist(diff(find(Activities(1,:)>10)))
%subplot(212); hist(diff(find(Activities(2,:)>10)))
%pause;,start_trial,units, units2, bin)


