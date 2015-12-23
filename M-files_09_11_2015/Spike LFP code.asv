% FIRST RUN THIS BLOCK, then all the indivdual cells after
% specific data analysi

% block 309 --> spont activity POST STROKE in 3*

close all
clear
TTX = actxcontrol('TTank.X');
TTX.ConnectServer('Local', 'Me');

TTX.OpenTank('DEMOTANK2', 'R');

TTX.SelectBlock('Block-380');



disp('-----------------------------------')

TTX.ParseEvInfoV(0, 0, 1)   % determines channel sample freq% get the IO data from lafayetter
TTX.SetGlobalV('Channel',1) %determine size of channnel data
temp3=TTX.ReadWavesV('LFPs');
size(temp3)
Fs_lfp = TTX.ParseEvInfoV(0, 0, 9)   % determines channel sample freq
%size_lfp=TTX.ParseEvInfoV(0, 0, 1)   % determines channel size
size_lfp=length(temp3)


% normalize all channels, remove REF
chan=1:32;

dec_factor=1;
Fs_lfp=Fs_lfp/dec_factor
for chan_no=1:32
    disp(chan_no)
    get_chan=chan(chan_no);
    TTX.SetGlobalV('Channel',get_chan);
    data(chan_no,:)=TTX.ReadWavesV('LFPs');
    %temp=double(temp);
    %data(chan_no,:)=decimate(temp,dec_factor);
    %disp ([chan_no])
end


TTX.ParseEvInfoV(0, 0, 1)   % determines channel sample freq% get the IO data from lafayetter
TTX.SetGlobalV('Channel',1) %determine size of channnel data

% normalize all channels, remove REF
chan=1:32;

