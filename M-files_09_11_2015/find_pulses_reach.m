%%
function [trials_markers]=find_pulses_reach(wave,data)
%%
wave=wave(1,:);
temp3=wave>.05;
plot(temp3)
length_to_analyze=length(wave);
block=1:length_to_analyze;
dec_factor=1;

hold on
start_times=diff(temp3)>0.5;
[start_times]=find(start_times==1);
two_pulses=diff(start_times);

gaps=(find(two_pulses>20));
find_gaps=[0 gaps];
find_gaps=diff(find_gaps);
five_pulses=find(find_gaps==5);
five_pulses_time=gaps(five_pulses);

four_pulses=find(find_gaps==4);
four_pulses_time=gaps(four_pulses);

clear two_pulses;

two_pulses=find(find_gaps==2);
two_pulses_time=gaps(two_pulses);
Pellet=[];
for n = 1:length(find_gaps)
    if(find_gaps(n)==3||find_gaps(n)==4) 
        if (find_gaps(n+1)==5 && find_gaps(n+5)==2)
        Pellet = [Pellet n];
        end
    end
end

three_pulses=diff(diff(start_times));
three_pulses2=find(three_pulses<10 & three_pulses>-10);

hold_index1=[];

for n=2:(length(three_pulses2))
    hold_index1=[hold_index1 (three_pulses2(n))];
end


%eliminate five pulses from trial numbers
r_fives=[1];
thresh=3;
for n=2:length(five_pulses)
    if (five_pulses(n)-five_pulses(n-1)) > thresh
        r_fives=[r_fives n];
    end
end
r_five_pulses_time=five_pulses_time(r_fives);

%have a marker for first four pulse (when audio cue comes on)
r_fours=[];
thresh2=5;
for n=2:length(four_pulses)
  
    if(n > length(four_pulses)) break;
        
    elseif (four_pulses(n)- four_pulses(n-1)) <= thresh2
        r_fours=[r_fours n-1];
        four_pulses(n)=[];
        n=n-1;
    end
end
%       if (four_pulses(n)- five_pulses(r_fives(n))) ~= thresh2
%           four_pulses(n)=[];
%            if (four_pulses(n)- five_pulses(r_fives(n))) ~= thresh2
%           four_pulses(n)=[];
%            end
%       end

r_four_pulses_time=gaps(four_pulses);

%have a marker for two pulses 
two_pulsesnew=[];
for n = 5:length(find_gaps)
    if(find_gaps(n)==2 &&(find_gaps(n-4))==5)
        two_pulsesnew = [two_pulsesnew n];
    end
end
 four_pulsesnew=[];
for n = 4:length(find_gaps)
    if(find_gaps(n)==4 &&(find_gaps(n-3))==5)
        four_pulsesnew = [four_pulsesnew n];
    end
end
three_pulses=[];
for n = 6:length(find_gaps)
    if(find_gaps(n)==3 &&(find_gaps(n-5))==5)
        three_pulses = [three_pulses n];
    end
end
r_three_pulses_time=gaps(three_pulses);
r_four_pulses_time=gaps(four_pulsesnew);
r_two_pulses_time=gaps(two_pulsesnew);

beambreak_markers=start_times(r_three_pulses_time);

% two_pulses=diff(start_times);
% two_pulses2=find(two_pulses<40);
% 
% 
% only look for two pulse
hold_index=[];
two_pulses2=find(two_pulses<40);

for n=2:(length(two_pulses2)-2)
    temp1=two_pulses(two_pulses2(n)+1);
    temp2=two_pulses(two_pulses2(n)-1);
    if (temp1 < 40) && (temp2 > 40)
        hold_index=[hold_index (two_pulses2(n))];
     end
end

plot(start(hold_index),[1],'rx')
Reward=start(hold_index);
    
plot(start_times(gaps),1,'k*')
plot(start_times(five_pulses_time),1,'g*')
plot(start_times(r_five_pulses_time),1,'r*')
plot(start_times(r_four_pulses_time),1,'c*')
plot(start_times(r_two_pulses_time),1,'y*')

trials_markers=start_times(r_five_pulses_time);
cue_markers=start_times(r_four_pulses_time);
dooropen_markers=start_times(r_two_pulses_time);
beambreak_markers=start_times(r_three_pulses_time);

