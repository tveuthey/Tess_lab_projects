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
if TTX.SelectBlock('Block-203')~=1;
    disp 'Block Error';
end



%Read All Spikes
eventnumber=10000;
for chan_no=[1]

TTX.SetUseSortName('TankSort');


for i = 0:1
    TTX.ResetFilters

    TTX.SetFilterWithDescEx(['SORT=' num2str(i)]);
    N(:,:,chan_no) = TTX.ReadEventsV(eventnumber, 'SPK1', chan_no, 0, 0.0, 0.0, 'FILTERED')
    TimeStamps{chan_no,i+1}=TTX.ParseEvInfoV(0, N(:,:,chan_no), 6);
    Waves{chan_no,i+1}=TTX.ParseEvV(0, N(:,:,chan_no));
    Sorts{chan_no,i+1}=TTX.ParseEvInfoV(0, N(:,:,chan_no), 5);
    
%% creating ISIs
     %cache1 = zeros(1,3500);
     for j{chan_no,i+1} = 1:N(:,:,chan_no)-1
         delta(j{chan_no,i+1}) = TimeStamps(j{chan_no,i+1}+1)-TimeStamps(j{chan_no,i+1});
         bin{chan_no,i+1} = ceil(delta(j{chan_no,i+1})*1000);
         %cache1(1,bin{chan_no,i+1}) = cache1(1,bin{chan_no,i+1}) + 1;
     end
    %bar(cache1(1:100));
    
%     subplot(3,1,i+1)
%     plot(waves)
%     title(['Sort Code ' num2str(i) '; ' num2str(N) ' waveforms']);
end
end
N;
TTX.CloseTank
TTX.ReleaseServer

