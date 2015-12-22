%Scratch

%% T131 processing pipeline
% Steps used for T131
% 1. Organize blocks by day and by sleep/task
% 2. concatenate blocks into the days that they belong to
% 3. do artifact rejection based on timestamps

clear all; close all;
%% List information about T131
ratID = 'T131';
path_to_data = 'J:\T131 data and analysis\T131 Blocks\T131_Tank_Data_Waveclus';
save_path = 'J:\T131 data and analysis\T131 Blocks\Wait PETHs SL method';
no_channels = 64;

%% List the blocks that belong to each day

% sleep vs task blocks
Sleep_blocks = [2, 9 ,11, 13, 15, 17, 20, 26, 30, 32, 37, 40, 42, 46, 49, 52];
Task_blocks = [7, 10, 12, 14, 16, 19, 25, 28, 31, 33, 34, 39, 41, 45, 47, 51, 53];

% just reaching, no back
%Day1 = [2, 7, 8, 9, 10];
Day = [7,9];
Day2 = [11:14];
Day3 = [12, 16, 17, 19];

% start of reach + back + wait
Day4 = [20, 25, 26, 28];
Day5 = [30:34];
Day6 = [37, 39, 40, 41];
Day7 = [42, 45, 46, 47];
Day8 = [49, 51, 52, 53];

%% Concatenate blocks into the days, do artifact rejection

% load blocks for each day, get first and last timestamps for the block
for block = [7,9];
    
    % load the spike times and waves for the block
    block_name = strcat(path_to_data,'\data_block_',ratID,'_',num2str(block));
    to_concatenate(block).data = load(block_name,'Spike_times','Spike_waves');
    to_concatenate(block).data.Spike_times(:,2:5)=[];
    to_concatenate(block).data.Spike_waves(:,2:5)=[];
    
    % find the first and last timestamp value for the block
    temp_spike_times = [];
    for chan = 1:no_channels
        temp_spike_times = cat(2,temp_spike_times, to_concatenate(block).data.Spike_times{chan});
    end
    
    to_concatenate(block).data.first_timestamp = min(temp_spike_times);
    to_concatenate(block).data.last_timestamp = max(temp_spike_times);
    clear temp_spike_times
    
end

% adjusts all the spike times to be on continuous thread
for block = [7,9]
    block_index = find(Day1,block);
    
    % skip the first block
    if block_index == 1;
        pass
    else
        
        % skip channels with no data
        for chan = 2%1:no_channels
%             if to_concatenate(block).data(1,1).Spike_times(chan) == NaN
%                 pass
%             else
                temp_timestamps = cell2mat(to_concatenate(block).data.Spike_times(chan)) ...
                    + to_concatenate(7).data.last_timestamp;
                to_concatenate(block).data.Spike_times_new(chan,1)=[];
                to_concatenate(block).data.Spike_times_new(chan,1) = temp_timestamps;
            end
        end
    end
end

                
                
                % concatenate blocks for each day and store in new file labelled with day
                % do artifact rejection
                % re-separeate blocks based on timestamps (keep new timestamps)