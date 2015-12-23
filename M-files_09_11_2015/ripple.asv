% filter sleep for sws, spindles, ripples

FILTER_ORDER=5;
srate = Fs_lfp; 
nyq_sample=srate/2;


figure;
% t_phrase='PRE'
% % Pre-learning
% ind_s=6.26*10^5;
% ind_e=1.16*10^6;


% %post_learning
% t_phrase='POST'
ind_s=sleep_ind_post(1);
ind_e=sleep_ind_post(end);

% 
% ind_s=2.04*10^6;
% ind_e=2.31*10^6;


y=data2(1,ind_s:ind_s+250000);

TS10=TimeStamps{2,2};
TS10_2a=find(TS10>ind_s/Fs_lfp);
TS10_2b=find(TS10>((ind_s+250000))/Fs_lfp);
TS10_2=TS10(TS10_2a(1):TS10_2b(1));
TS10_2=TS10_2-ind_s/Fs_lfp;

temp=y;
temp=(temp-mean(temp))/(std(temp));
plot(temp+20,'Color',[0.6 0.6 0.6]);hold on

plot(xlim,[23.5 23.5],'c')


%%

f_lo=250
f_hi=120
[b2,a2]=butter(FILTER_ORDER,[f_hi f_lo]/nyq_sample);
temp=(filter(b2,a2,y));
temp=(temp-mean(temp))/(std(temp));
plot(temp)
hold on;
plot(xlim,[std(temp) std(temp)],'g')

%%

f_lo=18
f_hi=8
[b2,a2]=butter(FILTER_ORDER,[f_hi f_lo]/nyq_sample);
temp=(filter(b2,a2,y));
temp=(temp-mean(temp))/(std(temp));
offset=8;
temp=temp+offset;
plot(temp)
plot(xlim,[std(temp) std(temp)]+offset,'g')
%%

FILTER_ORDER=3;
f_lo=3
f_hi=0.3
[b2,a2]=butter(FILTER_ORDER,[f_hi f_lo]/nyq_sample);
temp=(filter(b2,a2,y));
temp=(temp-mean(temp))/(std(temp));
offset=16;
temp=temp+offset;
plot(temp)
plot(xlim,[std(temp) std(temp)]+offset,'g')

plot([TS10_2; TS10_2]*Fs_lfp,[10 15],'r');