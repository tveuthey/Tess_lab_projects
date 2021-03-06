Spikedata

%% Connecting to TTank

TT = actxcontrol('TTank.X')
TT.ConnectServer('Local','Me')
MyTank='DEMOTANK2';
MyBlock='Block-290';
TT.OpenTank(MyTank,'R')
TT.SelectBlock(MyBlock)

disp('------------------------------')

% % This code sample returns all of the sort IDs present for the Snip event in the
% % currently selected block. The index is incremented until GetSortName returns an
% % empty string.


% idx = 0;
% sortid = 'temp';
% while ~isempty(sortid)
% sortid = TT.GetSortName('eNeu',idx)
% idx = idx+1;
% end


% % ReadEvents reads the event records for the specified EventCode from the
% % currently selected block in the currently open tank. The events are cached to
% % local memory within TTank.X where they can be accessed using ParseEv.
% % Additional arguments allow you to limit the access to a particular channel and/or
% % a particular sort code. The access can be further limited to a specified time range
% % within the block. The Options argument allows the user to select optional access
% % modes.


for chan_no=1:32;
    
    TT.SetGlobalV('Channel',chan_no);
    SetSort1 = TT.SetUseSortName('290sort');
    TT.SetFilterWithDescEx('sort=1');
    a=TT.ReadEventsSimple('eNeu')
    %Spike_Events=TT.ReadEvents('ALL', 'eNeu', 1, 0, 0.0, 0.0, 'JUSTTIMES, FILTERED')
    %a = TTX.ReadEventsSimple('eNeu') ;
    disp(chan_no)
    disp(a')
    disp('------------')
    data_sp(chan_no,:)= TT.ParseEvInfoV(0,10000,6);
    %plot([tstamps; tstamps],[0 1]+chan_no,'k')
end

% for chan_no=1:32
% 
%     Spike_Events=TT.ReadEvents(10000, 'eNeu', 1, 0, 0.0, 0.0, 'JUSTTIMES')
%     Spike_Waveforms = TT.ParseEvV(0, Spike_Events);
%     
%     disp(chan_no)
%     disp(Spike_Events')
%     disp('------------')
%     
%     data_spikes(chan_no,:)= TT.ParseEvInfoV(0,10000,6);






% % This is a highly simplified version of the call ReadEventsV. The only difference
% % in the two calls is in the arguments that the user needs to specify each time the
% % call is made. ReadEventsSimple uses global parameters which can be set using
% % the SetGlobalV, SetGlobalStringV, and SetGlobals

% TT.SetGlobals('Channel=1; Options=FILTERED; T2= 10')
% events = TT.ReadEventsSimple('Snip')





TT.CloseTank
TT.ReleaseServer















%% Release Server
TT.ReleaseServer