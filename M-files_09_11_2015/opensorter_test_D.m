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

TTX.SetUseSortName('sort290');

TTX.ResetFilters

%    TTX.SetFilterWithDescEx(['SORT=' num2str(i)]);
N = TTX.ReadEventsV(eventnumber, 'eNeu', 8, 0, 0.0, 0.0, 'FILTERED')
    
waves = TTX.ParseEvV(0, N);
sorts = TTX.ParseEvInfoV (0, N, 5);
ts = TTX.ParseEvInfoV(0, N, 6);
    
for i = 0:2
    subplot(3,1,i+1)
    ind = find(sorts==i);
    if numel(ind) > 0
        plot(waves(:,ind))
    end
    title(['Sort Code ' num2str(i) '; ' num2str(N) ' waveforms']);
end

ts(find(sorts==1)); %timestamps for sort code 1
ts(find(sorts==2)); %timestamps for sort code 2

TTX.CloseTank
TTX.ReleaseServer

