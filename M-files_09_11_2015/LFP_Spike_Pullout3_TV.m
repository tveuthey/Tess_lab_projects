%%

close all; clear all; clc;

%   
% 
Blocks = [54:85]; %put in all the blocks that we are doing that day
 for i = 1:length(Blocks)
     clearvars -except i Blocks TankName a an nbl;
     close all;
     clc;
len_chs = 32; %32 or 64 usually
TankName='T68';
Block_Name=strcat('Block-',num2str(Blocks(i)));
SortID='TankSort1';
filename='data_spikes_lfps_wav_';

%tankdir = ['F:\' TankName]; 
%cd(tankdir);

%cd 'D:\TDT\OpenEx\Tanks\DemoTank2';
cd ('J:\T68\');

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
% if I see any of these errors, there is some issues with communication
% with TdT and should not trust the data

disp('Tank and Block Selected -----------------------------------')
%
%%%% Read All Spikes
eventnumber=5000000; %tell them number of spikes to extract, we put a large number here so that we get all of the spikes
for chan_no=[1:len_chs]
    TTX.SetUseSortName(SortID);
    for i = 1:4 %how many possible sorts there could be (we usually have 1-3)
        TTX.ResetFilters
        TTX.SetFilterWithDescEx(['SORT=' num2str(i)]);
        N{chan_no,i+1} = TTX.ReadEventsV(eventnumber, 'eNeu', chan_no, 0, 0.0, 0.0, 'FILTERED');
        disp([chan_no])
        disp([])
        TimeStamps{chan_no,i+1}=TTX.ParseEvInfoV(0, N{chan_no,i+1}, 6);
        Waves{chan_no,i+1}=TTX.ParseEvV(0, N{chan_no,i+1});
        Sorts{chan_no,i+1}=TTX.ParseEvInfoV(0, N{chan_no,i+1}, 5); %ignore
        %Fs_eNeu=TTX.ParseEvInfoV(0, 0, 9);
    end
end

%all continuous (non-event) data, like LFP data 
Allstreams = TDT2mat(TankName, Block_Name,'TYPE',4);
if ~isempty(Allstreams.streams)
data = Allstreams.streams.LFPs.data;
Fs_lfp = Allstreams.streams.LFPs.fs;
wave = Allstreams.streams.Wave.data;
TTX.CloseTank
TTX.ReleaseServer
close all
 
 
 %saving raw data
 
outdir = ['J:\Stroke_Sleep\T72-new']; %where we save it to
if ~exist(outdir)
    mkdir(outdir);
end
cd (outdir)
save (['data_block_' TankName '_' Block_Name],'-v7.3') 
end
 end

 
 