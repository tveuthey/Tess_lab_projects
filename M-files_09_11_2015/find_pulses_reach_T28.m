
function [trials_markers,two_pulses]=find_pulses_reach_T28(wave,thr)
%%
global two_pulses;
wave=wave(1,:);
temp3=wave>.1;
close all;

length_to_analyze=length(wave);
block=1:length_to_analyze;

start_time
s=diff(temp3>0.5);
[start_times]=find(start_times==1);
two_pulses=diff(start_times);
two_pulses = [15000 two_pulses];
gaps=(find(two_pulses>100));
find_gaps=[gaps];
find_gaps=diff(find_gaps);
start = find(two_pulses>thr);
%Get trial onsets (5_pulses) 

%%%Marker for pellet-drop: should be 3 but sometimes is 4 pulses.
trials_markers=start_times(start);
