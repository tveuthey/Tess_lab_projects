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

%% List the blocks that belong to each day

% sleep vs task blocks
Sleep_blocks = [2, 9 ,11, 13, 15, 17, 20, 26, 30, 32, 37, 40, 42, 46, 49, 52];
Task_blocks = [7, 10, 12, 14, 16, 19, 25, 28, 31, 33, 34, 39, 41, 45, 47, 51, 53];

% just reaching, no back
Day1 = [2, 7, 8, 9, 10];
Day2 = [11:14];
Day3 = [12, 16, 17, 19];

% start of reach + back + wait
Day4 = [20, 25, 26, 28];
Day5 = [30:34];
Day6 = [37, 39, 40, 41];
Day7 = [42, 45, 46, 47];
Day8 = [49, 51, 52, 53];

%% Concatenate blocks into the days, do artifact rejection
% specify  path for this animal
for block = Day1;
    block_name = strcat(path_to_data,'data_block_',ratID,'_',num2str(block));
    to_concatenate.(block) = load(block_name);

% load blocks for each day


% get start and end timestamps for each block
% create one continues thread of timestamps
% concatenate blocks for each day and store in new file labelled with day
% do artifact rejection
% re-separeate blocks based on timestamps (keep new timestamps)