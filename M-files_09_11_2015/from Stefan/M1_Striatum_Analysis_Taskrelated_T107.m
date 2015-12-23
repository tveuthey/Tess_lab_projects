% Originally script: M1_Striatum_Analysis_Taskrelated_T107

%%%% M1/Striatum Analysis Pipeline

%%% Task-related processing: First analyze PETHs for all units. Next
%%% calculate spectrograms/task-related beta/gamma/high-gamma power. Then
%%% calculate single unit PC ensembles - performed both individually (i.e., separately
%%% for M1/Striatum, and then with all neurons together). Next calculate 
%%% gamma/high-gamma PC ensembles. Finally, calculate M1/striatum coherograms.

%%% Sleep-related processing: first, calculate sleep periods across days.
%%% Next, assess PC replay (separately for M1 and striatum, and then
%%% together). Next, calculate changes in SFC (M1 -> striatum) during
%%% sleep, both as a consequence of learning and over time.%%% Finally,

%%% First define epochs of sleep across all days for each animal
%%% Next, analyze single-unit data: task-related PETH over time.

%% Task-Related PETHs
 
%%%Load Data From Day X Block 1 Task-Related Reach Block

clear all;
Tmp = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\data_block_T107_Block-4.mat');
TimeStamps = Tmp.TimeStamps;
wave = Tmp.wave;
data = Tmp.data;
Fs_lfp = Tmp.Fs_lfp;
clear Tmp;

%%%Get Trial time_markers and pellet_drop marker
[trials_markers,pelletdrop_markers, trial_no]=find_pulses_reach_M1str(wave);

%%Plot PETH data

dir = 'C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\Day1\Block1\Peth\';
if (~exist(dir)) 
    mkdir(dir); 
end
cd(dir);
count=0;

for j = 2:5
    tmp=[];
    for i = 1:length(TimeStamps)
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    units(j-1).un=tmp;
end

for j = 2:5
    tmp=[];
    for i = 1:16
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    unitsM1(j-1).un=tmp;
end

for j = 2:5
    tmp=[];
    for i = 17:32
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    unitsStr(j-1).un=tmp;
end

len_bef=4000;
len_aft=2000;
bin=25;
plot_raster_peth_M1str(unitsM1,pelletdrop_markers,TimeStamps,len_bef,len_aft,bin,dir,'M1-Units')
plot_raster_peth_M1str(unitsStr,pelletdrop_markers,TimeStamps,len_bef,len_aft,bin,dir,'Str-Units')

save units.mat units*

%%
clear all;
Tmp = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T110\data_block_T110_Block-8.mat');
TimeStamps = Tmp.TimeStamps;
wave = Tmp.wave;
data = Tmp.data;
Fs_lfp = Tmp.Fs_lfp;
clear Tmp;

%%%Get Trial time_markers and pellet_drop marker
[trials_markers,pelletdrop_markers, trial_no]=find_pulses_reach_M1str(wave);

%%Plot PETH data

dir = 'C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\Day1\Block2\Peth\';
if (~exist(dir)) 
    mkdir(dir); 
end
cd(dir);
count=0;

for j = 2:5
    tmp=[];
    for i = 1:length(TimeStamps)
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    units(j-1).un=tmp;
end

for j = 2:5
    tmp=[];
    for i = 1:16
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    unitsM1(j-1).un=tmp;
end

for j = 2:5
    tmp=[];
    for i = 17:32
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    unitsStr(j-1).un=tmp;
end

len_bef=4000;
len_aft=2000;
bin=25;
plot_raster_peth_M1str(unitsM1,pelletdrop_markers,TimeStamps,len_bef,len_aft,bin,dir,'M1-Units')
plot_raster_peth_M1str(unitsStr,pelletdrop_markers,TimeStamps,len_bef,len_aft,bin,dir,'Str-Units')

save units.mat units*

%% Day 2
%%%Load Data From Day X Block 1 Task-Related Reach Block

clear all;
Tmp = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\data_block_T107_Block-13.mat');
TimeStamps = Tmp.TimeStamps;
wave = Tmp.wave;
data = Tmp.data;
Fs_lfp = Tmp.Fs_lfp;
clear Tmp;

%%%Get Trial time_markers and pellet_drop marker
[trials_markers,pelletdrop_markers, trial_no]=find_pulses_reach_M1str(wave);

