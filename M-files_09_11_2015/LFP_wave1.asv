%R18
% block R18 -- look at 60Hz


%%  get data block 55/56 and create DECIMATED data
close all
clear
TTX = actxcontrol('TTank.X');
TTX.ConnectServer('Local', 'Me');

TTX.OpenTank('DEMOTANK2', 'R');

%TTX.SelectBlock('Block-111');
TTX.SelectBlock('Block-260');



disp('-----------------------------------')

TTX.ParseEvInfoV(0, 0, 1)   % determines channel sample freq% get the IO data from lafayetter
TTX.SetGlobalV('Channel',10) %determine size of channnel data
temp3=TTX.ReadWavesV('LFPs');
size(temp3)
Fs_lfp = TTX.ParseEvInfoV(0, 0, 9)   % determines channel sample freq
%size_lfp=TTX.ParseEvInfoV(0, 0, 1)   % determines channel size
size_lfp=length(temp3);


% normalize all channels, remove REF
chan=1:32;
remove_chan=[];
chan=setdiff(chan,remove_chan);

dec_factor=2;
Fs_lfp=Fs_lfp/dec_factor
for chan_no=1:32;
    disp(chan_no)
    get_chan=chan(chan_no);
    TTX.SetGlobalV('Channel',get_chan);
    temp=TTX.ReadWavesV('LFPs');
    temp=double(temp);
    data(chan_no,:)=decimate(temp,dec_factor);
    disp ([chan_no])
end


TTX.ParseEvInfoV(0, 0, 1)   % determines channel sample freq% get the IO data from lafayetter
TTX.SetGlobalV('Channel',1) %determine size of channnel data
temp3=TTX.ReadWavesV('Wave');
size(temp3)
Fs_wave = TTX.ParseEvInfoV(0, 0, 9)   % determines channel sample freq
%size_lfp=TTX.ParseEvInfoV(0, 0, 1)   % determines channel size
size_lfp=length(temp3);
dec_factor=1;
Fs_wave=Fs_wave/dec_factor
for chan_no=1:3;
    disp(chan_no)
    get_chan=chan(chan_no);
    TTX.SetGlobalV('Channel',get_chan);
    temp=TTX.ReadWavesV('Waves');
    temp=double(temp);
    wave(chan_no,:)=decimate(temp,dec_factor);
    disp ([chan_no])
end


TTX.CloseTank
TTX.ReleaseServer
close all
%%

save data_block260.mat


%%  get trial data for R18 delayed lever press
% ONLY GET TWO PULSES (REGARDLESS OF REWARD)

clear
%load data_block111.mat
%block=1:500000;

load data_block260.mat

block=1:400000;

data=data(:,block);

%%
%temp2=temp2(block);
%lever1=lever1(block);
%Slever2=lever2(block);

% find the trial data (ALWAYS RUN PRIOR TO BELOW)
figure
temp3=wave(1,block)>2;
plot(temp3)
hold on
start=diff(temp3)>0.5;
[start]=find(start==1);

%hold_index again

two_pulses=diff(start);
two_pulses2=find(two_pulses<40);

three_pulses=diff(diff(start));
three_pulses2=find(three_pulses<10 & three_pulses>-10);

temp3=wave(1,block)>2;
plot(temp3)
hold on
start=diff(temp3)>0.5;
[start]=find(start==1);

two_pulses=diff(start);
two_pulses2=find(two_pulses<40);

%only look for two pulse
hold_index=[];

for n=2:(length(two_pulses2)-2)
    temp1=two_pulses(two_pulses2(n)+1);
    temp2=two_pulses(two_pulses2(n)-1);
    if (temp1  > 40) && (temp2 > 40)
        hold_index=[hold_index (two_pulses2(n))];
    end
end

plot(start(hold_index),[1],'rx')
Reward=start(hold_index);




%only look for three pulse
hold_index1=[];

for n=2:(length(three_pulses2)-1)
    hold_index1=[hold_index1 (three_pulses2(n))];
 end

