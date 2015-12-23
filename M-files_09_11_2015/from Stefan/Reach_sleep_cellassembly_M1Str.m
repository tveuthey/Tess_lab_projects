%function [Activities_pre Activities_post]=Reach_sleep_cellassembly_M1Str(TimeStamps1,TimeStamps2, time_pre,time_post,Fs_lfp, bin,units1,units2,Patterns,dir,template)

B1 = load('E:\M1-Striatum\Data\M1Striatum\T107n\data_block_T107_Block-3.mat');
B2 = load('E:\M1-Striatum\Data\M1Striatum\T107n\data_block_T107_Block-6.mat');
load ('E:\M1-Striatum\Data\M1Striatum\T107n\Day1\Block1\Peth\Units.mat');
load('E:\M1-Striatum\Data\M1Striatum\T107n\Day1\sleep_indsB1.mat')
load('E:\M1-Striatum\Data\M1Striatum\T107n\Day1\sleep_indsB2.mat')
load('E:\M1-Striatum\Data\M1Striatum\T107n\Day1\Block1\PC_ens\EnsemblesM1StrPCA.mat');

TimeStamps1 = B1.TimeStamps;
TimeStamps2 = B2. TimeStamps;
time_pre = sleep_indsB1;
time_post = sleep_indsB2;
Fs_lfp = 1.017252624511719e+03;
bin = 25;
units1 = unitsM1;
units2 = unitsStr;
Patterns = Patterns50;
dir = ('E:\M1-Striatum\Data\M1Striatum\T107n\Day1\Block1\PC_ens\Replay\test\');
template = 'B1b_M1Str';


count=0;
for a = 1: length(units1)
    for i = 1:length(units1(a).un)
        count = count+1;
        clear dn_pre ts* trl_datatmp
        unit=units1(a).un(i);
        sc = a+1;
        ts1=TimeStamps1{unit,sc}*Fs_lfp;
        ts2=TimeStamps2{unit,sc}*Fs_lfp;
        dN_pre = [];
        dN_post=[];
        tmplen=0;
        ts1atmp2=[];
        ts1atmp=[];
        ts1a=[];
        ts2a=[];
        ts2atmp2=[];
        ts2atmp=[];
        for j = 1:size(time_pre,1)
            ts1atmp = ts1(ts1>time_pre(j,1) & ts1<time_pre(j,2));
            bin1 = [time_pre(j,1):bin:time_pre(j,2)];
            ts_bin = histc(ts1atmp,bin1);
            dN_pre = [dN_pre ts_bin];
        end
        
        for j = 1:size(time_post,1)
            ts2atmp = ts2(ts2>time_post(j,1) & ts2<time_post(j,2));
            bin2=[time_post(j,1):bin:time_post(j,2)];
            ts_bin2 = histc(ts2atmp,bin2);
            dN_post = [dN_post ts_bin2];
        end
        if ~isempty(dN_pre)
            Spre(count,:) = dN_pre;
        else
            Spre(count,:) = zeros(1,length(Spre));
        end
        if ~isempty(dN_post)
            Spost(count,:) = dN_post;
        else
            Spost(count,:) = zeros(1,length(Spost));
        end
    end
end

for a = 1: length(units2)
    for i = 1:length(units2(a).un)
        count = count+1;
        clear dn_pre ts* trl_datatmp
        unit=units2(a).un(i);
        sc = a+1;
        ts1=TimeStamps1{unit,sc}*Fs_lfp;
        ts2=TimeStamps2{unit,sc}*Fs_lfp;
        dN_pre = [];
        dN_post=[];
        tmplen=0;
        ts1atmp2=[];
        ts1atmp=[];
        ts1a=[];
        ts2a=[];
        ts2atmp2=[];
        ts2atmp=[];
        for j = 1:size(time_pre,1)
            ts1atmp = ts1(ts1>time_pre(j,1) & ts1<time_pre(j,2));
            bin1 = [time_pre(j,1):bin:time_pre(j,2)];
            ts_bin = histc(ts1atmp,bin1);
            dN_pre = [dN_pre ts_bin];
        end
        
        for j = 1:size(time_post,1)
            ts2atmp = ts2(ts2>time_post(j,1) & ts2<time_post(j,2));
            bin2=[time_post(j,1):bin:time_post(j,2)];
            ts_bin2 = histc(ts2atmp,bin2);
            dN_post = [dN_post ts_bin2];
        end
            if ~isempty(dN_pre)
            Spre(count,:) = dN_pre;
        else
            Spre(count,:) = zeros(1,length(Spre));
        end

        if ~isempty(dN_post)
            Spost(count,:) = dN_post;
        else
            Spost(count,:) = zeros(1,length(Spost));
        end
    end
end

disp(x)
clear TimeStamps*

Activities_pre = assembly_activity(Patterns,Spre);
Activities_post = assembly_activity(Patterns,Spost);
ymx = max([Activities_pre Activities_post]');
ymn = min([Activities_pre Activities_post]');

for i = 1:(size(Patterns,2))
    figure; clf;
    subplot(221)
    plot(Activities_pre(i,:))
    ylim([-100 500])
    title('Ensemble Strength Pre-Learning Sleep Block');
    
    subplot(222)
    plot(Activities_post(i,:))
    ylim([-100 500])
    title('Ensemble Strength Post-Learning Sleep Block');
    
    subplot(223)
    
    Mn(i,1) = mean(Activities_pre(i,:));
    Mn(i,2)= mean(Activities_post(i,:));
    Err(i,1) = std(Activities_pre(i,:))/sqrt(length(Activities_pre(i,:)));
    Err(i,2) = std(Activities_post(i,:))/sqrt(length(Activities_pre(i,:)));
    [~,p]=ttest2(Activities_pre(i,:),Activities_post(i,:));
    
    errorbar(Mn(i,:),Err(i,:));
    title('Mean Change in Activation Strength');
    pval = strcat('p = ',num2str(p,2));
    text(1.5,Mn(i,2)+0.005,pval);
    
    [h,p,k] = kstest2(Activities_pre(i,:),Activities_post(i,:),.05,'smaller');
    [h2,p2,k2] = kstest2(Activities_pre(i,:),Activities_post(i,:),.05,'larger');
    
    subplot(224)
    
    tmppre=sort(Activities_pre(i,:),'descend');
    tmppost=sort(Activities_post(i,:),'descend');
    ln=min([length(tmppre),length(tmppost)]);
    tmppre=tmppre(1:round(ln/10));
    tmppost=tmppost(1:round(ln/10));
    
    Mn(i,1) = mean(tmppre);
    Mn(i,2)= mean(tmppost);
    Err(i,1) = std(tmppre)/sqrt(ln);
    Err(i,2) = std(tmppost)/sqrt(ln);
    
    errorbar(Mn(i,:),Err(i,:));
    title('Top Decile Activation Strength');
    [~,p]=ttest2(tmppre,tmppost);
    pval = strcat('p = ',num2str(p,2));
    text(1.5,Mn(i,2)+0.005,pval);
    
    cd(dir);
    filesav = strcat('Pre-Post Activation Bin',num2str(bin),'Ensemble',num2str(i),'template',template);
    saveas(gcf,filesav,'tiff');
    %pause;
    close all;
end


