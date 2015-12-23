

clear all;
%%%%Gets time_markers for when pellet dropped and when trial started.
Block1 = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T12_allblocks\censored\data_block_DemoTank2_Block-565.mat', 'TimeStamps','data','wave','Fs_lfp');
Block2 = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T12_allblocks\censored\data_block_DemoTank2_Block-568.mat','TimeStamps','data','wave');
Block3 = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T12_allblocks\censored\data_block_DemoTank2_Block-570.mat','TimeStamps','data','wave');
unitstmp = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T12_allblocks\censored\Session1cnew\alldata.mat','units', 'units2');

% SleepBlocka = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T12_allblocks\censored\Session1anew\alldata.mat',  'data1', 'data2', 'TimeStamps1','TimeStamps2', 'sleep_ind_pre1','sleep_ind_post1');
% SleepBlockb = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T12_allblocks\censored\Session1bnew\alldata.mat',  'data1', 'data2', 'TimeStamps1','TimeStamps2', 'sleep_ind_pre1','sleep_ind_post1');
% SleepBlockc = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T12_allblocks\censored\Session1cnew\alldata.mat', 'data1', 'data2', 'TimeStamps1','TimeStamps2', 'sleep_ind_pre1','sleep_ind_post1');
% SleepBlock3 = SleepBlock
%%
clear SleepBlock;

% presleepdata = SleepBlocka.data2;
% postsleepdata = SleepBlockb.data2;
% 
% presleepts = SleepBlocka.TimeStamps2;
% postsleepts = SleepBlockb.TimeStamps2;
% 
% time_pre1 = SleepBlocka.sleep_ind_post1;
% time_post1 = SleepBlockb.sleep_ind_post1;

units=unitstmp.units;
units2=unitstmp.units2;
units(6:8)=[];

data1 = Block1.data;
wave1 = Block1.wave;
TimeStamps1 = Block1.TimeStamps;

data2 = Block2.data;
wave2 = Block2.wave;
TimeStamps2 = Block2.TimeStamps;

data3 = Block3.data;
wave3 = Block3.wave;
TimeStamps3 = Block3.TimeStamps;

Fs_lfp = Block1.Fs_lfp;

[trials1,pelletdrop1]=find_pulses_reach_dr(wave1,data1);
[trials2,pelletdrop2]=find_pulses_reach_dr(wave2,data2);
[trials3,pelletdrop3]=find_pulses_reach_dr(wave3,data3);
%%
trial1_data = make_trial_mat(pelletdrop1,data1,2*Fs_lfp,0);
trial2_data = make_trial_mat(pelletdrop2,data2,2*Fs_lfp,0);
trial3_data = make_trial_mat(pelletdrop3,data3,2*Fs_lfp,0);
        params.Fs=Fs_lfp;
        params.fpass=[0 40];
        params.tapers=[3 5];
        params.trialave=1;
        params.pad=0;
        params.err=[2 0.05];
        
win = .2;
movingwin=[0.3 0.05]

%[Sc,Cmat,Ctot,Cvec,Cent,f]=CrossSpecMatc(trial1_data,win,params)
%[Sc,Cmat,Ctot,Cvec,Cent,f]=CrossSpecMatc(trial2_data,win,params)
%[Sc,Cmat,Ctot,Cvec,Cent,f]=CrossSpecMatc(trial3_data,win,params)
%%
% S1m = squeeze(mean(S1(:,1,:),2));
% S2m = squeeze(mean(S2(:,1:8,:),2));
% S3m = squeeze(mean(S3(:,1:8,:),2));
% S1d = squeeze(std(S1(:,1:8,:),0,2));
% S2d = squeeze(std(S2(:,1:8,:),0,2));
% S3d = squeeze(std(S3(:,1:8,:),0,2));

S1m = squeeze(mean(S1(:,1:8,:),2));
S2m = squeeze(mean(S2(:,1:8,:),2));
S3m = squeeze(mean(S3(:,1:8,:),2));
S1d = squeeze(std(S1(:,1:8,:),0,2));
S2d = squeeze(std(S2(:,1:8,:),0,2));
S3d = squeeze(std(S3(:,1:8,:),0,2));

clear S1b S2b S3b
    for j = 1:24
    S1b(:,:,j) = (squeeze(S1(:,j,:))-S1m)./S1d;
    S2b(:,:,j) = (squeeze(S2(:,j,:))-S2m)./S2d;
    S3b(:,:,j) = (squeeze(S3(:,j,:))-S3m)./S3d;
    end