plot(start(hold_index1),[1],'kx')
Reach=start(hold_index1);

% for i=1:length(Reward)-1
%     Reach_ind=find(Reach>Reward(i) & Reach<Reward(i)+10000, 1,'last');
%     ReachN(:,i)=Reach(Reach_ind)
%     disp(i)
% end
% plot(start(hold_index),[1],'rx')
% Reward=start(hold_index);
% plot(start(hold_index1),[1],'kx')
% Reach=start(hold_index1);


%Reach=start(hold_index1([2 3 4 7 9 10 11 12 13 14 16 18 22 24]));

%%
% lever1=wave(2,block);
% lever2=wave(3,block);

%decimates the data
dec_factor=2;
Fs_wave=Fs_wave/dec_factor
% lever1=decimate(lever1,dec_factor);
% lever2=decimate(lever2,dec_factor);

strobe=wave(1,block);
strobe=decimate(strobe,dec_factor);
Reward=round(Reward/dec_factor);

Reach=round(Reach/dec_factor);

% %only trials in the block
% temp_ind1=find(Reward > block(1));
% temp_ind2=find(Reward < block(end));
% Reward=Reward(intersect(temp_ind1,temp_ind2));
% Reward=Reward-block(1);



% normalize all channels, remove REF
keep_chan=1:32;
for n = 1:length(keep_chan)
    chan_n=keep_chan(n);
    data(chan_n,:)=(data(chan_n,:)-mean(data(chan_n,:)))/std(data(chan_n,:));
    disp(n)
end


disp('CAR of LFPs TAKEN!!!!)')
CAR = mean(data(:,:));
% remove REF
REF = repmat (CAR,32,1);
data=data-REF;



%% look at time to R lever press

figure
trials_NO=length(Reward);
block_len=2000;
before_zero=1800;
for n=1:trials_NO
    subplot(2,1,1);
    temp=lever1(Reward(n)-before_zero:Reward(n)+block_len-before_zero);
    plot(temp);
    hold on
    temp=lever2(Reward(n)-before_zero:Reward(n)+block_len-before_zero);
    plot(temp,'r')
        temp=strobe(Reward(n)-before_zero:Reward(n)+block_len-before_zero);
    plot(temp,'c')
    
    a=axis;
    line([before_zero before_zero],a(3:4),'Color','g')
    hold off
    subplot(2,1,2)
    e_i=round([Reward(n)-before_zero:Reward(n)+block_len-before_zero]);
    plot(data(1,e_i));
    hold on;
     %   plot(data_REF(1,e_i),'r');
    hold off;
    pause
end





%%



%channels ==? 6,5

trials_NO=length(Reward)
block_len=3000;
before_zero=500;

ECOG_CHANNEL=4;

n=Fs_lfp/2;
f_lo=10;
f_hi=45;
[b,a]=butter(6,[f_lo/n,f_hi/n]);
%[b,a]=butter(6,[f_hi/n],'low');
data(ECOG_CHANNEL,:)=(filter(b,a,data(ECOG_CHANNEL,:))); 

figure
STEP_freq=1;
highestband = 130;
%wind = [-1000:1000];


%Parameter definitions for spectrogram calculation.
fs = Fs_lfp; % sampling frequency
ol = 190; % overlap between segments
len = 200; %500; %length of segment
l = len - ol;
nfft = 512; %number of points in fft
nw = 5/2; % Time bandwidth prodcut for pmtm
clear Pxx
%STEP_freq=1;
%highestband = 150;
%temp_wind_R=repmat(wind,length(ind_R),1);
%temp_wind_L=repmat(wind,length(ind_L),1);

