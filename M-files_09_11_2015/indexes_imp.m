%%

figure
temp3=wave(1,block)>2;
plot(temp3)
hold on
start=diff(temp3)>0.5;
[start]=find(start==1);


%only look for five pulse
five_pulses=diff(diff(diff(diff(start))));
five_pulses2=find(five_pulses<10 & five_pulses>-10);


hold_index2=[];
for n=2:(length(five_pulses2)-1)
    temp51=five_pulses(five_pulses2(n)+1);
    temp52=five_pulses(five_pulses2(n)-1);
    if(temp51  > 40) && (temp52 > 40) 
        %if (temp52  > 10) && (temp52 < -10)
        hold_index2=[hold_index2 (five_pulses2(n))];
       %end
    end
    
end
plot(start(hold_index2),[1],'co')
Trial=start(hold_index2);

%only look for two pulse
two_pulses=diff(start);
two_pulses2=find(two_pulses<40);


hold_index=[];

for n=2:(length(two_pulses2)-2)
    temp1=two_pulses(two_pulses2(n)+1);
    temp2=two_pulses(two_pulses2(n)-1);
    if (temp1  > 40) && (temp2 > 40)
        hold_index=[hold_index (two_pulses2(n))];
    end
end

plot(start(hold_index),[1],'rx')
Reward=start(hold_index);