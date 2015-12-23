
sws1=[sleep_ind_pre(1):sleep_ind_pre(end)];
sws2=[sleep_ind_post(1):sleep_ind_post(end)];

temp1=(data(4,:));
temp2=data(6,:);
temp3=data(10,:);
M=mean(data([22 23 31],:));

FILTER_ORDER_t=4;
END_SMOOTHING_t=100;
srate_t = Fs_lfp;
nyq_sample_t=srate_t/2;
f_lo_t=25;
f_hi_t=0.3;
[bt,at]=butter(FILTER_ORDER_t,[f_hi_t f_lo_t]/nyq_sample_t);

temp1=(abs(filter(bt,at,temp2)));
temp2=(abs(filter(bt,at,temp1)));
        %data_filt1=smooth(data_filt1,END_SMOOTHING);
%         data_filt1=conv(data_filt1,ones(50,1))/50;
%         data_filt_hold(n,:)=data_filt1;


TS10=TimeStamps{18,2}*Fs_lfp;
% TS13=TimeStamps{13,2}*Fs_lfp;
% TS2=TimeStamps{2,2}*Fs_lfp;
% TS3=TimeStamps{3,2}*Fs_lfp;
% TS21=TimeStamps{21,2}*Fs_lfp;
% TS22=TimeStamps{22,2}*Fs_lfp;
% TS23=TimeStamps{23,2}*Fs_lfp;
% TS10=TimeStamps{10,2}*Fs_lfp;
% TS29=TimeStamps{29,2}*Fs_lfp;
% TS4=TimeStamps{21,2}*Fs_lfp;
% TS4=TimeStamps{24,2}*Fs_lfp;


%% raw data
figure
subplot(2,1,1)

temp1_s1=temp1(sws1);
temp1_s1=base_norm(temp1_s1);

temp2_s1=temp2(sws1);
temp2_s1=base_norm(temp2_s1);
% 
temp3_s1=temp3(sws1);
temp3_s1=base_norm(temp3_s1);

M_s=M(sws1);
M_s=base_norm(M_s);


%plot(temp1_s1);
%hold on
plot(temp2_s1,'g'); hold on
%plot(temp3_s1,'r');
plot(M_s,'k','LineWidth',1)
hold on;

s_ts=find(TS10>sws1(1));
e_ts=find(TS10<sws1(end));
ts=intersect(s_ts,e_ts);
TS10_s1=TS10(ts);
TS10_s1=TS10_s1-TS10_s1(1);
plot([TS10_s1; TS10_s1],[-1.5 -1],'r','LineWidth',2)

% 
% s_ts=find(TS13>sws1(1));
% e_ts=find(TS13<sws1(end));
% ts=intersect(s_ts,e_ts);
% TS13_s1=TS13(ts);
% TS13_s1=TS13_s1-TS13_s1(1);
% plot([TS13_s1; TS13_s1],[-2 -1.6],'r','LineWidth',2)
% 
% 
% s_ts=find(TS4>sws1(1));
% e_ts=find(TS4<sws1(end));
% ts=intersect(s_ts,e_ts);
% TS4_s1=TS4(ts);
% TS4_s1=TS4_s1-TS4_s1(1);
% plot([TS4_s1; TS4_s1],[-2.5 -2.1],'r','LineWidth',2)
% 
% s_ts=find(TS29>sws1(1));
% e_ts=find(TS29<sws1(end));
% ts=intersect(s_ts,e_ts);
% TS29_s1=TS29(ts);
% TS29_s1=TS29_s1-TS29_s1(1);
% plot([TS29_s1; TS29_s1],[-3.0 -2.4],'r','LineWidth',2)
% 
% s_ts=find(TS2>sws1(1));
% e_ts=find(TS2<sws1(end));
% ts=intersect(s_ts,e_ts);
% TS2_s1=TS2(ts);
% TS2_s1=TS2_s1-TS2_s1(1);
% plot([TS2_s1; TS2_s1],[-3.5 -3.1],'k','LineWidth',2)
% 
% s_ts=find(TS3>sws1(1));
% e_ts=find(TS3<sws1(end));
% ts=intersect(s_ts,e_ts);
% TS3_s1=TS3(ts);
% TS3_s1=TS3_s1-TS3_s1(1);
% plot([TS3_s1; TS3_s1],[-4.0 -3.4],'k','LineWidth',2)

subplot(2,1,2)

temp1_s1=temp1(sws2);
temp1_s1=base_norm(temp1_s1);

temp2_s1=temp2(sws2);
temp2_s1=base_norm(temp2_s1);

temp3_s1=temp3(sws2);
temp3_s1=base_norm(temp3_s1);

M_s=M(sws2);
M_s=base_norm(M_s);


%plot(temp1_s1);
%hold on
plot(temp2_s1,'g'); hold on
%plot(temp3_s1,'r');
plot(M_s,'k','LineWidth',1)
hold on;



