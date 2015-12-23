% FIRST RUN THIS BLOCK, then all the indivdual cells after
% specific data analysi

close all
clear
TTX = actxcontrol('TTank.X');
TTX.ConnectServer('Local', 'Me');

TTX.OpenTank('DemoTank2', 'R');

%TTX.SelectBlock('Block-111');
TTX.SelectBlock('Block-290');



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
    temp=TTX.ReadWavesV('LFPs');
    temp=double(temp);
    data(chan_no,:)=decimate(temp,dec_factor);
    %disp ([chan_no])
end


%TTX.SelectBlock('Block-111');
TTX.ParseEvInfoV(0, 0, 1)   % determines channel sample freq% get the IO data from lafayetter
TTX.SetGlobalV('Channel',1) %determine size of channnel data

% normalize all channels, remove REF
chan=1:32;

for chan_no=1:32;
    TTX.SetGlobalV('Channel',chan_no);
    a = TTX.ReadEventsSimple('eNeu') ;
    disp(chan_no)
    disp(a')
    disp('------------')
    data_sp(chan_no,:)= TTX.ParseEvInfoV(0,10000,6);
    %plot([tstamps; tstamps],[0 1]+chan_no,'k')
end



TTX.CloseTank
TTX.ReleaseServer
close all

%save data_block130.mat
disp('done, saves...')

%save 'datablock_290.mat'

%%
load 'datablock_290.mat'

%% %% shows 8 channels and the spiking


range=20000:25000;
t=range/Fs_lfp;
figure
subplot(2,1,1);
n=0;
co=['rrrkkkkk'];
%for chan_no=[1 3 5 7 2 4 6 8 10 12 14 16 9 11 13 15 26 28 30 32 25 27 29 31 17 19 21 23 18 20 22 24]
%for chan_no=[1 3 5 7 2 4 6 8 10 12 14 16 9 11 13 15]
for chan_no=[1 3 5 7 2 4 6 8]
%for chan_no=[1 3 5]
    temp=data(chan_no,:);
    temp=(temp-mean(temp))./std(temp);
    co(rem(n,8)+1)
    plot(t,temp(range)+n*5,co(rem(n,8)+1),'LineWidth',2);hold on
    n=n+1;
end
xlim([t(1) t(end)])
%ylim([-650 100])
axis off

subplot(2,1,2);

for chan_no=[1:25,27:32]
%for chan_no=[3]
    tstamps=data_sp(chan_no,:);
    %tstamps=data_sp(3,:);
    t2=find(tstamps>t(1));
    t3=find(tstamps>t(end));
    range2=[t2(1):t3(1)];
    disp([chan_no length(find(tstamps(range2)>0))])
    plot([tstamps(range2); tstamps(range2)],[0 1]+chan_no,'k','LineWidth',2)
    hold on
end
xlim([t(1) t(end)])
%ylim([0 5])
axis off

%% spike triggerred avergage
% fs_lfp=1017.3 Hz
figure

sp_chan=9;
lfp_chan=[1 3 5 7 2 4 6 8];;
time_before=250;
total_time=500;
episodes=10;
   
range=20000:25000;

    
for index=1:length(lfp_chan)
    t=range/Fs_lfp;
    
    tstamps=data_sp(sp_chan,:);
    t_data=zeros(episodes,total_time);
    
    stamp_t=tstamps(1000:1000+episodes);
    stamp_t=round(stamp_t*Fs_lfp)
    for n=1:episodes
        t_data(n,:)=data(lfp_chan(index),(stamp_t(n)-time_before):(stamp_t(n)+(total_time-time_before-1)));
    end
    subplot(length(lfp_chan),1,index)
    m=mean(t_data)';
    m=m-mean(m);
    plot(m)
    %axis off
end


seed_chan=1;
range=20000:50000;
hold_R=zeros(length(lfp_chan),1);
d1= data(seed_chan,range);
for index=1:length(lfp_chan)
    d2= data(lfp_chan(index),range);
    x=corrcoef(d1,d2);
    hold_R(index)=x(1,2);
end
figure;
plot(hold_R)

seed_chan=1;
range=20000:50000;
hold_R=zeros(length(lfp_chan),1);
d1= data(seed_chan,range);
for index=1:length(lfp_chan)
    d2= data(lfp_chan(index),range);
    x=corrcoef(d1,d2);
    hold_R(index)=x(1,2);
end    
hold on
plot(hold_R(8:-1:1),'r')
  

%% spike train for channel 3

for chan_no=[3]
    tstamps=data_sp(chan_no,:);
    %tstamps=data_sp(3,:);
    t2=find(tstamps>t(1));
    t3=find(tstamps>t(end));
    range2=[t2(1):t3(1)];
    disp([chan_no length(find(tstamps(range2)>0))])
    plot([tstamps(range2); tstamps(range2)],[0 1]+chan_no,'k','LineWidth',2)
    hold on
end
xlim([t(1) t(end)])
ylim([0 5])
axis off







%%  Compare the power spectrum of the channels

load 'datablock_290.mat'
figure
e_i=20000:30000;

STEP_freq=2;
highestband = 200;
%Parameter definitions for spectrogram calculation.
fs = Fs_lfp; % sampling frequency
ol = 1500; % overlap between segments
len = 2000; %500; %length of segment
l = len - ol;
nfft = 1048; %number of points in fft
nw = 7/2; % Time bandwidth prodcut for pmtm


index=1;
for chan_no=[1 3 5 7 2 4 6 8]
%for chan_no=[10 12 14 16 9 11 13 15]
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


for index=1:size(hold_fft,1)
    plot(hold_fft(index,:),'Color',[0 0.1+index*0.1 0])
    xlim([0 30])
    ylim([0 3000])
    hold on
    %pause
end





%% Multitaper analysis of CHANNEL 3
figure
disp_lim=50;

ECOG_CHANNEL=3;
e_i=20000:30000;
tL=data(ECOG_CHANNEL,e_i);
tL=tL-mean(tL);


STEP_freq=3;
highestband = 200;
%Parameter definitions for spectrogram calculation.
fs = Fs_lfp; % sampling frequency
ol = 1500; % overlap between segments
len = 2000; %500; %length of segment
l = len - ol;
nfft = 1048; %number of points in fft
nw = 7/2; % Time bandwidth prodcut for pmtm


subplot(4,1,1);


foo = tL;
clear Xtemp Pxx
plot(foo);

subplot(4,1,2);
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
plot(0:1:nfft/2,mean(Pxx'))
xlim([0 disp_lim])


%This loop averages the power every 6 bands (i.e. over ~10Hz), and is saved as Xtemp
for i = 1:STEP_freq:highestband
    %Xtemp(count, :) = mean(10*log10(Pxx(i:i+STEP_freq,:)));
    Xtemp(count, :) = mean((Pxx(i:i+STEP_freq,:)));
    
    count = count + 1;
end
subplot(4,1,3)
temp=mean(Xtemp');
plot_x=1:STEP_freq:highestband;
plot(plot_x,temp(1:length(plot_x)))
xlim([0 2*disp_lim])



subplot(4,1,4);
Fs = Fs_lfp                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 20000;                     % Length of signal
t = (0:L-1)*T;                % Time vector
start_t=10000;
range=start_t:start_t+L-1;
hold on
win=1;
y=tL;
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
NFFT=1048
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
%Y=smooth(Y,win);

plot(f,2*abs(Y(1:NFFT/2+1)),'r','LineWidth',2)
hold on
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
xlim([0 disp_lim])


%% multitaper version of spectral analysis


figure
disp_lim=50;

ECOG_CHANNEL=3;
e_i=20000:30000;
tL=data(ECOG_CHANNEL,e_i);
tL=tL-mean(tL);


STEP_freq=3;
highestband = 200;
%Parameter definitions for spectrogram calculation.
fs = Fs_lfp; % sampling frequency
ol = 1500; % overlap between segments
len = 2000; %500; %length of segment
l = len - ol;
nfft = 1048; %number of points in fft
nw = 7/2; % Time bandwidth prodcut for pmtm


subplot(4,1,1);


foo = tL;
clear Xtemp Pxx
plot(foo);

subplot(4,1,2);
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
plot(0:1:nfft/2,mean(Pxx'))
xlim([0 disp_lim])


%This loop averages the power every 6 bands (i.e. over ~10Hz), and is saved as Xtemp
for i = 1:STEP_freq:highestband
    %Xtemp(count, :) = mean(10*log10(Pxx(i:i+STEP_freq,:)));
    Xtemp(count, :) = mean((Pxx(i:i+STEP_freq,:)));
    
    count = count + 1;
end
subplot(4,1,3)
temp=mean(Xtemp');
plot_x=1:STEP_freq:highestband;
plot(plot_x,temp(1:length(plot_x)))
xlim([0 2*disp_lim])



subplot(4,1,4);
Fs = Fs_lfp                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 20000;                     % Length of signal
t = (0:L-1)*T;                % Time vector
start_t=10000;
range=start_t:start_t+L-1;
hold on
win=1;
y=tL;
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
NFFT=1048
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
%Y=smooth(Y,win);

plot(f,2*abs(Y(1:NFFT/2+1)),'r','LineWidth',2)
hold on
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
xlim([0 disp_lim])



%% show all channels --> view the LFP data


c=['r' 'k' 'r' 'k']

%keep_chan=1:32;

figure(1)
set(gcf,'Position',[1100 9 863 1066]);


%tot=length(keep_chan);
disp=8000:10000;
%tot=10


n_curves=32;
px1=0.1; px2=0.9;
pdx=0.2;
py1=0.1; py2=0.95;
px=[px1:pdx:px2];

pdyA=(py2-py1)/32;
pyA=[py1:pdyA:py2];
pdyB=(py2-py1)/32;
pyB=[py1:pdyB:py2];

disp1=1;
disp2=1500;
step=2000;
for disp2=step:step:50000
    [disp1 disp2]
    disp=disp1:disp2;
    disp1=disp2;
    figure(1)
    for n=1:32 %shanks 1 - 4
        %for n2=1:8 %8 sites
            %[n seq(n)]
            %chan_n=seq(n);
            n
            temp_d=data(n,:);
            subplot('Position',[px1 pyA(n) 0.8 pdyA]);
            %subplot(tot,2,2*n-1);
            plot(temp_d(disp),'k');
            %hold on
            %plot(CAR(disp),'k')
            %temp_d=data(chan_n,:)-CAR;
            %plot(temp_d(disp),'r','LineWidth',2);
            axis off
            %hold off
            %         subplot(tot,2,1);
            %         subplot(tot,2,2*n);
            %         plot(temp_d(disp),'k');
            %         axis off
        %end
    end
    %subplot(tot,1,1)
    %title('k=ref,b=sig, r=minus ref')
 
    
    pause

end

