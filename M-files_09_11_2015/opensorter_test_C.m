close all; clear all; clc;

Tankname='DEMOTANK2'; %change 'Data' in 'Data_Stephen'

%Activate Tank DLL
TTX = actxcontrol('TTank.X'); 
servername = 'Local';
clientname = 'myclient'; 
if TTX.ConnectServer(servername, clientname)~=1
    disp 'Server Error';
end
if TTX.OpenTank (Tankname, 'R')~=1;
    disp 'Tank Error';
end
if TTX.SelectBlock('Block-290')~=1;
    disp 'Block Error';
end



%Read All Spikes
eventnumber=10000;

TTX.SetUseSortName('290sort');

for i = 0:2
    TTX.ResetFilters

    TTX.SetFilterWithDescEx(['SORT=' num2str(i)]);
    N = TTX.ReadEventsV(eventnumber, 'eNeu', 8, 0, 0.0, 0.0, 'FILTERED')
    
    waves = TTX.ParseEvV(0, N);
    sorts = TTX.ParseEvInfoV (0, N, 5);
    ts = TTX.ParseEvInfoV(0, N, 6);
    
    subplot(3,1,i+1)
    plot(waves)
    title(['Sort Code ' num2str(i) '; ' num2str(N) ' waveforms']);
end

TTX.CloseTank
TTX.ReleaseServer

