close all; clear all; clc;
% % THINGS THAT NEED TO BE CHANGED
TankName = 'T111';
numBlocks = 15;
cd ('J:\T111 data and analysis\T111 Blocks')
chan=[1:64]; %number of channels


% % CODE FROM HERE DOWN DOES NOT NEED TO BE CHANGED
for n = 1:numBlocks;
   Block_Name = sprintf('Block-%d',n);
   name = sprintf('data_block_%s_%d',TankName,n);

   clearvars -except TankName numBlocks n Block_Name name chan

% Block_Name='Block-4'
% SortID='TankSort'
% filename='data_spikes_lfps_wav_'

% name = 'data_block_T104_4';



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

disp('Tank and Block Selected -----------------------------------')

% %Read All Spikes
% eventnumber=2000000;
% for chan_no=[1:32]
%     TTX.SetUseSortName(SortID);
%     for i = 1:3
%         TTX.ResetFilters
%         
%         TTX.SetFilterWithDescEx(['SORT=' num2str(i)]);
%         N{chan_no,i+1} = TTX.ReadEventsV(eventnumber, 'eNeu', chan_no, 0, 0.0, 0.0, 'FILTERED');
%         disp([chan_no])
%         disp([])
%         TimeStamps{chan_no,i+1}=TTX.ParseEvInfoV(0, N{chan_no,i+1}, 6);
%         Waves{chan_no,i+1}=TTX.ParseEvV(0, N{chan_no,i+1});
%         Sorts{chan_no,i+1}=TTX.ParseEvInfoV(0, N{chan_no,i+1}, 5);
%         %Fs_eNeu=TTX.ParseEvInfoV(0, 0, 9);
%     end
% end

% % LFP
TTX.ParseEvInfoV(0, 0, 1);   % determines channel sample freq% get the IO data from lafayetter
TTX.SetGlobalV('Channel',10); %determine size of channnel data
temp3=TTX.ReadWavesV('LFPs');
size(temp3);
Fs_lfp = TTX.ParseEvInfoV(0, 0, 9);   % determines channel sample freq
%size_lfp=TTX.ParseEvInfoV(0, 0, 1)   % determines channel size
size_lfp=length(temp3);

% % temp3=TTX.ReadWavesV('SPK1');
% % Fs_SPK = TTX.ParseEvInfoV(0, 0, 9)


% normalize all channels, remove REF
% chan=[1:32];
remove_chan=[];
chan=setdiff(chan,remove_chan);

dec_factor=1;
Fs_lfp=Fs_lfp/dec_factor
% for chan_no=1:32;
for chan_no=1:length(chan);
    disp(chan_no)
    get_chan=chan(chan_no);
    TTX.SetGlobalV('Channel',get_chan);
    temp=TTX.ReadWavesV('LFPs');
    temp=double(temp);
    data(chan_no,:)=decimate(temp,dec_factor);
    disp ([chan_no])
end

% % WAVE
TTX.ParseEvInfoV(0, 0, 1)   % determines channel sample freq% get the IO data from lafayetter
TTX.SetGlobalV('Channel',1) %determine size of channnel data
temp3=TTX.ReadWavesV('Wave');
size(temp3)
Fs_wave = TTX.ParseEvInfoV(0, 0, 9)   % determines channel sample freq
%size_lfp=TTX.ParseEvInfoV(0, 0, 1)   % determines channel size
size_lfp=length(temp3);
dec_factor=1;
Fs_wave=Fs_wave/dec_factor
for chan_no=1;
    disp(chan_no)
    get_chan=chan(chan_no);
    TTX.SetGlobalV('Channel',get_chan);
    temp=TTX.ReadWavesV('Waves');
    temp=double(temp);
    wave(chan_no,:)=decimate(temp,dec_factor);
    disp ([chan_no])
end

% % % EMG
% TTX.ParseEvInfoV(0, 0, 1)   % determines channel sample freq% get the IO data from lafayetter
% TTX.SetGlobalV('Channel',1) %determine size of channnel data
% temp3=TTX.ReadWavesV('EMGs');
% size(temp3)
% Fs_sEMG = TTX.ParseEvInfoV(0, 0, 9)   % determines channel sample freq
% %size_lfp=TTX.ParseEvInfoV(0, 0, 1)   % determines channel size
% size_lfp=length(temp3);
% dec_factor=1;
% Fs_sEMG=Fs_wave/dec_factor
% for chan_no=1;
%     disp(chan_no)
%     get_chan=chan(chan_no);
%     TTX.SetGlobalV('Channel',get_chan);
%     temp=TTX.ReadWavesV('EMGs');
%     temp=double(temp);
%     sEMG(chan_no,:)=decimate(temp,dec_factor);
%     disp ([chan_no])
% end
% 
% % % RAW EMG?
% TTX.ParseEvInfoV(0, 0, 1)   % determines channel sample freq% get the IO data from lafayetter
% TTX.SetGlobalV('Channel',1) %determine size of channnel data
% temp3=TTX.ReadWavesV('rEMG');
% size(temp3)
% Fs_rEMG = TTX.ParseEvInfoV(0, 0, 9)   % determines channel sample freq
% %size_lfp=TTX.ParseEvInfoV(0, 0, 1)   % determines channel size
% size_lfp=length(temp3);
% dec_factor=1;
% Fs_sEMG=Fs_wave/dec_factor
% for chan_no=[13 15]; %WHY ARE THESE PROBES SPECIAL?
%     disp(chan_no)
%     get_chan=chan(chan_no);
%     TTX.SetGlobalV('Channel',get_chan);
%     temp=TTX.ReadWavesV('rEMG');
%     temp=double(temp);
%     rEMG(chan_no,:)=decimate(temp,dec_factor);
%     disp ([chan_no])
% end
% for chan_no=1;
%     disp(chan_no)
%     get_chan=chan(chan_no);
%     TTX.SetGlobalV('Channel',get_chan);
%     temp=TTX.ReadWavesV('SPK1');
%     temp=double(temp);
%     SPK1(chan_no,:)=decimate(temp,dec_factor);
%     disp ([chan_no])
% end

