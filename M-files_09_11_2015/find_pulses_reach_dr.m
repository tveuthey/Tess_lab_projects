
function [trials_markers,pelletdrop_markers, trial_no]=find_pulses_reach_dr(wave,data)
%%
%trial structure is: trial onset(5); trial number (+1+1); door open (4),
%audio cue (2) (3)

wave=wave(1,:);
thr = max(wave)*0.8
temp3=wave>thr;
%plot(temp3)
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
% five_pulses=find(find_gaps==5);

%Get trial onsets (5_pulses)
five_pulses=[];
three_pulses=[];
trial_no = [];
att_trial_no=[];

count = 0;
for n = 1:length(find_gaps)
    if (n<3)
        if(find_gaps(n)==5)
            five_pulses = [five_pulses n];
            trial_no= [trial_no; find_gaps(n+1)-1, find_gaps(n+2)-1,NaN];
            count = count+1;
        end
    else
        %if(find_gaps(n)==5 &&(find_gaps(n+3)==4 ||find_gaps(n+3)==3))
        if (find_gaps(n)==5 &&~(find_gaps(n-1)==5 || find_gaps(n-2)==5))
            if count+1<100
            count = count+1;
            five_pulses = [five_pulses n];
            trial_no= [trial_no; find_gaps(n+1)-1, find_gaps(n+2)-1,NaN];
            else
                if (find_gaps(n)==5 &&~(find_gaps(n-1)==5 || find_gaps(n-2)==5||find_gaps(n-3)==5))
                    five_pulses = [five_pulses n];
                    trial_no= [trial_no; find_gaps(n+1)-1, find_gaps(n+2)-1,find_gaps(n+3)-1,];
                end
            end
            if(find_gaps(n-1)==3)
                three_pulses = [three_pulses n];
                att_trial_no=[att_trial_no;find_gaps(n+1)-1, find_gaps(n+2)-1]
            end
        end
    end
end

%%%Marker for pellet-drop: should be 3 but sometimes is 4 pulses.
% att_trial=10*att_trial_no(:,1)+att_trial_no(:,2);
% att_trial=att_trial-1;

% for n = 1:length(find_gaps)
%     if(find_gaps(n)==3||find_gaps(n)==4)
%         if (find_gaps(n+1)==5 && find_gaps(n+5)==2)
%         three_pulses = [three_pulses n];
%         end
%     end
% end

%marker for two pulses - dooropens
% two_pulses=[];
% for n = 5:length(find_gaps)
%     if(find_gaps(n)==2 &&(find_gaps(n-4))==5)
%         two_pulses = [two_pulses n];
%     end
% end
%marker for first four pulse (when audio cue comes on)
%  four_pulses=[];
% for n = 4:length(find_gaps)
%     if(find_gaps(n)==4 &&(find_gaps(n-3))==5)
%         four_pulses = [four_pulses n];
%     end
% end
r_five_pulses_time=gaps(five_pulses);
r_three_pulses_time=gaps(three_pulses);
% r_four_pulses_time=gaps(four_pulses);
% r_two_pulses_time=gaps(two_pulses);

% plot(start_times(gaps),1,'k*')
% plot(start_times(r_five_pulses_time),1,'r*')
% plot(start_times(r_four_pulses_time),1,'c*')
% plot(start_times(r_two_pulses_time),1,'y*')

trials_markers=start_times(r_five_pulses_time);
% cue_markers=start_times(r_four_pulses_time);
% dooropen_markers=start_times(r_two_pulses_time);
pelletdrop_markers=start_times(r_three_pulses_time);

% for i=1:length(trials_markers)-2
%     dooropen_ind=find(dooropen_markers>trials_markers(i) & dooropen_markers<trials_markers(i)+7000, 1,'last');
%     if (~isempty(dooropen_ind))
%     dooropen_markers1(:,i)=dooropen_markers(dooropen_ind);
%     end
% end
%
% for i=1:length(cue_markers)-2
%     cue_ind=find(cue_markers>trials_markers(i) & cue_markers<trials_markers(i)+3000, 1,'last');
%     if (~isempty(cue_ind))
%     cue_markers1(:,i)=cue_markers(cue_ind);
%     end
% end
%
%
% for i=length(dooropen_markers1)
%     pelletdroper_ind=find(pelletdrop_markers>dooropen_markers1(i) & pelletdrop_markers<dooropen_markers1(i)+10000, 1,'last');
%     if (~isempty(pelletdroper_ind))
%     pelletdroper_markers1(:,i)=pelletdrop_markers(pelletdroper_ind)
%     end
% end
%

% taking out no response trials (only for R20 Block 10)
% pelletdroper_markers1=pelletdroper_markers1(:,[2:5 7:12 14:25 27:33 35  38 39 41 43 44 46 47 48 50 51]) %pelletdroper_markers1(:,27:36) pelletdroper_markers1(:,38:41) pelletdroper_markers1(:,43:44) pelletdroper_markers1(:,46:51) ]
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
% plot(pelletdroper_markers1,'y*')
% hold off
% figure;
% trials_markers1=trials_markers(:,1:(end-2));
% cue_markers2=cue_markers1(:,1:end-2);
% dooropen_markers2=dooropen_markers1(:,1:end-2);
% pelletdroper_markers2=pelletdroper_markers1(:,1:end-2);
% xt=[1 2 3 4];
% plot(xt(1),trials_markers1-trials_markers1,'k*'); hold on;
% plot(xt(2),[cue_markers2-trials_markers1],'r*');
% plot(xt(3),[dooropen_markers2-trials_markers1],'y*');
% plot(xt(4),[pelletdroper_markers2-trials_markers1],'g*');
% hold off;
% figure;
% strobe=wave(1,block);
% %strobe=decimate(strobe,dec_factor);
% plot(data(1,:));hold on; plot(wave(1,:),'c'); hold on; plot(strobe(1,:),'r-'); hold off
% length(strobe)
% length(wave)
% length(data)
% figure;
% plot(temp3)
% hold on

% PDrop = pelletdrop_markers;
%Reward = Reach;
% cue_markers3=cue_markers2-12.62;
% dooropen_markers3=dooropen_markers2-4;
% pelletdroper_markers3=pelletdroper_markers2-4;
% trials_markers2=trials_markers1-17;

% plot(cue_markers3,1,'g*')
% plot(dooropen_markers3,1,'k*')
% plot(pelletdroper_markers3,1,'y*')
% plot(trials_markers2,1,'r*')
%
disp ('end');
%xlim([12600 20600])

