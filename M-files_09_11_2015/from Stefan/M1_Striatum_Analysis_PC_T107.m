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
Tmp = load('E:\M1-Striatum\Data\M1Striatum\T107n\data_block_T107_Block-4.mat');
TimeStamps1 = Tmp.TimeStamps;
wave = Tmp.wave;
%data = Tmp.data;
Fs_lfp = Tmp.Fs_lfp;
load ('E:\M1-Striatum\Data\M1Striatum\T107n\Day1\Block1\Peth\Units.mat');
clear Tmp;

%%%Get Trial time_markers and pellet_drop marker
[trials_markers,pelletdrop_markers, trial_no]=find_pulses_reach_M1str(wave);

dir = ('E:\M1-Striatum\Data\M1Striatum\T107n\Day1\Block1\PC_ens\');
if(~exist(dir))
    mkdir(dir)
end

%%Plot PETH data
cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsM1,1,predur,postdur,'M1');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsM1,1,predur,postdur,'M1');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsM1,1,predur,postdur,'M1');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsM1,1,predur,postdur,'M1');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsM1,1,predur,postdur,'M1');
[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsM1,1,predur,postdur,'M1');
save EnsemblesM1PCA.mat Act* Patt* eig* lam*

cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsStr,1,predur,postdur,'Str');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsStr,1,predur,postdur,'Str');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsStr,1,predur,postdur,'Str');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsStr,1,predur,postdur,'Str');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsStr,1,predur,postdur,'Str');
[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsStr,1,predur,postdur,'Str');
save EnsemblesStrPCA.mat Act* Patt* eig* lam*

cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsM1,unitsStr,1,predur,postdur,'All');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsM1,unitsStr,1,predur,postdur,'All');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsM1,unitsStr,1,predur,postdur,'All');
save EnsemblesM1StrPCA.mat Act* Patt* eig* lam*
 


%%%Load Data From Day X Block 1 Task-Related Reach Block
%% Day 2
clear all; 
Tmp = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\data_block_T107_Block-13.mat');
TimeStamps1 = Tmp.TimeStamps;
wave = Tmp.wave;
%data = Tmp.data;
Fs_lfp = Tmp.Fs_lfp;
load ('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\Day1\Block1\Peth\Units.mat');
clear Tmp;

%%%Get Trial time_markers and pellet_drop marker
[trials_markers,pelletdrop_markers, trial_no]=find_pulses_reach_M1str(wave);

dir = ('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\Day1\Block1\PC_ens\');
if(~exist(dir))
    mkdir(dir)
end

%%Plot PETH data
cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsM1,1,predur,postdur,'M1');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsM1,1,predur,postdur,'M1');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsM1,1,predur,postdur,'M1');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsM1,1,predur,postdur,'M1');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsM1,1,predur,postdur,'M1');
[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsM1,1,predur,postdur,'M1');
save EnsemblesM1PCA.mat Act* Patt* eig* lam*

cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsStr,1,predur,postdur,'Str');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsStr,1,predur,postdur,'Str');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsStr,1,predur,postdur,'Str');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsStr,1,predur,postdur,'Str');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsStr,1,predur,postdur,'Str');
[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsStr,1,predur,postdur,'Str');
save EnsemblesStrPCA.mat Act* Patt* eig* lam*

cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsM1,unitsStr,1,predur,postdur,'All');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsM1,unitsStr,1,predur,postdur,'All');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsM1,unitsStr,1,predur,postdur,'All');
save EnsemblesM1StrPCA.mat Act* Patt* eig* lam*
 
%% Day 2
clear all; 
Tmp = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\data_block_T107_Block-15.mat');
TimeStamps1 = Tmp.TimeStamps;
wave = Tmp.wave;
%data = Tmp.data;
Fs_lfp = Tmp.Fs_lfp;
load ('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\Day2\Block1\Peth\Units.mat');
clear Tmp;

%%%Get Trial time_markers and pellet_drop marker
[trials_markers,pelletdrop_markers, trial_no]=find_pulses_reach_M1str(wave);

dir = ('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\Day2\Block1\PC_ens\');
if(~exist(dir))
    mkdir(dir)
end

%%Plot PETH data
cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsM1,1,predur,postdur,'M1');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsM1,1,predur,postdur,'M1');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsM1,1,predur,postdur,'M1');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsM1,1,predur,postdur,'M1');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsM1,1,predur,postdur,'M1');
[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsM1,1,predur,postdur,'M1');
save EnsemblesM1PCA.mat Act* Patt* eig* lam*

cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsStr,1,predur,postdur,'Str');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsStr,1,predur,postdur,'Str');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsStr,1,predur,postdur,'Str');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsStr,1,predur,postdur,'Str');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsStr,1,predur,postdur,'Str');
[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsStr,1,predur,postdur,'Str');
save EnsemblesStrPCA.mat Act* Patt* eig* lam*

cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsM1,unitsStr,1,predur,postdur,'All');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsM1,unitsStr,1,predur,postdur,'All');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsM1,unitsStr,1,predur,postdur,'All');
save EnsemblesM1StrPCA.mat Act* Patt* eig* lam*
 
%%%Load Data From Day X Block 1 Task-Related Reach Block

clear all; 
Tmp = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\data_block_T107_Block-15.mat');
TimeStamps1 = Tmp.TimeStamps;
wave = Tmp.wave;
%data = Tmp.data;
Fs_lfp = Tmp.Fs_lfp;
load ('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\Day2\Block2\Peth\Units.mat');
clear Tmp;

%%%Get Trial time_markers and pellet_drop marker
[trials_markers,pelletdrop_markers, trial_no]=find_pulses_reach_M1str(wave);

dir = ('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\Day2\Block2\PC_ens\');
if(~exist(dir))
    mkdir(dir)
end

%%Plot PETH data
cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsM1,1,predur,postdur,'M1');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsM1,1,predur,postdur,'M1');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsM1,1,predur,postdur,'M1');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsM1,1,predur,postdur,'M1');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsM1,1,predur,postdur,'M1');
[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsM1,1,predur,postdur,'M1');
save EnsemblesM1PCA.mat Act* Patt* eig* lam*

cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsStr,1,predur,postdur,'Str');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsStr,1,predur,postdur,'Str');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsStr,1,predur,postdur,'Str');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsStr,1,predur,postdur,'Str');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsStr,1,predur,postdur,'Str');
[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsStr,1,predur,postdur,'Str');
save EnsemblesStrPCA.mat Act* Patt* eig* lam*

cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsM1,unitsStr,1,predur,postdur,'All');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsM1,unitsStr,1,predur,postdur,'All');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsM1,unitsStr,1,predur,postdur,'All');
save EnsemblesM1StrPCA.mat Act* Patt* eig* lam*

%% Day 3
clear all; 
Tmp = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\data_block_T107_Block-22.mat');
TimeStamps1 = Tmp.TimeStamps;
wave = Tmp.wave;
Fs_lfp = Tmp.Fs_lfp;
load ('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\Day3\Block1\Peth\Units.mat');
clear Tmp;

%%%Get Trial time_markers and pellet_drop marker
[trials_markers,pelletdrop_markers, trial_no]=find_pulses_reach_M1str(wave);

dir = ('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\Day3\Block1\PC_ens\');
if(~exist(dir))
    mkdir(dir)
end

%%Plot PETH data
cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsM1,1,predur,postdur,'M1');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsM1,1,predur,postdur,'M1');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsM1,1,predur,postdur,'M1');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsM1,1,predur,postdur,'M1');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsM1,1,predur,postdur,'M1');
[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsM1,1,predur,postdur,'M1');
save EnsemblesM1PCA.mat Act* Patt* eig* lam*

cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsStr,1,predur,postdur,'Str');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsStr,1,predur,postdur,'Str');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsStr,1,predur,postdur,'Str');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsStr,1,predur,postdur,'Str');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsStr,1,predur,postdur,'Str');
[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsStr,1,predur,postdur,'Str');
save EnsemblesStrPCA.mat Act* Patt* eig* lam*

cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsM1,unitsStr,1,predur,postdur,'All');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsM1,unitsStr,1,predur,postdur,'All');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsM1,unitsStr,1,predur,postdur,'All');
save EnsemblesM1StrPCA.mat Act* Patt* eig* lam*
 
%% Block 2
%%%Load Data From Day X Block 1 Task-Related Reach Block

clear all; 
Tmp = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T110\data_block_T110_Block-18.mat');
TimeStamps1 = Tmp.TimeStamps;
wave = Tmp.wave;
%data = Tmp.data;
Fs_lfp = Tmp.Fs_lfp;
load ('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T110\Day3\Block2\Peth\Units.mat');
clear Tmp;

