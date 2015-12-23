
function [correct_beamblock_starts,beamblock_starts,pelletdrop_markers]=find_pulses_reach_M1M2_TV_20150925(wave)

%trial structure is: start wait (3) SOMETIMES ONLY BE 2 PULSES; correct trial (4); leave late (5);
%door open (2) INCONSISTENT PRESENCE BECAUSE OF DOOR NOISE; pellet drop
%(1); trial number (number of digits + position in that set of 10 +1. eg:
%trial 1 = 1+2

%door noise: starts off bewtween 0.2 and 0.5, then oscillated between 0.1
%and 0.5

%make signal binary
thr = max(wave)*0.8; %determined by looking at wave signal.
temp3 = wave>thr;

%% find times when back sensor was blocked for more than 500 ms, save as beamblock_starts
wave_samp_freq = 1.017252624511719e+03;

start_times = diff(temp3)>0.5; %detect when there is a POSTITIVE change in signal (1= index where there is change)
[start_times] = find(start_times == 1); %indices where there was a POSTITIVE change
beamblock_starts = [];
for starts = [start_times']; %needs to be a row vector
    if mean(temp3((starts+1):(starts+round(wave_samp_freq*0.5)))) == 1
        beamblock_starts = [beamblock_starts starts];
    end
end

beamblock_starts = beamblock_starts';

%% find times when back sensor was blocked 3000-5000 ms, save as beamblock_starts

start_times = diff(temp3)>0.5; %detect when there is a POSTITIVE change in signal (1= index where there is change)
[start_times] = find(start_times == 1); %indices where there was a POSTITIVE change
correct_beamblock_starts = [];
for starts = [start_times']; %needs to be a row vector
    if mean(temp3((starts+1):(starts+round(wave_samp_freq*3)))) == 1 && mean(temp3((starts+1):(starts+round(wave_samp_freq*5)))) < 1
        correct_beamblock_starts = [correct_beamblock_starts starts];
    end
end

correct_beamblock_starts = correct_beamblock_starts';

%% find pellet drop times based on pulse spacing (not work)

%based on spacing between pulses
thr2 = 0.6; %based on looking at wave channel and amplitude of pellet drop pulse in the middle of door noise
temp4 = wave > thr2;
start_times2 = diff(temp4)>0.5; %detect when there is a POSTITIVE change in signal (1= index where there is change)
[start_times2] = find(start_times2 == 1); %indices where there was a POSTITIVE change

% two_pulses=diff(start_times); %each entry - the one before (the difference between instances of temp3 signal INCREASE)
% gaps=(find(two_pulses>20)); % which of the gaps was long (by their position in a list of gaps)
% find_gaps=[0 gaps'];
% find_gaps=[diff(find_gaps)]'; %which gaps were big, relative to the previous number in the list (where 5=5th gap, inclusive)
% % five_pulses=find(find_gaps==5);
%
% pelletdrop_markers=[];
% for n = 1:length(find_gaps)-1;
%     if(find_gaps(n)==1); %there were 2 big gaps in a row (1 = the first gap after the last big gap seen was also a big gap)
%         if(find_gaps(n+1)==1);%there were 3 big gaps
%             if ~ismember(start_times(sum(find_gaps(1:n))), beamblock_starts);
%                 pelletdrop_markers = [pelletdrop_markers start_times(sum(find_gaps(1:n)))];
%             end
%         end
%     end
% end
%
% pelletdrop_markers = pelletdrop_markers';


%% find pellet drop times based on door noise

door_noise = (0.2 < wave) & (wave < 0.5); %detect when wave value is between 0.2 and 0.5 (~ range door noise)
door_open_times = diff(door_noise)>0.5; %matrix of each value - the previous one
[start_times_door] = find(door_open_times == 1); %indices where there was a POSTITIVE change
door_open_starts = [];
for starts = [start_times_door']; %needs to be a row vector
    if mean(door_noise((starts+1):(starts+200))) == 1
        door_open_starts = [door_open_starts starts];
    end
end

door_open_starts = door_open_starts';

%double-check number of door openings picked out vs. correct wait trials
%from video trial data
% count=0;
% for n=1:length(task_parameters.trial_status)
%     if task_parameters.trial_status(n) ==1
%         count = count +1;
%     end
% end

%combine door_open_starts with start_times 2, then order the list
start_times3 = [start_times2' door_open_starts'];
start_times3 = sort(start_times3);

pelletdrop_markers = [];

%pick out 1st time that wave crosses threshold after door noise starts
%limit to values for which the next peak comes after more than 100 time units (~100ms)
for n = 1:length(start_times3);
    if ismember(start_times3(n),door_open_starts);
        if start_times3(n+2)-start_times3(n+1) >100;
            pelletdrop_markers = [pelletdrop_markers start_times3(n+1)];
        end
    end
end

% %check visually
% for n = 1:length(pelletdrop_markers);
%     plot(wave((pelletdrop_markers(n)-100):(pelletdrop_markers(n)+100)))
%     pause(1)
% end





% two_pulses = [two_pulses n];
% one_pulse= [one_pulse n+1];
% if length(find_gaps)>n+2
%     trial_no= [trial_no; find_gaps(n+2)-1, find_gaps(n+3)-1];
% end
% count = count+1;
% end
% 
% end
% 
% end
% 
% r_two_pulses_time=gaps(two_pulses);
% r_one_pulse_time=gaps(one_pulse);
% 
% trials_markers=start_times(r_two_pulses_time);
% pelletdrop_markers=start_times(r_one_pulse_time);
% 
% d=pelletdrop_markers-trials_markers;
% pelletdrop_markers(d>14900)=[];
% 
% end