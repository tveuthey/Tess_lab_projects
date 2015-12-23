
function [trials_markers,pelletdrop_markers, trial_no]=find_pulses_reach_M1str(wave)

%trial structure is: trial onset(2); pellet_drop(1); trial number (+1+1);

% wave=wave(1,:);
thr = max(wave)*0.8;
temp3=wave>thr;
%plot(temp3)
length_to_analyze=length(wave);
block=1:length_to_analyze;
dec_factor=1;

start_times=diff(temp3)>0.5;
[start_times]=find(start_times==1);
two_pulses=diff(start_times); %each entry - the one before (two_pulses = space between each change)

gaps=(find(two_pulses>20)); % index of start of gaps long (#entries = # gaps = # pulses)
find_gaps=[0 gaps'];
find_gaps=diff(find_gaps); %difference in indices of gaps
% five_pulses=find(find_gaps==5);

%Get trial onsets (5_pulses)
two_pulses=[];
one_pulse=[];
trial_no = [];

count = 0;
for n = 1:length(find_gaps)-1
    if(find_gaps(n)==2) %there were 2 units of time between 
        if(find_gaps(n+1)==1)
            two_pulses = [two_pulses n];
            one_pulse= [one_pulse n+1];
            if length(find_gaps)>n+2
            trial_no= [trial_no; find_gaps(n+2)-1, find_gaps(n+3)-1];
            end
            count = count+1;
        end
        
    end
    
end

r_two_pulses_time=gaps(two_pulses);
r_one_pulse_time=gaps(one_pulse);

trials_markers=start_times(r_two_pulses_time);
pelletdrop_markers=start_times(r_one_pulse_time);

d=pelletdrop_markers-trials_markers;
pelletdrop_markers(d>14900)=[];
    
end