S1b = permute(S1b, [1 3 2]);
S2b = permute(S2b, [1 3 2]);
S3b = permute(S3b, [1 3 2]);

%%
clear S* 
count=0;  
for i = 1:32
tic
count=count+1;
    [S1(count,:,:), t1, f1, Serr1(count,:,:,:)]=mtspecgramc(squeeze(trial1_data(:,i,:)),movingwin,params);
    [S2(count,:,:), t2, f2, Serr2(count,:,:,:)]=mtspecgramc(squeeze(trial2_data(:,i,:)),movingwin,params);
    [S3(count,:,:), t3, f3, Serr3(count,:,:,:)]=mtspecgramc(squeeze(trial3_data(:,i,:)),movingwin,params);
toc
end


%%
for i = 1:32
    figure;
    subplot(311); imagesc(t1-1.53,f1,squeeze(S1b(i,:,:))',[-10 10]); axis xy; colorbar;title(strcat('Channel',num2str(i),' Learning Block 1'));
    subplot(312); imagesc(t2-1.53,f2,squeeze(S2b(i,:,:))',[-10 10]); axis xy; colorbar;title(strcat('Channel',num2str(i),' Learning Block 2'))
    subplot(313); imagesc(t3-1.53,f3,squeeze(S3b(i,:,:))',[-10 10]); axis xy; colorbar;title(strcat('Channel',num2str(i),' Learning Block 3'))
%    pause;
    tit = strcat('Spectogram Ch',num2str(i));
    saveas(gcf,tit,'tiff');
    close all
end
%%
save spec.mat
%%
close all; 
trl_len=round(Fs_lfp)+101;
trl_len1=trl_len;
trl_len2=trl_len;
trl_len3=trl_len;
trl_num1 = length(pelletdrop1);
trl1=zeros(trl_num1,trl_len1);
%trl_data=zeros(trl_len,trl_num);

for i = 1:length(pelletdrop1)
trl1(i,:) = round(pelletdrop1(i)-Fs_lfp:pelletdrop1(i)+100);
end
count=0;
B1_units=[];
for i=1:(length(units)+length(units2))
    clear C phi S12 S1 S2 f zerosp confC phistd Cerr dn_pre ts* trl_datatmp e
    if i<= length(units)
    unit=units(i);    
    ts1tmp1=TimeStamps1{unit,2}*Fs_lfp;
    else
    unit=units2(i-length(units));    
    ts1tmp1=TimeStamps1{unit,3}*Fs_lfp;
    end
    tsall=[];
    
    %ts = zeros(1018,trl_num);
    dN_pre1=zeros(trl_len1,trl_num1);
    dN_cell=[];
    for j = 1:trl_num1
        tstmp1 = ts1tmp1(ts1tmp1>trl1(j,1) & ts1tmp1<trl1(j,end));
        tstmp1=(tstmp1-trl1(j,1))/Fs_lfp;
        %tsall=[tsall tstmp1];
        [dN_tmp,~]=binspikes(tstmp1,1017,[0 (trl_len1/1017)]);
        dN_cell = [dN_cell; dN_tmp];
     
    end
    ts = find(dN_cell)';
    if ~isempty(ts)
    edge50 = 1:50:length(dN_cell);
    edge10 = 1:10:length(dN_cell);
    edge25 = 1:25:length(dN_cell);
    edge100 = 1:100:length(dN_cell);
    count=count+1;
    B1_bin10(count,:)  = histc(ts, edge10); 
    B1_bin25(count,:)  = histc(ts,edge25);
    B1_bin50(count,:)  = histc(ts,edge50);
    B1_bin100(count,:) = histc(ts,edge100);
    B1_units=[B1_units,unit];
    end
 end

opts.threshold.method = 'MarcenkoPastur';
opts.Patterns.method = 'ICA';
opts.Patterns.number_of_iterations = 1000;
Patterns = assembly_patterns(B1_bin50,opts);

correlationmat = corr(B1_bin50');
figure(1), clf
imagesc(correlationmat);

figure(2), clf
subplot(211)
stem(Patterns(:,1))
%subplot(212)
%stem(Patterns(:,2))

Activities = assembly_activity(Patterns,B1_bin50);

figure(4), clf
subplot(211)
imagesc(B1_bin50)
%xlim([0 length(B1_bin50)])
subplot(212)
plot(Activities')
%xlim([0 length(B1_bin50)])
%figure;
%subplot(211); hist(diff(find(Activities(1,:)>10)))
%subplot(212); hist(diff(find(Activities(2,:)>10)))
%pause;
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Blocks 2
close all;
%trl_len2=round(Fs_lfp)+101;
trl_num2 = length(pelletdrop2);
trl2=zeros(trl_num2,trl_len2);
%trl_data=zeros(trl_len,trl_num);

for i = 1:length(pelletdrop2)
trl2(i,:) = round(pelletdrop2(i)-Fs_lfp:pelletdrop2(i)+100);
end
count=0;
B2_units=[];
for i=1:(length(units)+length(units2))

    clear C phi S12 S1 S2 f zerosp confC phistd Cerr dn_pre ts* trl_datatmp e
    if i<= length(units)
    unit=units(i);    
    ts1tmp2=TimeStamps2{unit,2}*Fs_lfp;
    else
    unit=units2(i-length(units));    
    ts1tmp2=TimeStamps2{unit,3}*Fs_lfp;
    end
    dN_cell2 = [];
    dN_pre2=zeros(trl_len2,trl_num2);
    for j = 1:trl_num2
        tstmp2 = ts1tmp2(ts1tmp2>trl2(j,1) & ts1tmp2<trl2(j,end));
%         if ~isempty(tstmp2)
         tstmp2=(tstmp2-trl2(j,1))/Fs_lfp;
        [dN_tmp,~]=binspikes(tstmp2,1017,[0 (trl_len2/1017)]);
        dN_cell2 = [dN_cell2; dN_tmp];
    end
    ts2 = find(dN_cell2)';
    if ~isempty(ts2)
    count=count+1;
    B2edge50 = 1:50:length(dN_cell2);
    B2edge10 = 1:10:length(dN_cell2);
    B2edge25 = 1:25:length(dN_cell2);
    B2edge100 = 1:100:length(dN_cell2);

    B2_bin10(count,:)  = histc(ts2, B2edge10); 
    B2_bin25(count,:)  = histc(ts2,B2edge25);
    B2_bin50(count,:)  = histc(ts2,B2edge50);
    B2_bin100(count,:) = histc(ts2,B2edge100);
    B2_units = [B2_units, unit];
    end
 end

opts.threshold.method = 'MarcenkoPastur';
opts.Patterns.method = 'ICA';
opts.Patterns.number_of_iterations = 1000;
Patterns2 = assembly_patterns(B2_bin50,opts);

correlationmat = corr(B2_bin50');
figure(1), clf
imagesc(correlationmat);

figure(2), clf
subplot(211)
stem(Patterns2(:,1))
% subplot(212)
% stem(Patterns(:,2))

Activities2 = assembly_activity(Patterns2,B2_bin50);

figure(4), clf 
subplot(211)
imagesc(B2_bin50)
%xlim([0 1000])
subplot(212)
plot(Activities2')
%xlim([0 1000])
%figure;
%subplot(211); hist(diff(find(Activities(1,:)>10)))
%subplot(212); hist(diff(find(Activities(2,:)>10)))
%;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Block 3

close all;
%trl_len2=round(Fs_lfp)+101;
trl_num3 = length(pelletdrop3);
trl3=zeros(trl_num3,trl_len2);
%trl_data=zeros(trl_len,trl_num);

for i = 1:length(pelletdrop3)
trl3(i,:) = round(pelletdrop3(i)-Fs_lfp:pelletdrop3(i)+100);
end
count=0;
B3_units=[];

for i=1:(length(units)+length(units2))
    clear C phi S12 S1 S2 f zerosp confC phistd Cerr dn_pre ts* trl_datatmp e
    if i<= length(units)
    unit=units(i);    
    ts1tmp3=TimeStamps3{unit,2}*Fs_lfp;
    else
    unit=units2(i-length(units));    
    ts1tmp3=TimeStamps3{unit,3}*Fs_lfp;
    disp(ts1tmp3)
    %;
    end

    %ts = zeros(1018,trl_num);
    dN_cell3 = [];
    dN_pre3=zeros(trl_len3,trl_num3);
    for j = 1:trl_num3
        tstmp3 = ts1tmp3(ts1tmp3>trl3(j,1) & ts1tmp3<trl3(j,end));
%         if ~isempty(tstmp2)
         tstmp3=(tstmp3-trl3(j,1))/Fs_lfp;
        [dN_tmp,~]=binspikes(tstmp3,1017,[0 (trl_len3/1017)]);
        dN_cell3 = [dN_cell3; dN_tmp];
     
    end
    ts3 = find(dN_cell3)';
    if ~isempty(ts3)
    count=count+1;
    B3edge50 = 1:50:length(dN_cell3);
    B3edge10 = 1:10:length(dN_cell3);
    B3edge25 = 1:25:length(dN_cell3);
    B3edge100 = 1:100:length(dN_cell3);

    B3_bin10(count,:)  = histc(ts3, B3edge10); 
    B3_bin25(count,:)  = histc(ts3,B3edge25);
    B3_bin50(count,:)  = histc(ts3,B3edge50);
    B3_bin100(count,:) = histc(ts3,B3edge100);
    B3_units = [B3_units, unit];
    end
 end

opts.threshold.method = 'MarcenkoPastur';
opts.Patterns.method = 'ICA';
opts.Patterns.number_of_iterations = 1000;
Patterns3 = assembly_patterns(B3_bin100,opts);

correlationmat = corr(B3_bin50');
figure(1), clf
imagesc(correlationmat);

figure(2), clf
subplot(211)
stem(Patterns3(:,1))
% subplot(212)
% stem(Patterns(:,2))

Activities3 = assembly_activity(Patterns3,B3_bin100);

figure(4), clf 
subplot(211)
imagesc(B3_bin50)
%xlim([0 1000])
subplot(212)
plot(Activities3')
%xlim([0 1000])
figure;
subplot(211); hist(diff(find(Activities3(1,:)>10)))
%subplot(212); hist(diff(find(Activities3(2,:)>10)))

close all
subplot(331); plot(Activities'); ylim([-45 45]);
subplot(332); plot(Activities2');ylim([-45 45]);
subplot(333); plot(Activities3');ylim([-45 45]);
subplot(334); stem(Patterns); 
subplot(335); stem(Patterns2);
subplot(336); stem(Patterns3);
subplot(337); imagesc(B1_bin50);
subplot(338); imagesc(B2_bin50);
subplot(339); imagesc(B3_bin50);

% q = size(zSpikeCount,1)/size(zSpikeCount,2);
% lambda_max = ((1+sqrt(1/q))^2);
%%

 B1_bin100=B1_bin100(1:8,:);
 B2_bin100=B2_bin100(1:8,:);

  % B3_bin50(9,:)=[];

B_all_bin100 = [B1_bin100, B2_bin100, B3_bin100];
Patterns_all = assembly_patterns(B_all_bin100,opts);
Activities_all = assembly_activity(Patterns_all,B_all_bin100);
figure(1), clf 

subplot(221)
imagesc(B_all_bin100)
title('Spike Rasters During Reach Task');

subplot(222)
stem(Patterns_all); ylim([-0.7 0.7]);
title('Contribution of Units to Ensemble Activity');

subplot(223)
plot(Activities_all)
hold on;
plot(700,[-50:50],'k');
plot(1500,[-50:50],'k');
xlim([1 2300]);
%plot(1388+1612,[-50:50],'k');
title('Ensemble Strength Across Time and Over Blocks');
text(100,40,'Block 1');
text(700,40,'Block 2');
text(1500,40,'Block 3');

hold off;

AB(1) = mean(Activities_all(1:694));
AB(2) = mean(Activities_all(695:695+806)); 
AB(3) = mean(Activities_all(695+807:end));

% subplot(311); hist(Activities_all(1:1388))
% subplot(312); hist(Activities_all(1389:1389+1613))
% subplot(313); hist(Activities_all(1389+1613:end))

errB(1) = std(Activities_all(1:694))/sqrt(694);
errB(2) = std(Activities_all(695:695+806))/sqrt(806);
errB(3) = std(Activities_all(695+807:end))/sqrt(806);

subplot(224);
errorbar([1:1:length(AB)],AB,errB); xlim('auto');
set(gca,'xtick',0:10)
title('Mean Ensemble Activity Strength Across Task Blocks');

%%
count=0;
clear Sp*
Spost_units=[];
for i = 1:(length(units)+length(units2))
    clear ts*
    if i <= length(units)
    unit=units(i);    
    ts_presleep=presleepts{unit,2}*Fs_lfp;
    ts_postsleep=postsleepts{unit,2}*Fs_lfp;
    else
    unit=units2(i-length(units));
    ts_presleep=presleepts{unit,3}*Fs_lfp;
    ts_postsleep= postsleepts{unit,3}*Fs_lfp;
    end

    dN_pre = [];
    dN_post=[];
    tmplen=0;
    ts1atmp2=[];
    ts1atmp=[];
    ts1a=[];
    ts2a=[];
    ts2atmp2=[];
    ts2atmp=[];

    for j = 1:length(time_pre1)
         
            ts1atmp = ts_presleep(ts_presleep>time_pre1(j,1) & ts_presleep<time_pre1(j,2));
            ts1atmp2=(ts1atmp-time_pre1(j,1))/Fs_lfp;
            ts1a = [ts1a ts1atmp2];
           [dN_tmp,~]=binspikes(ts1atmp2,1017,[0 (time_pre1(j,2)-time_pre1(j,1))/1017]);
           dN_pre = [dN_pre; dN_tmp];
    
    end
    
    for j = 1:length(time_post1)
        ts1atmp = ts_postsleep(ts_postsleep>time_post1(j,1) & ts_postsleep<time_post1(j,2));
           ts2atmp2=(ts1atmp-time_post1(j,1))/Fs_lfp;
           ts2a = [ts2a ts2atmp2];
           [dN_tmp,~]=binspikes(ts2atmp2,1017,[0 (time_post1(j,2)-time_post1(j,1))/1017]);
           dN_post = [dN_post; dN_tmp];
    end
    
    if length(dN_pre)>length(dN_post)
        dN_pre=dN_pre(1:length(dN_post));
    else
        dN_post=dN_post(1:length(dN_pre));
    end

    tspre = find(dN_pre);
    tspost=find(dN_post);

    if (~isempty(tspre) & ~isempty(tspost))
    count=count+1;
    Sedge50 = 1:50:length(dN_pre);
    Sedge10 = 1:10:length(dN_pre);
    Sedge25 = 1:25:length(dN_pre);
    Sedge100 = 1:100:length(dN_pre);

    Spre_bin10(count,:)  = histc(tspre, Sedge10); 
    Spre_bin25(count,:)  = histc(tspre,Sedge25);
    Spre_bin50(count,:)  = histc(tspre,Sedge50);
    Spre_bin100(count,:) = histc(tspre,Sedge100);
    %Sall_units           = [B3_units, unit];
    Spost_bin10(count,:)  = histc(tspost, Sedge10); 
    Spost_bin25(count,:)  = histc(tspost,Sedge25);
    Spost_bin50(count,:)  = histc(tspost,Sedge50);
    Spost_bin100(count,:) = histc(tspost,Sedge100);
    Spost_units = [Spost_units, unit];
    end
end
    
    
%    Spre_bin50(9,:)=[];
 %   Spost_bin50(9,:)=[];
    Spre_bin50=Spre_bin50(1:8,:);
    Spost_bin50=Spost_bin50(1:8,:);

    Activities_pre = assembly_activity(Patterns3,Spre_bin50);
    Activities_post = assembly_activity(Patterns3,Spost_bin50);

    subplot(311)
    plot(Activities_pre)
    %xlim([1 14000]);
    ylim([-50 50])
    title('Ensemble Strength Pre-Learning Sleep Block');

    subplot(312)
    plot(Activities_post)
    %xlim([1 14000]);
    ylim([-50 50])
    %plot(1388+1612,[-50:50],'k');
    title('Ensemble Strength Post-Learning Sleep Block');
    
    subplot(313)
    Mn(1) = mean(abs(Activities_pre));
    Mn(2)= mean(abs(Activities_post));
    Err(1) = std(abs(Activities_pre))/sqrt(length(Activities_pre));
    Err(2) = std(abs(Activities_post))/sqrt(length(Activities_pre));
    [~,p]=ttest2(abs(Activities_pre),abs(Activities_post))
    [~,p]=ttest2(Activities_pre,Activities_post)

    errorbar(Mn,Err);
    title('Mean Change in Activation Strength');
    text(2,Mn(2)+5,'**');
    
    

post_freq=length(find(abs(Activities_post)>1));    
pre_freq=length(find(abs(Activities_pre)>1));

%mean_pre_ev = mean(Activities_pre(abs(Activities_pre)>1))
%mean_post_ev = mean(Activities_post(abs(Activities_post)>1))

%[h,p] = ttest2((Activities_pre(abs(Activities_pre)>1)),(Activities_post(abs(Activities_post)>1)))
 