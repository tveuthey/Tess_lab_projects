% function Tanks2Matlab_SL(tank_name, tank_path, save_path, channels, down_samp)
% Takes in TDTtank data and converts it to Matlab variables used in UMS
%
% INPUT
% TDT tank
%
% OUTPUT
% LFP data (channels x data)
% LFP sampling frequency
% wave channel
% Spike times and Spike waves IGNORING SORT CODES
% downsamples spike data (pNeu)

%%%---Update if run as script---%%%
tank_name = 'T131';
tank_path = 'J:\T131 data and analysis\T131 Blocks\'; %this is where the processed blocks live
save_path = 'T131_Tank_Data_Waveclus'; %this is the folder that will be created for processed blocks
channels = [1:64];
down_samp = 1;
block_path = 'J:\T131 data and analysis\T131\T131\'; 
%in theory, this is where raw blocks live. Does not seem to matter. When
%there were only 48 blocks, num_blocks = 52. Why?
max_number_spikes = 5000000;
%%%-----------------------------%%%

% save current path
current_path = pwd;

% open tank
TT = actxcontrol('TTank.X');
set(gcf, 'visible', 'off');
if TT.ConnectServer('Local', 'Me')~=1
    disp 'Server Error';
end
%comment out to see if can find tank directly
if TT.OpenTank(strcat(tank_path,tank_name), 'R')~=1;
    disp 'Tank Error';
end
% if TT.OpenTank(tank_name, 'R')~=1;
%     disp 'Tank Error';
% end

% set maximum limit of data returned in any one call to the tank server to 1GB 
TT.SetGlobalV('WavesMemLimit', 1024^3);

% determine number of blocks
% num_blocks = numel(dir(block_path));

% cycle through blocks
for n_block=1:num_blocks
    
    % select block
    block_name = sprintf('Block-%d',n_block);
    
    if TT.SelectBlock(block_name)~=1;
        disp 'Block Error'; 
    end;
    
    disp(strcat('----- Block_', int2str(n_block),' Selected -----'));
    
    %%%--------------------------------%%%
    %%%   LFP_data and LFP_samp_freq   %%%
    %%%--------------------------------%%%
    
    % determine size of LFPs and read in channel 1
    TT.SetGlobalV('Channel', 1);
    temp_wave = TT.ReadWavesV('LFPs');

    % create data matrix and store channel 1
    temp_wave = double(temp_wave);

    LFP_data = [temp_wave zeros(length(decimate(temp_wave,down_samp)), length(channels)-1)];
    
    % save sample frequency of LFPs
    LFP_samp_freq = TT.ParseEvInfoV(0, 0, 9);

    % read in and store rest of channels
    for n_channel=2:length(channels)
        TT.SetGlobalV('Channel', n_channel);
        temp_wave = TT.ReadWavesV('LFPs');
        temp_wave = double(temp_wave);
        LFP_data(:,n_channel) = decimate(temp_wave,down_samp);
    end
    
    %%%----------%%%
    %%%   wave   %%%
    %%%----------%%%
    
    % open and store wave data
    TT.SetGlobalV('Channel', 1);
    temp_wave = TT.ReadWavesV('Waves');
    temp_wave = double(temp_wave);
    wave= decimate(temp_wave,down_samp);    
    
    % save sample frequency of Waves
    wave_samp_freq = TT.ParseEvInfoV(0, 0, 9);
    
    %%%---------------------------------%%%
    %%%   Spike_times and Spike_waves   %%%
    %%%---------------------------------%%%

    % read in one channel at a time
    for n_channel=1:length(channels)
 
        % read in one unit at a time (when n_unit = 1 sort codes are ignored)
        for n_unit=1:5
            N{n_channel,n_unit} = TT.ReadEventsV(max_number_spikes, 'eNeu', n_channel, n_unit-1, 0, 0, 'ALL'); %tells it to store all the channels in column1
            Spike_times{n_channel,n_unit}=TT.ParseEvInfoV(0, N{n_channel,n_unit}, 6);
            Spike_waves{n_channel,n_unit}=TT.ParseEvV(0, N{n_channel,n_unit});
            Spike_sorts{n_channel,n_unit}=TT.ParseEvInfoV(0, N{n_channel,n_unit}, 5);
            
            % get rid of garbage when ignoring sort codes
            if (n_unit==1) && (~isnan(Spike_sorts{n_channel,n_unit}(1,1)))
                not_garbage = find(Spike_sorts{n_channel,n_unit}(Spike_sorts{n_channel,n_unit}<5));
                Spike_times{n_channel,n_unit} = Spike_times{n_channel,n_unit}(not_garbage);
                Spike_waves{n_channel,n_unit} = Spike_waves{n_channel,n_unit}(:,not_garbage);
            end
            
        end
    end
    
    %%%---------------------%%%
    %%%   Spike_filt_data   %%%
    %%%---------------------%%%    

    % determine size of pNeu and read in channel 1
    TT.SetGlobalV('Channel', 1);
    temp_wave = TT.ReadWavesV('pNeu');

    % create data matrix and store channel 1
    temp_wave = double(temp_wave);
    Spike_filt_data = [temp_wave zeros(length(decimate(temp_wave,down_samp)), length(channels)-1)];
    
    % save sample frequency of LFPs
    Spike_filt_data_samp_freq = TT.ParseEvInfoV(0, 0, 9);

    % read in and store rest of channels
    for n_channel=2:length(channels)
        TT.SetGlobalV('Channel', n_channel);
        temp_wave = TT.ReadWavesV('pNeu');
        temp_wave = double(temp_wave);
        Spike_filt_data(:,n_channel) = decimate(temp_wave,down_samp);
    end
      
    % save variables in save path 
    % NOT saving: wave_samp_freq, Spike_sorts, Spike_filt_data_samp_freq
    save_name = sprintf('data_block_%s_%d',tank_name,n_block);
    if ~exist(strcat(tank_path,save_path))
        mkdir(strcat(tank_path,save_path));
    end
    cd (strcat(tank_path,save_path))
    save([save_name], 'block_name', 'LFP_data', 'LFP_samp_freq', 'wave',...
        'Spike_times', 'Spike_waves', 'Spike_filt_data',...
        '-v7.3');
    
    clear LFP_data not_garbage Spike_filt_data Spike_waves Spike_times wave
        
end

% close tank
TT.CloseTank;
TT.ReleaseServer;
close all; 

% return to current_path
cd (current_path);
close all; clear all; %clc;

% end