TTX.CloseTank
TTX.ReleaseServer
close all

%saving raw data
% save (['data_block_T101_1'])
% save ([name])

save([name], '-v7.3')
% save([name])
end







%    %%  get trial data for R18 delayed lever press
% % Get two and three pulses from wave
% 
% clear 
% close all
% load data_block_166.mat
% %block=1:500000;
% length_to_analyze=length(data);
% 
% % load data_block260.mat
% 
% block=1:length_to_analyze;
% 
% data=data(:,block);
% 
% %%
% %temp2=temp2(block);
% %lever1=lever1(block);
% %Slever2=lever2(block);
% 
% % find the trial data (ALWAYS RUN PRIOR TO BELOW)
% figure
% temp3=wave(1,block)>2;
% plot(temp3)
% hold on
% start=diff(temp3)>0.5;
% [start]=find(start==1);
% 
% %hold_index again
% 
% two_pulses=diff(start);
% two_pulses2=find(two_pulses<40);
% 
% %only look for two pulse
% hold_index=[];
% 
% for n=2:(length(two_pulses2)-2)
%     temp1=two_pulses(two_pulses2(n)+1);
%     temp2=two_pulses(two_pulses2(n)-1);
%     if (temp1  > 40) && (temp2 > 40)
%         hold_index=[hold_index (two_pulses2(n))];
%     end
% end
% 
% plot(start(hold_index),[1],'rx')
% Reward=start(hold_index);
% 
% 
% %only look for three pulse
% three_pulses=diff(diff(start));
% three_pulses2=find(three_pulses<10 & three_pulses>-10);
% hold_index1=[];
% for n=2:(length(three_pulses2)-1)
%     hold_index1=[hold_index1 (three_pulses2(n))];
% end
% plot(start(hold_index1),[1],'kx')
% Reach=start(hold_index1);
% 
% for i=1:length(Reward)
%     Reach_ind=find(Reach>Reward(i) & Reach<Reward(i)+10000, 1,'last');
%     ReachN(:,i)=Reach(Reach_ind)
% end
% plot(ReachN,[1],'yx')
% 
% %only look for five pulse
% five_pulses=diff(diff(diff(diff(start))));
% five_pulses2=find(five_pulses<10 & five_pulses>-10);
% hold_index2=[];
% for n=1:length(five_pulses2)
%     hold_index2=[hold_index2 (five_pulses2(n))];
% end
% plot(start(hold_index2),[1],'co')
% Trial=start(hold_index2);
% 
% for i=1:length(Reward)
%     Trial_ind=find(Trial<Reward(i) & Trial<(Reward(i)-8000), 1,'first');
%     TrialN(:,i)=Trial(Trial_ind)
% end
% plot(TrialN,[1],'yo')
% 
% 
% %Reach=start(hold_index1([2 3 4 7 9 10 11 12 13 14 16 18 22 24]));
% 
% %%
% % saving 'rx' and 'gx'
% 
% saveas (gcf,['Mat_files/rx_kx_figs/wavepulse_260.pdf'])
% 
% 
% %%
% % lever1=wave(2,block);
% % lever2=wave(3,block);
% 
% %decimates the data
% dec_factor=1;
% Fs_wave=Fs_wave/dec_factor
% % lever1=decimate(lever1,dec_factor);
% % lever2=decimate(lever2,dec_factor);
% 
% strobe=wave(1,block);
% strobe=decimate(strobe,dec_factor);
% Reward=round(Reward/dec_factor);
% 
% Reach=round(Reach/dec_factor);
% 
% % %only trials in the block
% % temp_ind1=find(Reward > block(1));
% % temp_ind2=find(Reward < block(end));
% % Reward=Reward(intersect(temp_ind1,temp_ind2));
% % Reward=Reward-block(1);
% 
% 
% 
% % % normalize all channels, remove REF
% % keep_chan=1:32;
% % for n = 1:length(keep_chan)
% %     chan_n=keep_chan(n);
% %     data(chan_n,:)=(data(chan_n,:)-mean(data(chan_n,:)))/std(data(chan_n,:));
% %     disp(n)
% % end
% % 
% % 
% % disp('CAR of LFPs TAKEN!!!!)')
% % CAR = mean(data(:,:));
% % % remove REF
% % % REF = repmat (CAR,32,1);
% % % data=data-REF;
% %%
% 
% plot(data(1,:));hold on; plot(wave(1,:),'c'); hold on; plot(strobe(1,:),'r-'); hold off
% length(strobe)
% length(wave)
% length(data)
% 
% 
% 
% %%
% 
% 
% 
% %
% save (['Mat_files/data_pull/data_spikes_lfps_wav_223']) % <==== CHANGE THIS NAME!!!!!!!!!!!!!!!! OR YOU OVERWRITE!!!
% 
