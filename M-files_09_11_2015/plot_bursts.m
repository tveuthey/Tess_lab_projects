
function Output=plot_bursts(data, Fs_lfp, wave, TimeStamps,chan_lfp,chan_no, sc, ind_pre, ind_post)
close all
data1=data(chan_lfp(1),:);
datam=mean(data(chan_lfp,:));

sws1=ind_pre(1):ind_pre(end);
sws2=ind_post(1):ind_post(end);

if length(sws1)<=length(sws2)
    sws2=sws2(1:length(sws1));
else
    if length(sws2)<length(sws1)
    sws1=sws1(1:length(sws2));
    end
end

t=(0:1:length(sws1)-1)/Fs_lfp;

FILTER_ORDER_t=3;
END_SMOOTHING_t=100;
srate_t = Fs_lfp;
nyq_sample_t=srate_t/2;
f_lo_t=3;
f_hi_t=0.3;
[bt,at]=butter(FILTER_ORDER_t,[f_hi_t f_lo_t]/nyq_sample_t);

temp1=(filtfilt(bt,at,data1));
temp2=(filtfilt(bt,at,datam));
%data_filt1=smooth(data_filt1,END_SMOOTHING);
%         data_filt1=conv(data_filt1,ones(50,1))/50;
%         data_filt_hold(n,:)=data_filt1;

% for i=1:length(chan_no)
%     TS_num2str(i)=TimeStamps{i,sc}*Fs_lfp;
% end


% raw data
figure
subplot(1,2,1)

temp1_s1=temp1(sws1);
temp1_s1=base_norm(temp1_s1);

temp2_s1=temp2(sws1);
temp2_s1=base_norm(temp2_s1);



%plot(temp1_s1);
%hold on
plot(temp1_s1,'g'); hold on
%plot(temp3_s1,'r');
plot(temp1_s1,'k','LineWidth',1)
hold on;

for i=1:length(chan_no)
    TS10=TimeStamps{chan_no(i),sc}*Fs_lfp;
    s_ts=find(TS10>sws1(1));
    e_ts=find(TS10<sws1(end));
    ts=intersect(s_ts,e_ts);
    TS10_s1=TS10(ts);
    TS10_s1=TS10_s1-TS10_s1(1);
    if i==1
        plot([TS10_s1; TS10_s1],[-1.9-i -1.2-i],'r','LineWidth',2); hold on
    else
        if i==2
            plot([TS10_s1; TS10_s1],[-1.9-i -1.2-i],'r','LineWidth',2); hold on
        else
            plot([TS10_s1; TS10_s1],[-1.9-i -1.2-i],'b','LineWidth',2); hold on
        end
    end
end


%
% s_ts=find(TS13>sws1(1));
% e_ts=find(TS13<sws1(end));
% ts=intersect(s_ts,e_ts);
% TS13_s1=TS13(ts);
% TS13_s1=TS13_s1-TS13_s1(1);
% plot([TS13_s1; TS13_s1],[-2 -1.6],'r','LineWidth',2)
%
%


subplot(1,2,2)

temp1_s1=temp1(sws2);
temp1_s1=base_norm(temp1_s1);

temp2_s1=temp2(sws2);
temp2_s1=base_norm(temp2_s1);


plot(temp1_s1,'g'); hold on

plot(temp1_s1,'k','LineWidth',1)
hold on;



for i=1:length(chan_no)
    TS10=TimeStamps{chan_no(i),sc}*Fs_lfp;
    s_ts=find(TS10>sws2(1));
    e_ts=find(TS10<sws2(end));
    ts=intersect(s_ts,e_ts);
    TS10_s1=TS10(ts);
    TS10_s1=TS10_s1-TS10_s1(1);
    if i==1
        plot([TS10_s1; TS10_s1],[-1.9-i -1.2-i],'r','LineWidth',2); hold on
    else
        if i==2
            plot([TS10_s1; TS10_s1],[-1.9-i -1.2-i],'r','LineWidth',2); hold on
        else
            plot([TS10_s1; TS10_s1],[-1.9-i -1.2-i],'b','LineWidth',2); hold on
        end
    end
end

Output=length(TS10_s1)