%%%Get Trial time_markers and pellet_drop marker
[trials_markers,pelletdrop_markers, trial_no]=find_pulses_reach_M1str(wave);

dir = ('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T110\Day3\Block2\PC_ens\');
if(~exist(dir))
    mkdir(dir)
end

%%Plot PETH data
cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsM1,1,predur,postdur,'M1');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsM1,1,predur,postdur,'M1');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsM1,1,predur,postdur,'M1');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsM1,1,predur,postdur,'M1');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsM1,1,predur,postdur,'M1');
[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsM1,1,predur,postdur,'M1');
save EnsemblesM1PCA.mat Act* Patt* eig* lam*

cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsStr,1,predur,postdur,'Str');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsStr,1,predur,postdur,'Str');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsStr,1,predur,postdur,'Str');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsStr,1,predur,postdur,'Str');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsStr,1,predur,postdur,'Str');
[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsStr,1,predur,postdur,'Str');
save EnsemblesStrPCA.mat Act* Patt* eig* lam*

cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsM1,unitsStr,1,predur,postdur,'All');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsM1,unitsStr,1,predur,postdur,'All');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsM1,unitsStr,1,predur,postdur,'All');
save EnsemblesM1StrPCA.mat Act* Patt* eig* lam*

%% Day 4
clear all; 
Tmp = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\data_block_T107_Block-31.mat');
TimeStamps1 = Tmp.TimeStamps;
wave = Tmp.wave;
%data = Tmp.data;
Fs_lfp = Tmp.Fs_lfp;
load ('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\Day4\Block1\Peth\units.mat');
clear Tmp;

%%%Get Trial time_markers and pellet_drop marker
[trials_markers,pelletdrop_markers, trial_no]=find_pulses_reach_M1str(wave);

dir = ('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\Day4\Block1\PC_ens\');
if(~exist(dir))
    mkdir(dir)
end

%%Plot PETH data
cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsM1,1,predur,postdur,'M1');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsM1,1,predur,postdur,'M1');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsM1,1,predur,postdur,'M1');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsM1,1,predur,postdur,'M1');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsM1,1,predur,postdur,'M1');
[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsM1,1,predur,postdur,'M1');
save EnsemblesM1PCA.mat Act* Patt* eig* lam*

cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsStr,1,predur,postdur,'Str');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsStr,1,predur,postdur,'Str');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsStr,1,predur,postdur,'Str');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsStr,1,predur,postdur,'Str');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsStr,1,predur,postdur,'Str');
[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsStr,1,predur,postdur,'Str');
save EnsemblesStrPCA.mat Act* Patt* eig* lam*

cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsM1,unitsStr,1,predur,postdur,'All');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsM1,unitsStr,1,predur,postdur,'All');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsM1,unitsStr,1,predur,postdur,'All');
save EnsemblesM1StrPCA.mat Act* Patt* eig* lam*
 
%Block 2
%%%Load Data From Day X Block 1 Task-Related Reach Block
%%
clear all; 
Tmp = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\data_block_T107_Block-39.mat');
TimeStamps1 = Tmp.TimeStamps;
wave = Tmp.wave;
%data = Tmp.data;
Fs_lfp = Tmp.Fs_lfp;
load ('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\Day4\Block2\Peth\units.mat');
clear Tmp;

%%%Get Trial time_markers and pellet_drop marker
[trials_markers,pelletdrop_markers, trial_no]=find_pulses_reach_M1str(wave);

dir = ('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\Day4\Block2\PC_ens\');
if(~exist(dir))
    mkdir(dir)
end

%%Plot PETH data
cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsM1,1,predur,postdur,'M1');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsM1,1,predur,postdur,'M1');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsM1,1,predur,postdur,'M1');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsM1,1,predur,postdur,'M1');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsM1,1,predur,postdur,'M1');
[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsM1,1,predur,postdur,'M1');
save EnsemblesM1PCA.mat Act* Patt* eig* lam*

cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsStr,1,predur,postdur,'Str');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsStr,1,predur,postdur,'Str');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsStr,1,predur,postdur,'Str');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsStr,1,predur,postdur,'Str');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsStr,1,predur,postdur,'Str');
[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsStr,1,predur,postdur,'Str');
save EnsemblesStrPCA.mat Act* Patt* eig* lam*

cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsM1,unitsStr,1,predur,postdur,'All');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsM1,unitsStr,1,predur,postdur,'All');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsM1,unitsStr,1,predur,postdur,'All');
save EnsemblesM1StrPCA.mat Act* Patt* eig* lam*

%% Day 5
clear all; 
Tmp = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\data_block_T107_Block-41.mat');
TimeStamps1 = Tmp.TimeStamps;
wave = Tmp.wave;
Fs_lfp = Tmp.Fs_lfp;
load ('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\Day5\Block1\Peth\Units.mat');
clear Tmp;

%%%Get Trial time_markers and pellet_drop marker
[trials_markers,pelletdrop_markers, trial_no]=find_pulses_reach_M1str(wave);

dir = ('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\Day5\Block1\PC_ens\');
if(~exist(dir))
    mkdir(dir)
end

%%Plot PETH data
cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsM1,1,predur,postdur,'M1');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsM1,1,predur,postdur,'M1');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsM1,1,predur,postdur,'M1');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsM1,1,predur,postdur,'M1');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsM1,1,predur,postdur,'M1');
%[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsM1,1,predur,postdur,'M1');
save EnsemblesM1PCA.mat Act* Patt* eig* lam*

cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsStr,1,predur,postdur,'Str');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsStr,1,predur,postdur,'Str');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsStr,1,predur,postdur,'Str');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsStr,1,predur,postdur,'Str');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsStr,1,predur,postdur,'Str');
%[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsStr,1,predur,postdur,'Str');
save EnsemblesStrPCA.mat Act* Patt* eig* lam*

cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsM1,unitsStr,1,predur,postdur,'All');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsM1,unitsStr,1,predur,postdur,'All');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsM1,unitsStr,1,predur,postdur,'All');
%[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsM1,unitsStr,1,predur,postdur,'All');
save EnsemblesM1StrPCA.mat Act* Patt* eig* lam*
%% 
% Block 2
%%%Load Data From Day X Block 1 Task-Related Reach Block

clear all; 
Tmp = load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\data_block_T107_Block-47.mat');
TimeStamps1 = Tmp.TimeStamps;
wave = Tmp.wave;
%data = Tmp.data;
Fs_lfp = Tmp.Fs_lfp;
load ('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\Day5\Block2\Peth\Units.mat');
clear Tmp;

%%%Get Trial time_markers and pellet_drop marker
[trials_markers,pelletdrop_markers, trial_no]=find_pulses_reach_M1str(wave);

dir = ('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\M1Striatum\T107n\Day5\Block2\PC_ens\');
if(~exist(dir))
    mkdir(dir)
end

%%Plot PETH data
cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsM1,1,predur,postdur,'M1');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsM1,1,predur,postdur,'M1');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsM1,1,predur,postdur,'M1');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsM1,1,predur,postdur,'M1');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsM1,1,predur,postdur,'M1');
%[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsM1,1,predur,postdur,'M1');
save EnsemblesM1PCA.mat Act* Patt* eig* lam*

cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsStr,1,predur,postdur,'Str');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsStr,1,predur,postdur,'Str');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsStr,1,predur,postdur,'Str');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsStr,1,predur,postdur,'Str');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsStr,1,predur,postdur,'Str');
%[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyb(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsStr,1,predur,postdur,'Str');
save EnsemblesStrPCA.mat Act* Patt* eig* lam*

cd (dir)
predur=1000;
postdur=1000;
[Activities1 Patterns1 eigenvalues1 lambda_max1]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 1,unitsM1,unitsStr,1,predur,postdur,'All');
[Activities5 Patterns5 eigenvalues5 lambda_max5]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 5,unitsM1,unitsStr,1,predur,postdur,'All');
[Activities10 Patterns10 eigenvalues10 lambda_max10]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 10, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities25 Patterns25 eigenvalues25 lambda_max25]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 25, unitsM1,unitsStr,1,predur,postdur,'All');
[Activities50 Patterns50 eigenvalues50 lambda_max50]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 50, unitsM1,unitsStr,1,predur,postdur,'All');
%[Activities100 Patterns100 eigenvalues100 lambda_max100]=Reach_task_cellassemblyM1Str(TimeStamps1,pelletdrop_markers, Fs_lfp, 100, unitsM1,unitsStr,1,predur,postdur,'All');
save EnsemblesM1StrPCA.mat Act* Patt* eig* lam*

