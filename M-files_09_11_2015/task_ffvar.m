%function mean_normalized_Fano
%clear all;
%%%%Gets time_markers for when pellet dropped and when trial started.
Block1 = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T12_allblocks\censored\data_block_DemoTank2_Block-565.mat', 'TimeStamps','data','wave','Fs_lfp');
Block2 = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T12_allblocks\censored\data_block_DemoTank2_Block-568.mat','TimeStamps','data','wave');
Block3 = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T12_allblocks\censored\data_block_DemoTank2_Block-570.mat','TimeStamps','data','wave');
units2 = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T12_allblocks\censored\Session1bnew\alldata.mat','units');

%units=units2.units;
units = B1_units;
sc=2;
data1 = Block1.data;
wave1 = Block1.wave;
TimeStamps1 = Block1.TimeStamps;

data2 = Block2.data;
wave2 = Block2.wave;
TimeStamps2 = Block2.TimeStamps;

data3 = Block2.data;
wave3 = Block2.wave;
TimeStamps3 = Block3.TimeStamps;

Fs_lfp = Block1.Fs_lfp;

[trials1,pelletdrop1]=find_pulses_reach_dr(wave1,data1);
[trials2,pelletdrop2]=find_pulses_reach_dr(wave2,data2);
[trials3,pelletdrop3]=find_pulses_reach_dr(wave3,data3);
%%
close all;
trl_len=round(2*Fs_lfp)+100;
trl_len1=trl_len;
trl_len2=trl_len;
trl_len3=trl_len;

trl_num1 = length(pelletdrop1);
trl1=zeros(trl_num1,trl_len1);
%trl_data=zeros(trl_len,trl_num);

for i = 1:length(pelletdrop1)
trl1(i,:) = round(pelletdrop1(i)-2*Fs_lfp:pelletdrop1(i)+100);
end
sc=2;
for i=1:length(units)
    clear C phi S12 S1 S2 f zerosp confC phistd Cerr dn_pre ts* trl_datatmp e
    unit=units(i);    
    ts1tmp1=TimeStamps1{unit,sc}*Fs_lfp;
    ts1a=[];
    %ts = zeros(1018,trl_num);
    dN_pre1=zeros(trl_len1,trl_num1);
    for j = 1:trl_num1
        tstmp1 = ts1tmp1(ts1tmp1>trl1(j,1) & ts1tmp1<trl1(j,end));
        tstmp1=(tstmp1-trl1(j,1))/Fs_lfp;
        [dN_pre1(:,j),~]=binspikes(tstmp1,1017,[0 trl_len1/1017]);
    end
    ffsp1 = dN_pre1';
    ffsp_early1 = ffsp1(1:round(trl_num1/2),:);
    ffsp_late1 = ffsp1(round(trl_num1/2):end,:);
    T12B1early(i).spikes=ffsp_early1;
    T12B1late(i).spikes=ffsp_late1;
    T12B1(i).spikes = ffsp1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Blocks 2
%trl_len2=round(Fs_lfp)+101;
trl_num2 = length(pelletdrop2);
trl2=zeros(trl_num2,trl_len2);
%trl_data=zeros(trl_len,trl_num);

for i = 1:length(pelletdrop2)
trl2(i,:) = round(pelletdrop2(i)-2*Fs_lfp:pelletdrop2(i)+100);
end

for i=1:length(units)
    clear C phi S12 S1 S2 f zerosp confC phistd Cerr dn_pre ts* trl_datatmp 
    unit=units(i);    
    ts1tmp2=TimeStamps2{unit,sc}*Fs_lfp;
    ts1a=[];
    %ts = zeros(1018,trl_num);
    dN_pre2=zeros(trl_len2,trl_num2);
    for j = 1:trl_num2
        tstmp2 = ts1tmp2(ts1tmp2>trl2(j,1) & ts1tmp2<trl2(j,end));
        tstmp2=(tstmp2-trl2(j,1))/Fs_lfp;
        [dN_pre2(:,j),~]=binspikes(tstmp2,1017,[0 trl_len1/1017]);
    end
    ffsp2 = dN_pre2';
    ffsp_early2 = ffsp2(1:round(trl_num2/2),:);
    ffsp_late2 = ffsp2(round(trl_num2/2):end,:);
    T12B2early(i).spikes=ffsp_early2;
    T12B2late(i).spikes=ffsp_late2;
    T12B2(i).spikes = ffsp2;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Block 3