for chan_no=1:32;
    
    %TTX.SetGlobalV('Channel',chan_no);
    SetSort1 = TTX.SetUseSortName('290sort');
    TTX.SetFilterWithDescEx('sort=1');
    a=TTX.ReadEventsV('ALL','eNeu',chan_no,1,0.0,0.0,'FILTERED')
    %a = TTX.ReadEventsSimple('eNeu') ;
    disp(chan_no)
    disp(a')
    disp('------------')
    data_sp(chan_no,:)= TTX.ParseEvInfoV(0,10000,6);
    %plot([tstamps; tstamps],[0 1]+chan_no,'k')
end



TTX.CloseTank
TTX.ReleaseServer
close all
save data_block380.mat
disp('done, saves...')

%% shows 8 channels and the spiking

load data_block290.mat

range=9500:13000;
t=range/Fs_lfp;
figure
subplot('Position',[0.05 0.5 0.9 0.45])
%subplot(2,1,1);
n=0;
co=['kkkkkkkk'];
%for chan_no=[1 3 5 7 2 4 6 8 10 12 14 16 9 11 13 15 26 28 30 32 25 27 29 31 17 19 21 23 18 20 22 24]
%for chan_no=[1 3 5 7 2 4 6 8 10 12 14 16 9 11 13 15]
for chan_no=[1 3 5 7 2 4 6 8]
%for chan_no=[1 3 5 7 8]
    temp=data(chan_no,:);
    temp=(temp-mean(temp))./std(temp);
    %co(rem(n,8)+1)
    %plot(t,temp(range)+n*5,co(rem(n,8)+1),'LineWidth',2);hold on
    plot(t,temp(range)+n*5,'Color',[0 0+n*0.12 1 - n*0.12],'LineWidth',2);hold on
    n=n+1;
end
xlim([t(1) t(end)])
%ylim([-650 100])
axis off

subplot('Position',[0.05 0.05 0.9 0.45])

for chan_no=[7 14 18 20 22 23 24 25 27]
%for chan_no=[3]
    tstamps=TimeStamps{chan_no,2};
    %tstamps=data_sp(3,:);
    t2=find(tstamps>t(1));
    t3=find(tstamps>t(end));
    if ~isempty(t2) && ~isempty(t3)
        range2=[t2(1):t3(1)];
        disp([chan_no length(find(tstamps(range2)>0))])
        plot([tstamps(range2); tstamps(range2)],[0 1]+chan_no,'k','LineWidth',2)
        hold on
    end
end
xlim([t(1) t(end)])
ylim([1 33])
axis off


% powerspectrum
figure
e_i=1:10000;

STEP_freq=1;
highestband = 200;
%Parameter definitions for spectrogram calculation.
fs = Fs_lfp; % sampling frequency
ol = 1500; % overlap between segments
len = 2000; %500; %length of segment
l = len - ol;
nfft = 1048; %number of points in fft
nw = 7/2; % Time bandwidth prodcut for pmtm

clear hold_fft
index=1;
for chan_no=[1 3 5 7 2 4 6 8]
%for chan_no=[1:32]
%for chan_no=[26 28 30 32 25 27 29 31]
%for chan_no=[17 19 21 23 18 20 22 24]


    ECOG_CHANNEL=chan_no;
    
   
    tL=data(ECOG_CHANNEL,e_i);
    tL=tL-mean(tL);
    foo = tL;
    clear Xtemp Pxx
    %plot(foo);
    
    %subplot(4,1,2);
    count=1;
    s = len/2 + 1; % The time point at which you are calculating the spectrum
    j = 1; %count
    [s j]
    %This while loop performs the actual computation using pmtm
    while s < length(foo) - ol
        seg = foo(s-len/2:s+len/2);
        [Pxx(:,j), f] = pmtm(seg,nw,nfft,fs);
        j = j + 1;
        s = s + l; % create a new point every l ms ie. every 100ms
        %disp([s s-len/2 s+len/2]')
    end
    %plot(0:1:nfft/2,mean(Pxx'))
    %xlim([0 disp_lim])
    hold_fft(index,:)=mean(Pxx');
    index=index+1;
end

figure
for n=1:size(hold_fft,1)
    subplot(8,1,9-n)
    plot(hold_fft(n,:),'Color',[0 0+n*0.12 1 - n*0.12],'LineWidth',2)
    %plot(hold_fft(index,:),'Color','k')

    xlim([0 40])
    axis off
    %ylim([0 3000])
    hold on
    %pause
end






range=9700:9900;
t=range/Fs_lfp;
figure
subplot('Position',[0.05 0.5 0.9 0.45])
%subplot(2,1,1);
n=0;
co=['kkkkkkkk'];
%for chan_no=[1 3 5 7 2 4 6 8 10 12 14 16 9 11 13 15 26 28 30 32 25 27 29 31 17 19 21 23 18 20 22 24]
%for chan_no=[1 3 5 7 2 4 6 8 10 12 14 16 9 11 13 15]
for chan_no=[1 3 5 7 2 4 6 8]
%for chan_no=[1 3 5 7 8]
    temp=data(chan_no,:);
    temp=(temp-mean(temp))./std(temp);
    %co(rem(n,8)+1)
    %plot(t,temp(range)+n*5,co(rem(n,8)+1),'LineWidth',2);hold on
    plot(t,temp(range)+n*5,'Color',[0.2 0+n*0.12 1 - n*0.12],'LineWidth',2);hold on
    n=n+1;
end
xlim([t(1) t(end)])
%ylim([-650 100])
axis off

subplot('Position',[0.05 0.05 0.9 0.45])

for chan_no=[1 3 5 7 2 4 6 8]
%for chan_no=[3]
    tstamps=data_sp(chan_no,:);
    %tstamps=data_sp(3,:);
    t2=find(tstamps>t(1));
    t3=find(tstamps>t(end));
    if ~isempty(t2) && ~isempty(t3)
        range2=[t2(1):t3(1)];
        disp([chan_no length(find(tstamps(range2)>0))])
        plot([tstamps(range2); tstamps(range2)],[0 1]+chan_no,'k','LineWidth',2)
        hold on
    end
end
xlim([t(1) t(end)])
ylim([1 8])
axis off