%%Plot PETH data

dir = 'C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\Day2\Block1\Peth\';
if (~exist(dir)) 
    mkdir(dir); 
end

cd(dir);
count=0;

for j = 2:5
    tmp=[];
    for i = 1:length(TimeStamps)
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    units(j-1).un=tmp;
end

for j = 2:5
    tmp=[];
    for i = 1:16
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    unitsM1(j-1).un=tmp;
end

for j = 2:5
    tmp=[];
    for i = 17:32
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    unitsStr(j-1).un=tmp;
end

len_bef=4000;
len_aft=2000;
bin=25;
plot_raster_peth_M1str(unitsM1,pelletdrop_markers,TimeStamps,len_bef,len_aft,bin,dir,'M1-Units')
plot_raster_peth_M1str(unitsStr,pelletdrop_markers,TimeStamps,len_bef,len_aft,bin,dir,'Str-Units')

save units.mat units*
 
clear all;
Tmp = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\data_block_T107_Block-15.mat');
TimeStamps = Tmp.TimeStamps;
wave = Tmp.wave;
data = Tmp.data;
Fs_lfp = Tmp.Fs_lfp;
clear Tmp;

%%%Get Trial time_markers and pellet_drop marker
[trials_markers,pelletdrop_markers, trial_no]=find_pulses_reach_M1str(wave);

%%Plot PETH data

dir = 'C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\Day2\Block2\Peth\';
if (~exist(dir)) 
    mkdir(dir); 
end
cd(dir);
count=0;

for j = 2:5
    tmp=[];
    for i = 1:length(TimeStamps)
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    units(j-1).un=tmp;
end

for j = 2:5
    tmp=[];
    for i = 1:16
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    unitsM1(j-1).un=tmp;
end

for j = 2:5
    tmp=[];
    for i = 17:32
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    unitsStr(j-1).un=tmp;
end

len_bef=4000;
len_aft=2000;
bin=25;
plot_raster_peth_M1str(unitsM1,pelletdrop_markers,TimeStamps,len_bef,len_aft,bin,dir,'M1-Units')
plot_raster_peth_M1str(unitsStr,pelletdrop_markers,TimeStamps,len_bef,len_aft,bin,dir,'Str-Units')

save units.mat units*

%% dAY 3

clear all;
Tmp = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\data_block_T107_Block-22.mat');
TimeStamps = Tmp.TimeStamps;
wave = Tmp.wave;
data = Tmp.data;
Fs_lfp = Tmp.Fs_lfp;
clear Tmp;

%%%Get Trial time_markers and pellet_drop marker
[trials_markers,pelletdrop_markers, trial_no]=find_pulses_reach_M1str(wave);

%%Plot PETH data

dir = 'C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\Day3\Block1\Peth\';
if (~exist(dir)) 
    mkdir(dir); 
end
cd(dir);
count=0;

for j = 2:5
    tmp=[];
    for i = 1:length(TimeStamps)
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    units(j-1).un=tmp;
end

for j = 2:5
    tmp=[];
    for i = 1:16
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    unitsM1(j-1).un=tmp;
end

for j = 2:5
    tmp=[];
    for i = 17:32
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    unitsStr(j-1).un=tmp;
end

len_bef=4000;
len_aft=2000;
bin=25;
plot_raster_peth_M1str(unitsM1,pelletdrop_markers,TimeStamps,len_bef,len_aft,bin,dir,'M1-Units')
plot_raster_peth_M1str(unitsStr,pelletdrop_markers,TimeStamps,len_bef,len_aft,bin,dir,'Str-Units')

save units.mat units*
%%
clear all;
Tmp = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\data_block_T107_Block-25.mat');
TimeStamps = Tmp.TimeStamps;
wave = Tmp.wave;
data = Tmp.data;
Fs_lfp = Tmp.Fs_lfp;
clear Tmp;

%%%Get Trial time_markers and pellet_drop marker
[trials_markers,pelletdrop_markers, trial_no]=find_pulses_reach_M1str(wave);

%%Plot PETH data

dir = 'C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\Day3\Block2\Peth\';
 if (~exist(dir)) 
    mkdir(dir); 
end
cd(dir);
count=0;

for j = 2:5
    tmp=[];
    for i = 1:length(TimeStamps)
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    units(j-1).un=tmp;
end

