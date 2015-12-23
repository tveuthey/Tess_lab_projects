close all; clear all; clc;

Tankname='DEMOTANK2';

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
if TTX.SelectBlock('Block-260')~=1;
    disp 'Block Error';
end



%Read All Spikes
eventnumber=10000;
for chan_no=1:32

TTX.SetUseSortName('TankSort');


for i = 0:1
    TTX.ResetFilters

    TTX.SetFilterWithDescEx(['SORT=' num2str(i)]);
    N{chan_no,i+1} = TTX.ReadEventsV(eventnumber, 'eNeu', chan_no, 0, 0.0, 0.0, 'FILTERED')
    TimeStamps{chan_no,i+1}=TTX.ParseEvInfoV(0, N{chan_no,i+1}, 6);
    Waves{chan_no,i+1}=TTX.ParseEvV(0, N{chan_no,i+1});
    Sorts{chan_no,i+1}=TTX.ParseEvInfoV(0, N{chan_no,i+1}, 5);
    
%% creating ISIs
%      chan_no=8;
%      cache1{chan_no,i+1} = [zeros(1,3500)];
%      %for j = 1:N{chan_no,i+1}-1
% 
%          delta = TimeStamps{chan_no,i+1}(j+1)-TimeStamps{chan_no,i+1}(j);
%          bin = ceil(delta*1000);j
         
         %cache1{chan_no,i+1}(1,bin) = cache1{chan_no,i+1}(1,bin) + 1;
%      end
    
    
%     subplot(3,1,i+1)
%     plot(waves)
%     title(['Sort Code ' num2str(i) '; ' num2str(N) ' waveforms']);
end
end
N;
TTX.CloseTank
TTX.ReleaseServer