for i=1:length(trials_markers)-2
    dooropen_ind=find(dooropen_markers>trials_markers(i) & dooropen_markers<trials_markers(i)+7000, 1,'last');
    if (~isempty(dooropen_ind))
    dooropen_markers1(:,i)=dooropen_markers(dooropen_ind);
    end
end

for i=1:length(cue_markers)-2
    cue_ind=find(cue_markers>trials_markers(i) & cue_markers<trials_markers(i)+3000, 1,'last');
    if (~isempty(cue_ind))
    cue_markers1(:,i)=cue_markers(cue_ind);
    end
end


for i=length(dooropen_markers1)
    beambreaker_ind=find(beambreak_markers>dooropen_markers1(i) & beambreak_markers<dooropen_markers1(i)+10000, 1,'last');
    if (~isempty(beambreaker_ind))
    beambreaker_markers1(:,i)=beambreak_markers(beambreaker_ind)
    end
end


% taking out no response trials (only for R20 Block 10)
% beambreaker_markers1=beambreaker_markers1(:,[2:5 7:12 14:25 27:33 35  38 39 41 43 44 46 47 48 50 51]) %beambreaker_markers1(:,27:36) beambreaker_markers1(:,38:41) beambreaker_markers1(:,43:44) beambreaker_markers1(:,46:51) ]
% dooropen_markers1=dooropen_markers1(:,[2:5 7:12 14:25 27:33 35  38 39 41 43 44 46 47 48 50 51])% dooropen_markers1(:,27:36) dooropen_markers1(:,38:41) dooropen_markers1(:,43:44) dooropen_markers1(:,46:51) ]
% cue_markers1=cue_markers1(:,[2:5 7:12 14:25 27:33 35  38 39 41 43 44 46 47 48 50 51]) %cue_markers1(:,27:36) cue_markers1(:,38:41) cue_markers1(:,43:44) cue_markers1(:,46:51) ]
% trials_markers=trials_markers(:,[2:5 7:12 14:25 27:33 35 38 39 41 43 44 46 47 48 50 51]) %trials_markers(:,27:36) trials_markers(:,38:41) trials_markers(:,43:44) trials_markers(:,46:53) ]


% clear hold_paths1 hold_paths2
%     nh1=[2:5 7:12 14:25 27:33 35 38 39 41 43 44 46 47 48]
%     for i=1:38
% hold_paths1{i}=hold_paths{nh1(i)}
%   
%      end
%       
%         nh1=[2:5 7:12 14:25 27:33 35 38 39 41 43 44 46 47 48]
%     for i=1:38
% hold_starts1{i}=hold_starts{nh1(i)}
%   
%       end


%         
%         
% plot(beambreaker_markers1,'y*')
% hold off
% figure;
% trials_markers1=trials_markers(:,1:(end-2));
% cue_markers2=cue_markers1(:,1:end-2);
% dooropen_markers2=dooropen_markers1(:,1:end-2);
% beambreaker_markers2=beambreaker_markers1(:,1:end-2);
% xt=[1 2 3 4];
% plot(xt(1),trials_markers1-trials_markers1,'k*'); hold on;
% plot(xt(2),[cue_markers2-trials_markers1],'r*'); 
% plot(xt(3),[dooropen_markers2-trials_markers1],'y*'); 
% plot(xt(4),[beambreaker_markers2-trials_markers1],'g*'); 
hold off;
figure;
strobe=wave(1,block);
strobe=decimate(strobe,dec_factor);
plot(data(1,:));hold on; plot(wave(1,:),'c'); hold on; plot(strobe(1,:),'r-'); hold off
length(strobe)
length(wave)
length(data)
figure;
plot(temp3)
hold on
% cue_markers3=cue_markers2-12.62;
% dooropen_markers3=dooropen_markers2-4;
% beambreaker_markers3=beambreaker_markers2-4;
% trials_markers2=trials_markers1-17;

% plot(cue_markers3,1,'g*')
% plot(dooropen_markers3,1,'k*')
% plot(beambreaker_markers3,1,'y*')
% plot(trials_markers2,1,'r*')
% 
% 
%xlim([12600 20600])
