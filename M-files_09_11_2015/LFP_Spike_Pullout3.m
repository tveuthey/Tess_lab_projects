%%

close all; clear all; clc;

%   
% 
Blocks = [6];
 for i = 1:length(Blocks)

     clearvars -except i Blocks TankName a an nbl;
     close all;
     clc;
len_chs = 32;
TankName='T61';
Block_Name=strcat('Block-',num2str(Blocks(i)));
SortID='TankSort';
filename='data_spikes_lfps_wav_';

%tankdir = ['F:\' TankName]; 
%cd(tankdir);

%cd 'D:\TDT\OpenEx\Tanks\DemoTank2';
cd ('F:\T61\');

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
%
%%%% Read All Spikes
eventnumber=5000000;
for chan_no=[1:len_chs]
    TTX.SetUseSortName(SortID);
    for i = 1:4
        TTX.ResetFilters
        TTX.SetFilterWithDescEx(['SORT=' num2str(i)]);
        N{chan_no,i+1} = TTX.ReadEventsV(eventnumber, 'eNeu', chan_no, 0, 0.0, 0.0, 'FILTERED');
        disp([chan_no])
        disp([])
        TimeStamps{chan_no,i+1}=TTX.ParseEvInfoV(0, N{chan_no,i+1}, 6);
        Waves{chan_no,i+1}=TTX.ParseEvV(0, N{chan_no,i+1});
        Sorts{chan_no,i+1}=TTX.ParseEvInfoV(0, N{chan_no,i+1}, 5);
        %Fs_eNeu=TTX.ParseEvInfoV(0, 0, 9);
    end
end

Allstreams = TDT2mat(TankName, Block_Name,'TYPE',4);
if ~isempty(Allstreams.streams)
data = Allstreams.streams.LFPs.data;
Fs_lfp = Allstreams.streams.LFPs.fs;
wave = Allstreams.streams.Wave.data;
TTX.CloseTank
TTX.ReleaseServer
close all
 
 
 %saving raw data
 
outdir = ['F:\Stroke_Sleep\T61\Day1'];
if ~exist(outdir)
    mkdir(outdir);
end
cd (outdir)
save (['data_block_' TankName '_' Block_Name],'-v7.3') 
end
 end

 
 