%trl_len3=round(Fs_lfp)+101;
trl_num3 = length(pelletdrop3);
trl3=zeros(trl_num3,trl_len3);
%trl_data=zeros(trl_len,trl_num);

for i = 1:length(pelletdrop3)
trl3(i,:) = round(pelletdrop3(i)-2*Fs_lfp:pelletdrop3(i)+100);
end

for i=1:length(units)
    clear C phi S12 S1 S2 f zerosp confC phistd Cerr dn_pre ts* trl_datatmp e
    unit=units(i);    
    ts1tmp3=TimeStamps3{unit,sc}*Fs_lfp;
    ts1a=[];
    %ts = zeros(1018,trl_num);
    dN_pre3=zeros(trl_len3,trl_num3);
    for j = 1:trl_num3
        tstmp3 = ts1tmp3(ts1tmp3>trl3(j,1) & ts1tmp3<trl3(j,end));
        tstmp3=(tstmp3-trl3(j,1))/Fs_lfp;
        [dN_pre3(:,j),~]=binspikes(tstmp3,1017,[0 trl_len1/1017]);
    end
    ffsp3 = dN_pre3';
    ffsp_early3 = ffsp3(1:round(trl_num3/2),:);
    ffsp_late3 = ffsp3(round(trl_num3/2):end,:);
    T12B3early(i).spikes=ffsp_early3;
    T12B3late(i).spikes=ffsp_late3;
    T12B3(i).spikes = ffsp3;
    %B3(i,:)=ffsp3;
end

%%
close all;
%figure;
times = 1600:50:1900;  % from 1000 ms before target onset 50 ms after.
fanoParams.alignTime = 1700;    % this time will become zero time
fanoParams.boxWidth = 100;     % 100 ms sliding window.
Result1 = VarVsMean(T12B1early, times, fanoParams);
plotFano(Result1); title('Block1 - early'); saveas(gcf,'Block1_FF','tiff');
Result2 = VarVsMean(T12B1late, times, fanoParams);
plotFano(Result2);title('Block1 - late');saveas(gcf,'Block2_FF','tiff');

%figure;
Result3 = VarVsMean(T12B2early, times, fanoParams);
plotFano(Result3); title('Block1 - early');saveas(gcf,'Block3_FF','tiff');
Result4 = VarVsMean(T12B2late, times, fanoParams);
plotFano(Result4);title('Block1 - late');saveas(gcf,'Block4_FF','tiff');


Result5 = VarVsMean(T12B3early, times, fanoParams);
plotFano(Result5); title('Block1 - early');saveas(gcf,'Block5_FF','tiff');
Result6 = VarVsMean(T12B3late, times, fanoParams);
plotFano(Result6);title('Block1 - late');saveas(gcf,'Block6_FF','tiff');

%%
FF_early = [mean(Result1.FanoFactor(1:3)) mean(Result2.FanoFactor(1:3)) mean(Result3.FanoFactor(1:3)) mean(Result4.FanoFactor(1:3)) mean(Result5.FanoFactor(1:3)) mean(Result6.FanoFactor(1:3))]
% FF_premov = [mean(Result1.FanoFactor(4:6)) mean(Result2.FanoFactor(4:6)) mean(Result3.FanoFactor(4:6)) mean(Result4.FanoFactor(4:6)) mean(Result5.FanoFactor(4:6)) mean(Result6.FanoFactor(4:6))]
% FF_mov = [mean(Result1.FanoFactor(7:9)) mean(Result2.FanoFactor(7:9)) mean(Result3.FanoFactor(7:9)) mean(Result4.FanoFactor(7:9)) mean(Result5.FanoFactor(7:9)) mean(Result6.FanoFactor(7:9))]
 FF_mov = [mean(Result1.FanoFactor(4:7)) mean(Result2.FanoFactor(4:7)) mean(Result3.FanoFactor(4:7)) mean(Result4.FanoFactor(4:7)) mean(Result5.FanoFactor(4:7)) mean(Result6.FanoFactor(4:7))]

%%

