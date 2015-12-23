function [Phmap,EPhmap] = plot_ECOG_heatmap(Block)
%function [Phmap,EPhmap] = plot_ECOG_heatmap(Block)
%enter block number that was saved into TDT tank. This function will
%extract the data from the Tank (if saved as LFPs), Z-score the data,
%subtract the overall median across all channels of the Z-scored data
%from each channel, and then will plot the evoked potential from
%stimulation (including 500ms before and 1000ms after the stimulation onset
%as defined in the wave function). Channels that are greater than 3SD from
%mean after Z-scoring are taken out.
%If function is failing, possible that
% the Tankname, or data name has been changed (i.e., data is called ECOG
% instead of LFPs for example; you are using a 64 channel instead of 32
% channel ECOG grid;


%%%%%%%%%%%%%%Extracting Data from TDT Data Tank
Block=4;
TankName='DemoTank2';
Block_Name=strcat('Block-',num2str(Block));
cd 'C:\TDT\OpenEx\Tanks\DemoTank2';

%Activate Tank DLL
TTX = actxcontrol('TTank.X');
servername = 'Local';
clientname = 'Me';
if TTX.ConnectServer(servername, clientname)~=1
    disp 'Server Error';
end
if TTX.OpenTank (TankName, 'R')~=1;
    disp 'Tank Error';
end
if TTX.SelectBlock(Block_Name)~=1;
    disp 'Block Error';
end

Allstreams = TDT2mat(TankName, Block_Name,'TYPE',4);
data = Allstreams.streams.LFPs.data;
Fs_lfp = Allstreams.streams.LFPs.fs;
wave = Allstreams.streams.Wave.data;
clear Allstreams;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Z-scoring data, and substracting median
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Z-scored data from each channel.

Zdata = Zscore(data')';
Zmean1 = median(Zdata);
Zsd1 = std(Zdata);

Zmean2 = median(Zdata,2);

Zmean3 = mean(Zmean2);
Zsd3 = std(Zmean2);

badch1 = find(abs(Zmean2)>Zmean3+2*Zsd3);
badch2 = find(abs(Zmean2)<Zmean3-2*Zsd3);
badch = [badch1 badch2];
Zdata(badch,:)=NaN;
Zmean = nanmean(Zdata);

nData= bsxfun(@minus,Zdata,Zmean);
clear Z* data

%%%%%%%%%%%%%%%%%%%%%%%%%Looking at High Gamma Power
 srate = Fs_lfp;
 nyq_sample=srate/2;
 FILTER_ORDER=3;
 f_lo=150;
 f_hi=80;
 [b2,a2]=butter(FILTER_ORDER,[f_hi f_lo]/nyq_sample);
for i = 1:32
HG(i,:)=(filtfilt(b2,a2,nData(i,:)));
end

params.tapers=[20 39];
params.Fs=Fs_lfp;
params.fpass=[80 150];
params.pad=1;
params.err=[2 0.05];
params.trialave=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Getting markers of stimulation current
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%pulses.
tmp2 = nData;
nData = HG;

wave=wave(1,:);
thr = max(wave)*0.8;
temp3=wave>thr;
length_to_analyze=length(wave);
start_times=diff(temp3)>0.5;
[start_times]=find(start_times==1)';

close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%extracting and plotting data for evoked potential.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Currently plotting 500 msecs before and 1000
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%msecs after stimulation.

for i=1:size(nData,1)
    for j = 1:length(start_times)
        tmp(j,:) = nData(i,start_times(j)-500:start_times(j)+1000);
        if ~isnan(tmp(1,1))
            ep(i,:) = mean(tmp,1);
            pk(1)=max(ep(i,550:650));
            pk(2)=min(ep(i,550:650));
%             if(abs(pk(1))>abs(pk(2)))
%                 m_ep(i)= pk(1);
%             else
                m_ep(i)=pk(2);
           % end
        else
            ep(i,:)=zeros(1,1501);
            m_ep(i)=0;
        end
    end
end

ECOGmap = [5 4 6 3 7 2 8 1 ;13 12 14 11 15 10 16 9 ;20 21 19 22 18 23 17 24; 28 29 27 30 26 31 25 32]';
for i = 1:4
    for j = 1:8
        Phmap(j,i) = m_ep(ECOGmap(j,i));
        EPhmap(j,i,:) = ep(ECOGmap(j,i),:);
    end
end

yl = max(max(abs(Phmap)));
figure; imagesc(Phmap,[-yl yl]); colorbar;
for i = 1:4
    for j = 1:8
        text(i,j,num2str(ECOGmap(j,i)));
    end
end
figure;
count=1;
ECOGmap2=ECOGmap';

for j = 1:8
    for i = 1:4
        subplot(8,4,count)
        plot(squeeze(EPhmap(j,i,:))); ylim([-yl yl]); title(ECOGmap2(count));
        hold on;
        plot(500,[-yl:.1:yl]);
        count=count+1;
    end
end