for n=1:trials_NO
    %tR=data_R(n,:,:);
    %t2R=reshape(tR,size(temp_wind_R));
    %tL=data_L(n,:,:);
    %t2L=reshape(tL,size(temp_wind_L));
    
    e_i=round([Reward(n)-before_zero:Reward(n)+block_len-before_zero]);
    tL=data(ECOG_CHANNEL,e_i);
    
    temp1=lever1(Reward(n)-before_zero:Reward(n)+block_len-before_zero);
    temp2=lever2(Reward(n)-before_zero:Reward(n)+block_len-before_zero);
    temp3=strobe(Reward(n)-before_zero:Reward(n)+block_len-before_zero);
        %temp4=MOVE(R_light_ON(n)-before_zero:R_light_ON(n)+block_len-before_zero);


    subplot(4,1,1);
    
    
    plot((temp1-mean(temp1))/max(temp1),'k');
    hold on;
    plot((temp2-mean(temp2))/max(temp2)+0.2,'b');

    plot((temp3-mean(temp3))/max(temp3)+0.4,'c');
    %plot(temp4,'g')

    a=axis;
    line([before_zero before_zero],[-0.25 1],'Color','r','LineWidth',1);

    hold off
    xlim([0 block_len]);
    
    foo = tL;
    clear Xtemp Pxx
    subplot(4,1,2);
    plot(foo);
    xlim([0 block_len]);
    
    
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
    subplot(4,1,4);
    plot(0:1:nfft/2,mean(Pxx'))
    
    %This loop averages the power every 6 bands (i.e. over ~10Hz), and is saved as Xtemp
    for i = 1:STEP_freq:highestband
        Xtemp(count, :) = mean(10*log10(Pxx(i:i+5,:)));
        count = count + 1;
    end
    temp=mean(Xtemp');
    plot_x=1:STEP_freq:highestband;
    plot(plot_x,temp(1:length(plot_x)))
    
    subplot(4,1,3);
    surface(Xtemp);
    max_val=max(max(Xtemp));
    %shading interp
    shading flat

    hold off
    set(gca,'YTick',[0:highestband/STEP_freq/4:highestband/STEP_freq])    
    set(gca,'YTickLabel',[0:highestband/4:highestband])
    xlim([1 size(Xtemp,2)]);
    
    pause;
    plot(1,1);
end

%% looking at spikes

trials_NO=length(Reach);
block_len=4000;
before_zero=2000;
range=block;




%decimates the data
dec_factor=2;
Fs_wave=Fs_wave/dec_factor


strobe=wave(1,block);
strobe=decimate(strobe,dec_factor);
Reward=round(Reward/dec_factor);

Reach=round(Reach/dec_factor);

% %only trials in the block
% temp_ind1=find(Reward > block(1));
% temp_ind2=find(Reward < block(end));
% Reward=Reward(intersect(temp_ind1,temp_ind2));
% Reward=Reward-block(1);



% % normalize all channels, remove REF
% keep_chan=1:32;
% for n = 1:length(keep_chan)
%     chan_n=keep_chan(n);
%     data(chan_n,:)=(data(chan_n,:)-mean(data(chan_n,:)))/std(data(chan_n,:));
%     disp(n)
% end
% 
% 
% disp('CAR of LFPs TAKEN!!!!)')
% CAR = mean(data(:,:));
% % remove REF
% REF = repmat (CAR,32,1);
% data=data-REF;



%% look at time to R lever press

%figure
trials_NO=length(Reach);
block_len=4000;
before_zero=2000;
t=[(before_zero/Fs_lfp):(block_len-before_zero/Fs_lfp)];
for n=1:trials_NO
    figure(n)
    %file
    subplot(3,1,1);
%     temp=lever1(Reward(n)-before_zero:Reward(n)+block_len-before_zero);
%     plot(temp);
%     hold on
%     temp=lever2(Reward(n)-before_zero:Reward(n)+block_len-before_zero);
%     plot(temp,'r')
        temp=strobe(Reach(n)-before_zero:Reach(n)+block_len-before_zero);
    plot(temp,'c')
        a=axis;
    line([before_zero before_zero],a(3:4),'Color','g')
    hold off
    subplot(3,1,2)
    e_i=round([Reach(n)-before_zero:Reach(n)+block_len-before_zero]);
    plot(data(8,e_i));
%     hold on;
%    
%      %   plot(data_REF(1,e_i),'r');
%     hold off;
   
    tstamps=TimeStamps{8,2};
    t2=find(tstamps>t(1));
    t3=find(tstamps>t(end));
    if ~isempty(t2) && ~isempty(t3)
        range2=[t2(1):t3(1)]; 
        subplot (3,1,3)
        hist(tstamps(range2), 30);
    
    %pause
end





%%



%channels ==? 6,5

trials_NO=length(Reach)
block_len=5000;
before_zero=2000;

ECOG_CHANNEL=4;

n=Fs_lfp/2;
f_lo=100;
f_hi=300;
[b,a]=butter(6,[f_lo/n,1]);
%[b,a]=butter(6,[f_hi/n],'low');
data(ECOG_CHANNEL,:)=(filter(b,a,data(ECOG_CHANNEL,:))); 

figure
STEP_freq=1;
highestband = 130;
%wind = [-1000:1000];


%Parameter definitions for spectrogram calculation.
fs = Fs_lfp; % sampling frequency
ol = 190; % overlap between segments
len = 200; %500; %length of segment
l = len - ol;
nfft = 512; %number of points in fft
nw = 5/2; % Time bandwidth prodcut for pmtm
clear Pxx
%STEP_freq=1;
%highestband = 150;
%temp_wind_R=repmat(wind,length(ind_R),1);
%temp_wind_L=repmat(wind,length(ind_L),1);

for n=1:trials_NO
    %tR=data_R(n,:,:);
    %t2R=reshape(tR,size(temp_wind_R));
    %tL=data_L(n,:,:);
    %t2L=reshape(tL,size(temp_wind_L));
    
    e_i=round([Reach(n)-before_zero:Reach(n)+block_len-before_zero]);
    tL=data(ECOG_CHANNEL,e_i);
    
%     temp1=lever1(Reach(n)-before_zero:Reach(n)+block_len-before_zero);
%     temp2=lever2(Reach(n)-before_zero:Reach(n)+block_len-before_zero);
    temp3=strobe(Reach(n)-before_zero:Reach(n)+block_len-before_zero);
        %temp4=MOVE(R_light_ON(n)-before_zero:R_light_ON(n)+block_len-before_zero);


    subplot(4,1,1);
    
    
%     plot((temp1-mean(temp1))/max(temp1),'k');
%     hold on;
%     plot((temp2-mean(temp2))/max(temp2)+0.2,'b');

    plot((temp3-mean(temp3))/max(temp3)+0.4,'c');
    %plot(temp4,'g')

    a=axis;
    line([before_zero before_zero],[-0.25 1],'Color','r','LineWidth',1);

    hold off
    xlim([0 block_len]);
    
    foo = tL;
    clear Xtemp Pxx
    subplot(4,1,2);
    plot(foo);
    xlim([0 block_len]);
    
    
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
    subplot(4,1,4);
    plot(0:1:nfft/2,mean(Pxx'))
    
    %This loop averages the power every 6 bands (i.e. over ~10Hz), and is saved as Xtemp
    for i = 1:STEP_freq:highestband
        Xtemp(count, :) = mean(10*log10(Pxx(i:i+5,:)));
        count = count + 1;
    end
    temp=mean(Xtemp');
    plot_x=1:STEP_freq:highestband;
    plot(plot_x,temp(1:length(plot_x)))
    
    subplot(4,1,3);
    surface(Xtemp);
    max_val=max(max(Xtemp));
    %shading interp
    shading flat

    hold off
    set(gca,'YTick',[0:highestband/STEP_freq/4:highestband/STEP_freq])    
    set(gca,'YTickLabel',[0:highestband/4:highestband])
    xlim([1 size(Xtemp,2)]);
    
    pause;
    plot(1,1);
end

