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

%%
%%%%%% Evaluating Sleep-Replay

clear all;
B1 = load('E:\M1-Striatum\Data\M1Striatum\T107n\data_block_T107_Block-3.mat');
B2 = load('E:\M1-Striatum\Data\M1Striatum\T107n\data_block_T107_Block-6.mat');
load ('E:\M1-Striatum\Data\M1Striatum\T107n\Day1\Block1\Peth\Units.mat');
cd('E:\M1-Striatum\Data\M1Striatum\T107n\Day1\');

% %%%%%%%%%Find Sleep inds B1
chan_no=10
[sleep_indsB1]=find_sleep_indices2(B1.data, chan_no);
 clear B1data;
save('sleep_indsB1.mat', 'sleep_indsB1');

%%%%%%%%%Find Sleep inds B1
chan_no=8
[sleep_indsB2]=find_sleep_indices2(B2.data, chan_no);
clear B2data;
save('sleep_indsB2.mat','sleep_indsB2');
%%
load('E:\M1-Striatum\Data\M1Striatum\T107n\Day1\sleep_indsB1.mat')
load('E:\M1-Striatum\Data\M1Striatum\T107n\Day1\sleep_indsB2.mat')
load('E:\M1-Striatum\Data\M1Striatum\T107n\Day1\Block1\PC_ens\EnsemblesM1StrPCA.mat');
Fs_lfp = B1.Fs_lfp;
dir = ('E:\M1-Striatum\Data\M1Striatum\T107n\Day1\Block1\PC_ens\Replay\');
if(~exist(dir))
    mkdir(dir)
end

%%%Get Trial time_markers and pellet_drop marker
cd (dir)
count = 0;
for bin  = [5,25,50,100];
count =count+1;
eval(['Pattern = Patterns' num2str(bin)]);
[Activities_pre Activities_post]=Reach_sleep_cellassembly_M1Str(B1.TimeStamps,B2.TimeStamps,sleep_indsB1,sleep_indsB2,Fs_lfp, bin,unitsM1,unitsStr,Pattern,dir,'B1b_M1Str');
Activities(count).pre = Activities_pre;
Activities(count).post = Activities_post;
end
save M1StrActivities.mat A*

load('E:\M1-Striatum\Data\M1Striatum\T107n\Day1\Block1\PC_ens\EnsemblesM1PCA.mat');
count = 0;
for bin  = [5,25,50,100];
count =count+1;
eval(['Pattern = Patterns' num2str(bin)]);
[Activities_pre Activities_post]=Reach_sleep_cellassembly(B1.TimeStamps,B2.TimeStamps,sleep_indsB1,sleep_indsB2,Fs_lfp, bin,unitsM1,Pattern,dir,'B1b_M1');
Activities(count).pre = Activities_pre;
Activities(count).post = Activities_post;
end
save M1Activities.mat A*


load('E:\M1-Striatum\Data\M1Striatum\T107n\Day1\Block1\PC_ens\EnsemblesStrPCA.mat');
count = 0;
for bin  = [1,5,25,50,100];
count =count+1;
eval(['Pattern = Patterns' num2str(bin)]);
[Activities_pre Activities_post]=Reach_sleep_cellassembly(B1.TimeStamps,B2.TimeStamps,sleep_indsB1,sleep_indsB2,Fs_lfp, bin,unitsStr,Pattern,dir,'B1b_Str');
Activities(count).pre = Activities_pre;
Activities(count).post = Activities_post;
end
save StrActivities.mat A*

%% Day 2

clear all;
B1 = load('E:\M1-Striatum\Data\M1Striatum\T107n\data_block_T107_Block-9.mat');
B2 = load('E:\M1-Striatum\Data\M1Striatum\T107n\data_block_T107_Block-14.mat');
load ('E:\M1-Striatum\Data\M1Striatum\T107n\Day2\Block1\Peth\Units.mat');

cd('E:\M1-Striatum\Data\M1Striatum\T107n\Day2\');

%%%%%%%%%Find Sleep inds B1
chan_no=[]
[sleep_indsB1]=find_sleep_indices2(B1.data, chan_no);
 clear B1data;
save('sleep_indsB1.mat', 'sleep_indsB1');

%%%%%%%%%Find Sleep inds B1
chan_no=[]
[sleep_indsB2]=find_sleep_indices2(B2.data, chan_no);
clear B2data;
save('sleep_indsB2.mat','sleep_indsB2');
%%
load('E:\M1-Striatum\Data\M1Striatum\T107n\Day2\sleep_indsB1.mat')
load('E:\M1-Striatum\Data\M1Striatum\T107n\Day2\sleep_indsB2.mat')
load('E:\M1-Striatum\Data\M1Striatum\T107n\Day2\Block1\PC_ens\EnsemblesM1StrPCA.mat');
Fs_lfp = B1.Fs_lfp;
dir = ('E:\M1-Striatum\Data\M1Striatum\T107n\Day2\Block1\PC_ens\Replay\');
if(~exist(dir))
    mkdir(dir)
end

%%%Get Trial time_markers and pellet_drop marker
cd (dir)
count = 0;
for bin  = [5,25,50,100];
count =count+1;
eval(['Pattern = Patterns' num2str(bin)]);
[Activities_pre Activities_post]=Reach_sleep_cellassembly_M1Str(B1.TimeStamps,B2.TimeStamps,sleep_indsB1,sleep_indsB2,Fs_lfp, bin,unitsM1,unitsStr,Pattern,dir,'B1b_M1Str');
Activities(count).pre = Activities_pre;
Activities(count).post = Activities_post;
end
save M1StrActivities.mat A*

load('E:\M1-Striatum\Data\M1Striatum\T107n\Day2\Block1\PC_ens\EnsemblesM1PCA.mat');
count = 0;
for bin  = [5,25,50,100];
count =count+1;
eval(['Pattern = Patterns' num2str(bin)]);
[Activities_pre Activities_post]=Reach_sleep_cellassembly(B1.TimeStamps,B2.TimeStamps,sleep_indsB1,sleep_indsB2,Fs_lfp, bin,unitsM1,Pattern,dir,'B1b_M1');
Activities(count).pre = Activities_pre;
Activities(count).post = Activities_post;
end
save M1Activities.mat A*


load('E:\M1-Striatum\Data\M1Striatum\T107n\Day2\Block1\PC_ens\EnsemblesStrPCA.mat');
count = 0;
for bin  = [5,25,50,100];
count =count+1;
eval(['Pattern = Patterns' num2str(bin)]);
[Activities_pre Activities_post]=Reach_sleep_cellassembly(B1.TimeStamps,B2.TimeStamps,sleep_indsB1,sleep_indsB2,Fs_lfp, bin,unitsStr,Pattern,dir,'B1b_Str');
Activities(count).pre = Activities_pre;
Activities(count).post = Activities_post;
end
save StrActivities.mat A*

%%
load ('E:\M1-Striatum\Data\M1Striatum\T107n\Day2\Block2\Peth\Units.mat');
load('E:\M1-Striatum\Data\M1Striatum\T107n\Day2\sleep_indsB1.mat')
load('E:\M1-Striatum\Data\M1Striatum\T107n\Day2\sleep_indsB2.mat')
load('E:\M1-Striatum\Data\M1Striatum\T107n\Day2\Block2\PC_ens\EnsemblesM1StrPCA.mat');
Fs_lfp = B1.Fs_lfp;
dir = ('E:\M1-Striatum\Data\M1Striatum\T107n\Day2\Block2\PC_ens\Replay\');
if(~exist(dir))
    mkdir(dir)
end

%%%Get Trial time_markers and pellet_drop marker
cd (dir)
count = 0;
for bin  = [5,25,50,100];
count =count+1;
eval(['Pattern = Patterns' num2str(bin)]);
[Activities_pre Activities_post]=Reach_sleep_cellassembly_M1Str(B1.TimeStamps,B2.TimeStamps,sleep_indsB1,sleep_indsB2,Fs_lfp, bin,unitsM1,unitsStr,Pattern,dir,'B1b_M1Str');
Activities(count).pre = Activities_pre;
Activities(count).post = Activities_post;
end
save M1StrActivities.mat A*

load('E:\M1-Striatum\Data\M1Striatum\T107n\Day2\Block2\PC_ens\EnsemblesM1PCA.mat');
count = 0;
for bin  = [5,25,50,100];
count =count+1;
eval(['Pattern = Patterns' num2str(bin)]);
[Activities_pre Activities_post]=Reach_sleep_cellassembly(B1.TimeStamps,B2.TimeStamps,sleep_indsB1,sleep_indsB2,Fs_lfp, bin,unitsM1,Pattern,dir,'B1b_M1');
Activities(count).pre = Activities_pre;
Activities(count).post = Activities_post;
end
save M1Activities.mat A*


load('E:\M1-Striatum\Data\M1Striatum\T107n\Day2\Block2\PC_ens\EnsemblesStrPCA.mat');
count = 0;
for bin  = [5,25,50,100];
count =count+1;
eval(['Pattern = Patterns' num2str(bin)]);
[Activities_pre Activities_post]=Reach_sleep_cellassembly(B1.TimeStamps,B2.TimeStamps,sleep_indsB1,sleep_indsB2,Fs_lfp, bin,unitsStr,Pattern,dir,'B1b_Str');
Activities(count).pre = Activities_pre;
Activities(count).post = Activities_post;
end
save StrActivities.mat A*

%% Day 3
clear all;
B1 = load('E:\M1-Striatum\Data\M1Striatum\T107n\data_block_T107_Block-16.mat');
B2 = load('E:\M1-Striatum\Data\M1Striatum\T107n\data_block_T107_Block-24.mat');
load ('E:\M1-Striatum\Data\M1Striatum\T107n\Day3\Block1\Peth\Units.mat');
cd('E:\M1-Striatum\Data\M1Striatum\T107n\Day3\');

%%%%%%%%%Find Sleep inds B1
chan_no=[]
[sleep_indsB1]=find_sleep_indices2(B1.data, chan_no);
 clear B1data;
save('sleep_indsB1.mat', 'sleep_indsB1');

%%%%%%%%%Find Sleep inds B1
chan_no=[]
[sleep_indsB2]=find_sleep_indices2(B2.data, chan_no);
clear B2data;
save('sleep_indsB2.mat','sleep_indsB2');
%%
load('E:\M1-Striatum\Data\M1Striatum\T107n\Day3\sleep_indsB1.mat')
load('E:\M1-Striatum\Data\M1Striatum\T107n\Day3\sleep_indsB2.mat')
load('E:\M1-Striatum\Data\M1Striatum\T107n\Day3\Block1\PC_ens\EnsemblesM1StrPCA.mat');
Fs_lfp = B1.Fs_lfp;
dir = ('E:\M1-Striatum\Data\M1Striatum\T107n\Day3\Block1\PC_ens\Replay\');
if(~exist(dir))
    mkdir(dir)
end

%%%Get Trial time_markers and pellet_drop marker
cd (dir)
count = 0;
for bin  = [5,25,50,100];
count =count+1;
eval(['Pattern = Patterns' num2str(bin)]);
[Activities_pre Activities_post]=Reach_sleep_cellassembly_M1Str(B1.TimeStamps,B2.TimeStamps,sleep_indsB1,sleep_indsB2,Fs_lfp, bin,unitsM1,unitsStr,Pattern,dir,'B1b_M1Str');
Activities(count).pre = Activities_pre;
Activities(count).post = Activities_post;
end
save M1StrActivities.mat A*

load('E:\M1-Striatum\Data\M1Striatum\T107n\Day3\Block1\PC_ens\EnsemblesM1PCA.mat');
count = 0;
for bin  = [5,25,50,100];
count =count+1;
eval(['Pattern = Patterns' num2str(bin)]);
[Activities_pre Activities_post]=Reach_sleep_cellassembly(B1.TimeStamps,B2.TimeStamps,sleep_indsB1,sleep_indsB2,Fs_lfp, bin,unitsM1,Pattern,dir,'B1b_M1');
Activities(count).pre = Activities_pre;
Activities(count).post = Activities_post;
end
save M1Activities.mat A*

load('E:\M1-Striatum\Data\M1Striatum\T107n\Day3\Block1\PC_ens\EnsemblesStrPCA.mat');
count = 0;
for bin  = [1,5,25,50,100];
count =count+1;
eval(['Pattern = Patterns' num2str(bin)]);
[Activities_pre Activities_post]=Reach_sleep_cellassembly(B1.TimeStamps,B2.TimeStamps,sleep_indsB1,sleep_indsB2,Fs_lfp, bin,unitsStr,Pattern,dir,'B1b_Str');
Activities(count).pre = Activities_pre;
Activities(count).post = Activities_post;
end
save StrActivities.mat A*

%% Day 4
clear all;
B1 = load('E:\M1-Striatum\Data\M1Striatum\T107n\data_block_T107_Block-26.mat');
B2 = load('E:\M1-Striatum\Data\M1Striatum\T107n\data_block_T107_Block-36.mat');
load ('E:\M1-Striatum\Data\M1Striatum\T107n\Day4\Block1\Peth\Units.mat');
cd('E:\M1-Striatum\Data\M1Striatum\T107n\Day4\');

% %%%%%%%%%Find Sleep inds B1
chan_no=[]
[sleep_indsB1]=find_sleep_indices2(B1.data, chan_no);
 clear B1data;
save('sleep_indsB1.mat', 'sleep_indsB1');

%%%%%%%%%Find Sleep inds B1
chan_no=[]
[sleep_indsB2]=find_sleep_indices2(B2.data, chan_no);
clear B2data;
save('sleep_indsB2.mat','sleep_indsB2');

%%
load('E:\M1-Striatum\Data\M1Striatum\T107n\Day4\sleep_indsB1.mat')
load('E:\M1-Striatum\Data\M1Striatum\T107n\Day4\sleep_indsB2.mat')
load('E:\M1-Striatum\Data\M1Striatum\T107n\Day4\Block1\PC_ens\EnsemblesM1StrPCA.mat');
Fs_lfp = B1.Fs_lfp;
dir = ('E:\M1-Striatum\Data\M1Striatum\T107n\Day4\Block1\PC_ens\Replay\');
if(~exist(dir))
    mkdir(dir)
end

%%%Get Trial time_markers and pellet_drop marker
cd (dir)
count = 0;
for bin  = [5,25,50,100];
count =count+1;
eval(['Pattern = Patterns' num2str(bin)]);
[Activities_pre Activities_post]=Reach_sleep_cellassembly_M1Str(B1.TimeStamps,B2.TimeStamps,sleep_indsB1,sleep_indsB2,Fs_lfp, bin,unitsM1,unitsStr,Pattern,dir,'B1b_M1Str');
Activities(count).pre = Activities_pre;
Activities(count).post = Activities_post;
end
save M1StrActivities.mat A*

load('E:\M1-Striatum\Data\M1Striatum\T107n\Day4\Block1\PC_ens\EnsemblesM1PCA.mat');
count = 0;
for bin  = [5,25,50,100];
count =count+1;
eval(['Pattern = Patterns' num2str(bin)]);
[Activities_pre Activities_post]=Reach_sleep_cellassembly(B1.TimeStamps,B2.TimeStamps,sleep_indsB1,sleep_indsB2,Fs_lfp, bin,unitsM1,Pattern,dir,'B1b_M1');
Activities(count).pre = Activities_pre;
Activities(count).post = Activities_post;
end
save M1Activities.mat A*

load('E:\M1-Striatum\Data\M1Striatum\T107n\Day4\Block1\PC_ens\EnsemblesStrPCA.mat');
count = 0;
for bin  = [1,5,25,50,100];
count =count+1;
eval(['Pattern = Patterns' num2str(bin)]);
[Activities_pre Activities_post]=Reach_sleep_cellassembly(B1.TimeStamps,B2.TimeStamps,sleep_indsB1,sleep_indsB2,Fs_lfp, bin,unitsStr,Pattern,dir,'B1b_Str');
Activities(count).pre = Activities_pre;
Activities(count).post = Activities_post;
end
save StrActivities.mat A*

%%
%%%Get Trial time_markers and pellet_drop marker
load('E:\M1-Striatum\Data\M1Striatum\T107n\Day4\sleep_indsB1.mat')
load('E:\M1-Striatum\Data\M1Striatum\T107n\Day4\sleep_indsB2.mat')
load ('E:\M1-Striatum\Data\M1Striatum\T107n\Day4\Block2\Peth\Units.mat');
load('E:\M1-Striatum\Data\M1Striatum\T107n\Day4\Block2\PC_ens\EnsemblesM1StrPCA.mat');
B1 = load('E:\M1-Striatum\Data\M1Striatum\T107n\data_block_T107_Block-26.mat');
B2 = load('E:\M1-Striatum\Data\M1Striatum\T107n\data_block_T107_Block-36.mat');

dir = ('E:\M1-Striatum\Data\M1Striatum\T107n\Day4\Block2\PC_ens\Replay\');
if(~exist(dir))
    mkdir(dir)
end
cd (dir)
count = 0;
for bin  = [5,25,50,100];
count =count+1;
eval(['Pattern = Patterns' num2str(bin)]);
[Activities_pre Activities_post]=Reach_sleep_cellassembly_M1Str(B1.TimeStamps,B2.TimeStamps,sleep_indsB1,sleep_indsB2,Fs_lfp, bin,unitsM1,unitsStr,Pattern,dir,'B2a_M1Str');
Activities(count).pre = Activities_pre;
Activities(count).post = Activities_post;
end
save M1StrActivities.mat A*

%%%Get Trial time_markers and pellet_drop marker
load('E:\M1-Striatum\Data\M1Striatum\T107n\Day4\Block2\PC_ens\EnsemblesM1PCA.mat');
count = 0;
for bin  = [5,25,50,100];
count =count+1;
eval(['Pattern = Patterns' num2str(bin)]);
[Activities_pre Activities_post]=Reach_sleep_cellassembly(B1.TimeStamps,B2.TimeStamps,sleep_indsB1,sleep_indsB2,Fs_lfp, bin,unitsM1,Pattern,dir,'B1b_M1');
Activities(count).pre = Activities_pre;
Activities(count).post = Activities_post;
end
save M1Activities.mat A*


load('E:\M1-Striatum\Data\M1Striatum\T107n\Day4\Block2\PC_ens\EnsemblesStrPCA.mat');
count = 0;
for bin  = [5,25,50,100];
count =count+1;
eval(['Pattern = Patterns' num2str(bin)]);
[Activities_pre Activities_post]=Reach_sleep_cellassembly(B1.TimeStamps,B2.TimeStamps,sleep_indsB1,sleep_indsB2,Fs_lfp, bin,unitsStr,Pattern,dir,'B1b_Str');
Activities(count).pre = Activities_pre;
Activities(count).post = Activities_post;
end
save StrActivities.mat A*

%% Day 5
clear all;
B1 = load('E:\M1-Striatum\Data\M1Striatum\T107n\data_block_T107_Block-41.mat');
B2 = load('E:\M1-Striatum\Data\M1Striatum\T107n\data_block_T107_Block-47.mat');
cd('E:\M1-Striatum\Data\M1Striatum\T107n\Day5\');

% %%%%%%%%%Find Sleep inds B1
chan_no=[]
[sleep_indsB1]=find_sleep_indices2(B1.data, chan_no);
 clear B1data;
save('sleep_indsB1.mat', 'sleep_indsB1');

%%%%%%%%%Find Sleep inds B1
chan_no=[]
[sleep_indsB2]=find_sleep_indices2(B2.data, chan_no);
clear B2data;
save('sleep_indsB2.mat','sleep_indsB2');

%%
load ('E:\M1-Striatum\Data\M1Striatum\T107n\Day5\Block1\Peth\Units.mat');
load('E:\M1-Striatum\Data\M1Striatum\T107n\Day5\sleep_indsB1.mat')
load('E:\M1-Striatum\Data\M1Striatum\T107n\Day5\sleep_indsB2.mat')
load('E:\M1-Striatum\Data\M1Striatum\T107n\Day5\Block1\PC_ens\EnsemblesM1StrPCA.mat');
Fs_lfp = B1.Fs_lfp;
dir = ('E:\M1-Striatum\Data\M1Striatum\T107n\Day5\Block1\PC_ens\Replay\');
if(~exist(dir))
    mkdir(dir)
end

%%%Get Trial time_markers and pellet_drop marker
cd (dir)
count = 0;
for bin  = [5,10,25,50];
count =count+1;
eval(['Pattern = Patterns' num2str(bin)]);
[Activities_pre Activities_post]=Reach_sleep_cellassembly_M1Str(B1.TimeStamps,B2.TimeStamps,sleep_indsB1,sleep_indsB2,Fs_lfp, bin,unitsM1,unitsStr,Pattern,dir,'B1b_M1Str');
Activities(count).pre = Activities_pre;
Activities(count).post = Activities_post;
end
save M1StrActivities.mat A*

load('E:\M1-Striatum\Data\M1Striatum\T107n\Day5\Block1\PC_ens\EnsemblesM1PCA.mat');
count = 0;
for bin  = [5,10,25,50];
count =count+1;
eval(['Pattern = Patterns' num2str(bin)]);
[Activities_pre Activities_post]=Reach_sleep_cellassembly(B1.TimeStamps,B2.TimeStamps,sleep_indsB1,sleep_indsB2,Fs_lfp, bin,unitsM1,Pattern,dir,'B1b_M1');
Activities(count).pre = Activities_pre;
Activities(count).post = Activities_post;
end
save M1Activities.mat A*

load('E:\M1-Striatum\Data\M1Striatum\T107n\Day5\Block1\PC_ens\EnsemblesStrPCA.mat');
count = 0;

for bin  = [5,10,25,50];
count =count+1;
eval(['Pattern = Patterns' num2str(bin)]);
[Activities_pre Activities_post]=Reach_sleep_cellassembly(B1.TimeStamps,B2.TimeStamps,sleep_indsB1,sleep_indsB2,Fs_lfp, bin,unitsStr,Pattern,dir,'B1b_Str');
Activities(count).pre = Activities_pre;
Activities(count).post = Activities_post;
end
save StrActivities.mat A*

 %%
%%%Get Trial time_markers and pellet_drop marker
load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T110\Day4\sleep_indsB1.mat')
load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T110\Day4\sleep_indsB2.mat')
load ('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T110\Day4\Block2\Peth\Units.mat');
load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T110\Day4\Block2\PC_ens\EnsemblesM1StrPCA.mat');
B1 = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T110\data_block_T110_Block-19.mat');
B2 = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T110\data_block_T110_Block-21.mat');

dir = ('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T110\Day4\Block2\PC_ens\Replay\');
if(~exist(dir))
    mkdir(dir)
end
cd (dir)
count = 0;
for bin  = [5,25,50,100];
count =count+1;
eval(['Pattern = Patterns' num2str(bin)]);
[Activities_pre Activities_post]=Reach_sleep_cellassembly_M1Str(B1.TimeStamps,B2.TimeStamps,sleep_indsB1,sleep_indsB2,Fs_lfp, bin,unitsM1,unitsStr,Pattern,dir,'B2a_M1Str');
Activities(count).pre = Activities_pre;
Activities(count).post = Activities_post;
end
save M1StrActivities.mat A*

%%%Get Trial time_markers and pellet_drop marker
load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T110\Day4\Block2\PC_ens\EnsemblesM1PCA.mat');
count = 0;
for bin  = [5,25,50,100];
count =count+1;
eval(['Pattern = Patterns' num2str(bin)]);
[Activities_pre Activities_post]=Reach_sleep_cellassembly(B1.TimeStamps,B2.TimeStamps,sleep_indsB1,sleep_indsB2,Fs_lfp, bin,unitsM1,Pattern,dir,'B1b_M1');
Activities(count).pre = Activities_pre;
Activities(count).post = Activities_post;
end
save M1Activities.mat A*


load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T110\Day4\Block2\PC_ens\EnsemblesStrPCA.mat');
count = 0;
for bin  = [5,25,50,100];
count =count+1;
eval(['Pattern = Patterns' num2str(bin)]);
[Activities_pre Activities_post]=Reach_sleep_cellassembly(B1.TimeStamps,B2.TimeStamps,sleep_indsB1,sleep_indsB2,Fs_lfp, bin,unitsStr,Pattern,dir,'B1b_Str');
Activities(count).pre = Activities_pre;
Activities(count).post = Activities_post;
end
save StrActivities.mat A*

%% Day 5

