
function [trials_markers,pelletdrop_markers, trial_no,rs]=find_pulses_reach_dr2(wave)
%%
%trial structure is: trial onset(5); trial number (+1+1); door open (4),
%audio cue (2) (3)

wave=wave(1,:);
plot(wave);
[~,y]=ginput(1);
temp3=wave>y;
length_to_analyze=length(wave);
block=1:length_to_analyze;
dec_factor=1;

close all;

start_times=diff(temp3)>0.5;
[start_times]=find(start_times==1);
two_pulses=diff(start_times);

gaps=(find(two_pulses>20));
find_gaps=[0 gaps];
find_gaps=diff(find_gaps);

%Get trial onsets (5_pulses)
five_pulses=[];
three_pulses=[];
four_pulses=[];
trial_no = [];
att_trial_no=[];

%5 1 3 4 2 (3) 5 2 1 4 4 2 (3) 5 2 1 5 4 2 5 2 1 6 4 2 (3)
count = 0;
for n = 1:length(find_gaps)
    if (n<3)
        if(find_gaps(n)==5)
            five_pulses = [five_pulses n];
            trial_no= [trial_no; find_gaps(n+1)-1, find_gaps(n+2)-1,NaN];
            count = count+1;
        end
    else
        if (find_gaps(n)==5 &&~(find_gaps(n-1)==5 || find_gaps(n-2)==5))
            if length(find_gaps)>n+3
            count = count+1;
            five_pulses = [five_pulses n];
            if count+1<100
                trial_no= [trial_no; find_gaps(n+1)-1, find_gaps(n+2)-1,NaN];
            else
                trial_no= [trial_no; find_gaps(n+1)-1, find_gaps(n+2)-1,find_gaps(n+3)-1,];
            end
            if(find_gaps(n-1)==3 & count>1)
                three_pulses = [three_pulses n-1];
                rs(count-1) =1;
            
            elseif count>1
                rs(count-1) =0;
            end
            end
            if(find_gaps(n+3)==4)
                four_pulses=[four_pulses n+3];
            end
        end
    end
end



r_five_pulses_time=gaps(five_pulses);
r_three_pulses_time=gaps(three_pulses);
r_four_pulses_time=gaps(four_pulses);

trials_markers=start_times(r_five_pulses_time);
pelletdrop_markers=start_times(r_three_pulses_time);
door_open_marker = start_times(r_four_pulses_time);
disp ('end');