for j = 2:5
    tmp=[];
    for i = 1:16
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    unitsM1(j-1).un=tmp;
end

for j = 2:5
    tmp=[];
    for i = 17:32
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    unitsStr(j-1).un=tmp;
end

len_bef=4000;
len_aft=2000;
bin=25;
plot_raster_peth_M1str(unitsM1,pelletdrop_markers,TimeStamps,len_bef,len_aft,bin,dir,'M1-Units')
plot_raster_peth_M1str(unitsStr,pelletdrop_markers,TimeStamps,len_bef,len_aft,bin,dir,'Str-Units')

save units.mat units*

%Day 4

clear all;
Tmp = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\data_block_T107_Block-31.mat');
TimeStamps = Tmp.TimeStamps;
wave = Tmp.wave;
data = Tmp.data;
Fs_lfp = Tmp.Fs_lfp;
clear Tmp;

%%%Get Trial time_markers and pellet_drop marker
[trials_markers,pelletdrop_markers, trial_no]=find_pulses_reach_M1str(wave);

%%Plot PETH data

dir = 'C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\Day4\Block1\Peth\';
if (~exist(dir)) 
    mkdir(dir); 
end
cd(dir);
count=0;

for j = 2:5
    tmp=[];
    for i = 1:length(TimeStamps)
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    units(j-1).un=tmp;
end

for j = 2:5
    tmp=[];
    for i = 1:16
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    unitsM1(j-1).un=tmp;
end

for j = 2:5
    tmp=[];
    for i = 17:32
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    unitsStr(j-1).un=tmp;
end

len_bef=4000;
len_aft=2000;
bin=25;
plot_raster_peth_M1str(unitsM1,pelletdrop_markers,TimeStamps,len_bef,len_aft,bin,dir,'M1-Units')
plot_raster_peth_M1str(unitsStr,pelletdrop_markers,TimeStamps,len_bef,len_aft,bin,dir,'Str-Units')

save units.mat units*
 
clear all;
Tmp = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\data_block_T107_Block-39.mat');
TimeStamps = Tmp.TimeStamps;
wave = Tmp.wave;
data = Tmp.data;
Fs_lfp = Tmp.Fs_lfp;
clear Tmp;

%%%Get Trial time_markers and pellet_drop marker
[trials_markers,pelletdrop_markers, trial_no]=find_pulses_reach_M1str(wave);

%%Plot PETH data

dir = 'C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\Day4\Block2\Peth\';
if (~exist(dir)) 
    mkdir(dir); 
end
cd(dir);
count=0;

for j = 2:5
    tmp=[];
    for i = 1:length(TimeStamps)
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    units(j-1).un=tmp;
end

for j = 2:5
    tmp=[];
    for i = 1:16
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    unitsM1(j-1).un=tmp;
end

for j = 2:5
    tmp=[];
    for i = 17:32
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    unitsStr(j-1).un=tmp;
end

len_bef=4000;
len_aft=2000;
bin=25;
plot_raster_peth_M1str(unitsM1,pelletdrop_markers,TimeStamps,len_bef,len_aft,bin,dir,'M1-Units')
plot_raster_peth_M1str(unitsStr,pelletdrop_markers,TimeStamps,len_bef,len_aft,bin,dir,'Str-Units')

save units.mat units*

%% Day 5

clear all;
Tmp = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\data_block_T107_Block-42.mat');
TimeStamps = Tmp.TimeStamps;
wave = Tmp.wave;
data = Tmp.data;
Fs_lfp = Tmp.Fs_lfp;
clear Tmp;

%%%Get Trial time_markers and pellet_drop marker
[trials_markers,pelletdrop_markers, trial_no]=find_pulses_reach_M1str(wave);

%%Plot PETH data

dir = 'C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\Day5\Block1\Peth\';
if (~exist(dir)) 
    mkdir(dir); 
end
cd(dir);
count=0;

for j = 2:5
    tmp=[];
    for i = 1:length(TimeStamps)
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    units(j-1).un=tmp;
end

for j = 2:5
    tmp=[];
    for i = 1:16
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    unitsM1(j-1).un=tmp;
end

for j = 2:5
    tmp=[];
    for i = 17:32
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    unitsStr(j-1).un=tmp;
end

