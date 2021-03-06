%%
%temp2=temp2(block);
%lever1=lever1(block);
%Slever2=lever2(block);

% find the trial data (ALWAYS RUN PRIOR TO BELOW)
close all;figure
length_to_analyze=length(data);
block=1:length_to_analyze;
clear temp3 two_pulses start two_pulses2 hold_index hold_index2 hold_index_temp start_a start_b start_trial
temp3=wave(1,block)>.05;
plot(temp3)
hold on
start=diff(temp3)>0.5;
[start]=find(start==1);

plot(start,[1],'g*')
%hold_index again

% two_pulses=diff(start);
% two_pulses2=find(two_pulses<400);

% %only look for two pulse
% hold_index=[];
% 
% for n=2:(length(two_pulses2)-2)
%     temp1=two_pulses(two_pulses2(n)+1);
%     temp2=two_pulses(two_pulses2(n)-1);
%     if (temp1  > 40) && (temp2 > 40)
%         hold_index=[hold_index (two_pulses2(n))];
%     end
% end
% 
% 
% plot(start(hold_index),[1],'kx')
% Reward=start(hold_index);

pulse2=find(diff(start)<1000);
start_pulse2=start(pulse2);
plot(start_pulse2,1,'r+')
% start_b=start(two_pulses2);
clear hold_index_temp
hold_index_temp=[];
for n=1:length(start_pulse2)
    i=find((start>start_pulse2(n)),1,'first')
    hold_index_temp=[hold_index_temp start(i)]
    
end

plot(hold_index_temp,1,'c>')

start_trial=[]
for n=1:length(start)
    if ismember (start(n),[hold_index_temp start_pulse2])==0
        start_trial=[start_trial start(n)]
    else
        disp('discounted')
    end
end
plot(start_trial,1,'k*')


%%
%only look for three pulse
three_pulses=diff(diff(start));
three_pulses2=find(three_pulses<10 & three_pulses>-10);
hold_index1=[];
for n=2:(length(three_pulses2)-1)
    hold_index1=[hold_index1 (three_pulses2(n))];
end
plot(start(hold_index1),[1],'kx')
Reach=start(hold_index1);

for i=1:length(Reward)
    Reach_ind=find(Reach>Reward(i) & Reach<Reward(i)+10000, 1,'last');
    ReachN(:,i)=Reach(Reach_ind)
end
plot(ReachN,[1],'yx')

%only look for five pulse
five_pulses=diff(diff(diff(diff(start))));
five_pulses2=find(five_pulses<10 & five_pulses>-10);
hold_index2=[];
for n=1:length(five_pulses2)
    hold_index2=[hold_index2 (five_pulses2(n))];
end
plot(start(hold_index2),[1],'co')
Trial=start(hold_index2);

for i=1:length(Reward)
    Trial_ind=find(Trial<Reward(i) & Trial<(Reward(i)-8000), 1,'first');
    TrialN(:,i)=Trial(Trial_ind)
end
plot(TrialN,[1],'yo')


%Reach=start(hold_index1([2 3 4 7 9 10 11 12 13 14 16 18 22 24]));