subplot(311); bar(FF_early, 'k'); title('Fano Factor - Early');
%subplot(312); bar(FF_premov, 'r'); title('Fano Factor - Pre-Movement');
subplot(313); bar(FF_mov, 'b'); title('Fano Factor - Movement');
pause;
figure;
%subplot(211); bar(FF_mov./FF_premov, 'k'); title('Fano Factor Ratio: Movement/Pre-Movement');
subplot(212); bar(FF_mov./FF_early, 'k'); title('Fano Factor Ratio: Movement/Early');

xlabel(gca, 'Blocks (Early and Late)');

%%
close all;
times = 1600:50:1950;  % from 1000 ms before target onset 50 ms after.
fanoParams.alignTime = 1700;    % this time will become zero time
fanoParams.boxWidth = 100;     % 100 ms sliding window.
Result1 = VarVsMean(T12B1, times, fanoParams);
plotFano(Result1); title('Block1'); saveas(gcf,'Block1alltrials_FF','tiff'); pause; close all;
Result2 = VarVsMean(T12B2, times, fanoParams);
plotFano(Result2);title('Block2');saveas(gcf,'Block2alltrials_FF','tiff'); pause; close all;
Result3 = VarVsMean(T12B3, times, fanoParams);
plotFano(Result3); title('Block3');saveas(gcf,'Block3alltrials_FF','tiff'); pause; close all;
 %%
FF_premov = [mean(Result1.FanoFactor(1:4)) mean(Result2.FanoFactor(1:4)) mean(Result3.FanoFactor(1:4))]
FF_mov = [mean(Result1.FanoFactor(5:8)) mean(Result2.FanoFactor(5:8)) mean(Result3.FanoFactor(5:8))]
%FF_mov = [mean(Result1.FanoFactor(8:11)) mean(Result2.FanoFactor(8:11)) mean(Result3.FanoFactor(8:11))]

%%

%subplot(311); bar(FF_early, 'k'); title('Fano Factor - Early');
subplot(312); bar(FF_premov, 'r'); title('Fano Factor - Pre-Movement');
subplot(313); bar(FF_mov, 'b'); title('Fano Factor - Movement');
pause;
figure;
subplot(211); bar(FF_mov./FF_premov, 'k'); title('Fano Factor Ratio: Movement/Pre-Movement');
%subplot(212); bar(FF_mov./FF_early, 'k'); title('Fano Factor Ratio: Movement/Pre-Movement');

xlabel(gca, 'Blocks (Early and Late)');

%%
close all;
scatterParams.axLim = 'auto'; 
scatterParams.axLen = 5;
scatterParams.showSelect=1;
scatterParams.showFanoAll=0;
scatterParams.plotInExistingFig=0;
time=100;

plotScatter(Result1, time, scatterParams);
text(2.5, 7, 'Block 1 early: 150 ms before target', 'hori', 'center');
plotScatter(Result2, time, scatterParams);
text(2.5, 7, 'Block 1 late: 150 ms before target', 'hori', 'center');
plotScatter(Result3, time, scatterParams);
text(2.5, 7, 'Block 2 early: 150 ms before target', 'hori', 'center');
plotScatter(Result4, time, scatterParams);
text(2.5, 7, 'Block 2 late: 150 ms before target', 'hori', 'center');
plotScatter(Result5, time, scatterParams);
text(2.5, 7, 'Block 3 early: 150 ms before target', 'hori', 'center');
plotScatter(Result6, time, scatterParams);
text(2.5, 7, 'Block 3 late: 150 ms before target', 'hori', 'center');
%%
FF_early = [mean(Result1.FanoFactor(1:3)) mean(Result2.FanoFactor(1:3)) mean(Result3.FanoFactor(1:3)) mean(Result4.FanoFactor(1:3)) mean(Result5.FanoFactor(1:3)) mean(Result6.FanoFactor(1:3))]
FF_premov = [mean(Result1.FanoFactor(4:7)) mean(Result2.FanoFactor(4:7)) mean(Result3.FanoFactor(4:7)) mean(Result4.FanoFactor(4:7)) mean(Result5.FanoFactor(4:7)) mean(Result6.FanoFactor(4:7))]
FF_mov = [mean(Result1.FanoFactor(8:11)) mean(Result2.FanoFactor(8:11)) mean(Result3.FanoFactor(8:11)) mean(Result4.FanoFactor(8:11)) mean(Result5.FanoFactor(8:11)) mean(Result6.FanoFactor(8:11))]