len_bef=4000;
len_aft=2000;
bin=25;
plot_raster_peth_M1str(unitsM1,pelletdrop_markers,TimeStamps,len_bef,len_aft,bin,dir,'M1-Units')
plot_raster_peth_M1str(unitsStr,pelletdrop_markers,TimeStamps,len_bef,len_aft,bin,dir,'Str-Units')

save units.mat units*
%%
clear all;
Tmp = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\data_block_T107_Block-52.mat');
TimeStamps = Tmp.TimeStamps;
wave = Tmp.wave;
data = Tmp.data;
Fs_lfp = Tmp.Fs_lfp;
clear Tmp;

%%%Get Trial time_markers and pellet_drop marker
[trials_markers,pelletdrop_markers, trial_no]=find_pulses_reach_M1str(wave);

%%Plot PETH data

dir = 'C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\Day5\Block2\Peth\';
if (~exist(dir)) 
    mkdir(dir); 
end
cd(dir);
count=0;

for j = 2:5
    tmp=[];
    for i = 1:length(TimeStamps)
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    units(j-1).un=tmp;
end

for j = 2:5
    tmp=[];
    for i = 1:16
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    unitsM1(j-1).un=tmp;
end

for j = 2:5
    tmp=[];
    for i = 17:32
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    unitsStr(j-1).un=tmp;
end

len_bef=4000;
len_aft=2000;
bin=25;
plot_raster_peth_M1str(unitsM1,pelletdrop_markers,TimeStamps,len_bef,len_aft,bin,dir,'M1-Units')
plot_raster_peth_M1str(unitsStr,pelletdrop_markers,TimeStamps,len_bef,len_aft,bin,dir,'Str-Units')

save units.mat units*

%% Day 6
clear all;
Tmp = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T110\data_block_T110_Block-42.mat');
TimeStamps = Tmp.TimeStamps;
wave = Tmp.wave;
data = Tmp.data;
Fs_lfp = Tmp.Fs_lfp;
clear Tmp;

%%%Get Trial time_markers and pellet_drop marker
[trials_markers,pelletdrop_markers, trial_no]=find_pulses_reach_M1str(wave);

%%Plot PETH data

dir = 'C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T110\Day6\Block1\Peth\';
if (~exist(dir)) 
    mkdir(dir); 
end
cd(dir);
count=0;

for j = 2:5
    tmp=[];
    for i = 1:length(TimeStamps)
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    units(j-1).un=tmp;
end

for j = 2:5
    tmp=[];
    for i = 1:16
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    unitsM1(j-1).un=tmp;
end

for j = 2:5
    tmp=[];
    for i = 17:32
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    unitsStr(j-1).un=tmp;
end

len_bef=4000;
len_aft=2000;
bin=25;
plot_raster_peth_M1str(unitsM1,pelletdrop_markers,TimeStamps,len_bef,len_aft,bin,dir,'M1-Units')
plot_raster_peth_M1str(unitsStr,pelletdrop_markers,TimeStamps,len_bef,len_aft,bin,dir,'Str-Units')

save units.mat units*

 %%
clear all;
Tmp = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T110\data_block_T110_Block-43.mat');
TimeStamps = Tmp.TimeStamps;
wave = Tmp.wave;
data = Tmp.data;
Fs_lfp = Tmp.Fs_lfp;
clear Tmp;

%%%Get Trial time_markers and pellet_drop marker
[trials_markers,pelletdrop_markers, trial_no]=find_pulses_reach_M1str(wave);

%%Plot PETH data

dir = 'C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T110\Day6\Block2\Peth\';
if (~exist(dir)) 
    mkdir(dir); 
end
cd(dir);
count=0;

for j = 2:5
    tmp=[];
    for i = 1:length(TimeStamps)
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    units(j-1).un=tmp;
end

for j = 2:5
    tmp=[];
    for i = 1:16
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    unitsM1(j-1).un=tmp;
end

for j = 2:5
    tmp=[];
    for i = 17:32
        if ~isnan(TimeStamps{i,j})
        tmp=[tmp i];
        end
    end
    unitsStr(j-1).un=tmp;
end

len_bef=4000;
len_aft=2000;
bin=25;
plot_raster_peth_M1str(unitsM1,pelletdrop_markers,TimeStamps,len_bef,len_aft,bin,dir,'M1-Units')
plot_raster_peth_M1str(unitsStr,pelletdrop_markers,TimeStamps,len_bef,len_aft,bin,dir,'Str-Units')

save units.mat units*