s_ts=find(TS10>sws2(1));
e_ts=find(TS10<sws2(end));
ts=intersect(s_ts,e_ts);
TS10_s1=TS10(ts);
TS10_s1=TS10_s1-TS10_s1(1);
plot([TS10_s1; TS10_s1],[-1.5 -1],'r','LineWidth',2)


% s_ts=find(TS13>sws2(1));
% e_ts=find(TS13<sws2(end));
% ts=intersect(s_ts,e_ts);
% TS13_s1=TS13(ts);
% TS13_s1=TS13_s1-TS13_s1(1);
% plot([TS13_s1; TS13_s1],[-2 -1.6],'r','LineWidth',2)
% 
% 
% s_ts=find(TS4>sws2(1));
% e_ts=find(TS4<sws2(end));
% ts=intersect(s_ts,e_ts);
% TS4_s1=TS4(ts);
% TS4_s1=TS4_s1-TS4_s1(1);
% plot([TS4_s1; TS4_s1],[-2.5 -2.1],'r','LineWidth',2)
% 
% s_ts=find(TS29>sws2(1));
% e_ts=find(TS29<sws2(end));
% ts=intersect(s_ts,e_ts);
% TS29_s1=TS29(ts);
% TS29_s1=TS29_s1-TS29_s1(1);
% plot([TS29_s1; TS29_s1],[-3.0 -2.4],'r','LineWidth',2)
% 
% s_ts=find(TS2>sws2(1));
% e_ts=find(TS2<sws2(end));
% ts=intersect(s_ts,e_ts);
% TS2_s1=TS2(ts);
% TS2_s1=TS2_s1-TS2_s1(1);
% plot([TS2_s1; TS2_s1],[-3.5 -3.1],'k','LineWidth',2)
% 
% s_ts=find(TS3>sws2(1));
% e_ts=find(TS3<sws2(end));
% ts=intersect(s_ts,e_ts);
% TS3_s1=TS3(ts);
% TS3_s1=TS3_s1-TS3_s1(1);
% plot([TS3_s1; TS3_s1],[-4.0 -3.4],'k','LineWidth',2)

%% STA
% 10 hi snr
% 29 
% 2 3 4 7
close all
unit=18




TS10=TimeStamps{unit,2}*Fs_lfp;

len=3000;

figure
s_ts=find(TS10>sws1(1));
e_ts=find(TS10<sws1(end));
ts=intersect(s_ts,e_ts);
TS10_s1=TS10(ts);
size(TS10_s1)

% hold_rip1=[];
Num=length(TS10_s1);
hold_s1d=zeros(Num,len);
for n=1:Num
    ind=round(TS10_s1(n));
    pre_ind=ind-round(len/2)+1;
    post_ind=ind+round(len/2);
    hold_s1d(n,:)=temp1(pre_ind:post_ind);
%     hold_rip1=[hold_rip1, hold_s1d(n,:)];
end    
hold_s1d_tp=hold_s1d';
ripl_pre=reshape(hold_s1d_tp,1,(Num*len));

sta=mean(hold_s1d);
% plot(sta-mean(sta),'LineWidth',3)
sta_sd=std(hold_s1d)/sqrt(Num-1); hold on;
% plot((sta-mean(sta))+(2*sta_sd));
% plot((sta-mean(sta))-(2*sta_sd));
shadedErrorBar([],(sta-mean(sta)),(1*sta_sd),'g',0)
% plot((sta-mean(sta))+(1*sta_sd));
% plot((sta-mean(sta))-(1*sta_sd));
hold on;
s_ts=find(TS10>sws2(1));
e_ts=find(TS10<sws2(end));
ts=intersect(s_ts,e_ts);
TS10_s2=TS10(ts);

Num=length(TS10_s2);
hold_s1d=zeros(Num,len);
for n=1:Num
    ind=round(TS10_s2(n));
    pre_ind=ind-round(len/2)+1;
    post_ind=ind+round(len/2);
    hold_s1d(n,:)=temp1(pre_ind:post_ind);
end    

hold_s1d_tp=hold_s1d';
ripl_post=reshape(hold_s1d_tp,1,(Num*len));


sta=mean(hold_s1d);
sta_sd=std(hold_s1d)/sqrt(Num-1);
hold on
shadedErrorBar([],(sta-mean(sta)),(1*sta_sd),'r',0)
% plot(sta-mean(sta),'r','LineWidth',3); 
% plot((sta-mean(sta))+sta_sd,'r');
% plot((sta-mean(sta))-sta_sd,'r');
% 
filename=['C:\Users\Ganguly Lab\Documents\MATLAB\Tanuj\Mat_files\Result_figs\BMI\S32\5_3_13\Ch' num2str(unit) '.tiff'];
%                     saveas(gcf,filename);


