function [Output]=compare_sleep_Xgrams (TimeStamps,chan_no,data,sleep_ind_pre, sleep_ind_post,wave,Fs_lfp,Waves,N,sc,bin_size,space)
Fs_SPK=24413;
close all;
TS1=TimeStamps{chan_no(1),sc};
TS2=TimeStamps{chan_no(2),sc};
l1=length(sleep_ind_pre);
l2=length(sleep_ind_post);

if length(sleep_ind_pre(1):sleep_ind_pre(end))<length(sleep_ind_post(1):sleep_ind_post(end))
    sleep_ind_pre1=[sleep_ind_pre(1):sleep_ind_pre(end)];
    sleep_ind_post2=sleep_ind_post(1):sleep_ind_post(end);
    sleep_ind_post1=sleep_ind_post2(1:length(sleep_ind_pre1));
else
    sleep_ind_post1=[sleep_ind_post(1):sleep_ind_post(end)];
    sleep_ind_pre2=sleep_ind_pre(1):sleep_ind_pre(end);
    sleep_ind_pre1=sleep_ind_pre2(1:length(sleep_ind_post1));
    
end
data2=median(data);
data2=(data2-mean(data2))/2*std(data2);
data2=resample(data2,1000,round(Fs_lfp));
time=round(0.025*Fs_lfp);
for i=1:l1
    lfp_trace_pre(i,:)=data2(:,(sleep_ind_pre(i)-time:sleep_ind_pre(i)+time));
end
for j=1:l2-5
    lfp_trace_post(j,:)=data2(:,(sleep_ind_post(j)-time:sleep_ind_post(j)+time));
end

mean_lfp_pre=mean(lfp_trace_pre);
std_lfp_pre=std(lfp_trace_pre)/sqrt((size(lfp_trace_pre,1))-1); 

mean_lfp_post=mean(lfp_trace_post);
std_lfp_post=std(lfp_trace_post)/sqrt((size(lfp_trace_post,1))-1); 




sws1=round(([sleep_ind_pre1(1):sleep_ind_pre1(end)])/Fs_lfp);
disp(length(sws1))
sws2=round(([sleep_ind_post1(1):sleep_ind_post1(end)])/Fs_lfp);
disp(length(sws2))

ts1_sws1s=find(TS1>sws1(1));
ts1_sws1e=find(TS1<sws1(end));
ts1_pre=intersect(ts1_sws1s,ts1_sws1e);
TS1_preSWS1=(TS1(ts1_pre));
TS1_preSWS=TS1_preSWS1-sws1(1)

ts1_sws2s=find(TS1>sws2(1));
ts1_sws2e=find(TS1<sws2(end));
ts1_post=intersect(ts1_sws2s,ts1_sws2e);
TS1_postSWS=TS1(ts1_post)-sws2(1);

ts2_sws1s=find(TS2>sws1(1));
ts2_sws1e=find(TS2<sws1(end));
ts2_pre=intersect(ts2_sws1s,ts2_sws1e);
TS2_preSWS1=(TS2(ts2_pre));
TS2_preSWS=TS2_preSWS1-sws1(1)


ts2_sws2s=find(TS2>sws2(1));
ts2_sws2e=find(TS2<sws2(end));
ts2=intersect(ts2_sws2s,ts2_sws2e);
TS2_postSWS=TS2(ts2)-sws2(1);

[tsOffsets_pre, ts1idx_pre, ts2idx_pre] = crosscorrelogram(TS1_preSWS, TS2_preSWS,[-0.1 0.1])
[tsOffsets_post, ts1idx_post, ts2idx_post] = crosscorrelogram(TS1_postSWS, TS2_postSWS,[-0.1 0.1])
subplot(3,2,[1]);
shadedErrorBar([],mean_lfp_pre,(3*std_lfp_pre),'b',0);
 XLim([0 length(mean_lfp_pre)]);
%  YLim([-0.00015 0.00015]); 
 set(gca,'FontSize',14,'FontWeight','BOLD');
 set(gca,'XTick',[0 25 50],'XTickLabel',{'-0.025','0','0.025'},'FontSize',14,'FontWeight','BOLD'); 
 set(gca,'YTick',[-20000 0 20000],'FontSize',14,'FontWeight','BOLD');
 set(gca,'YTickLabel',{'','',''},'FontSize',14,'FontWeight','BOLD'); 
 xlabel('time(sec)','FontSize',14,'FontWeight','BOLD'); %ylabel('microvolt','FontSize',14,'FontWeight','BOLD'); 
 t=['Ch' num2str(chan_no(1))];
 title(t,'FontSize',14,'FontWeight','BOLD')
subplot(3,2,[2]);
shadedErrorBar([],mean_lfp_post,(3*std_lfp_post),'r',0);
XLim([0 length(mean_lfp_pre)]);
 set(gca,'FontSize',14,'FontWeight','BOLD');
 set(gca,'XTick',[0 25 50],'XTickLabel',{'-0.025','0','0.025'},'FontSize',14,'FontWeight','BOLD'); 
 set(gca,'YTick',[-20000 0 20000],'FontSize',14,'FontWeight','BOLD');
 set(gca,'YTickLabel',{'','',''},'FontSize',14,'FontWeight','BOLD'); 
 xlabel('time(sec)','FontSize',14,'FontWeight','BOLD'); %ylabel('microvolt','FontSize',14,'FontWeight','BOLD'); 
 t=['Ch' num2str(chan_no(2))];
 title(t,'FontSize',14,'FontWeight','BOLD')

h1=subplot(3,2,[3 5]);
hist(tsOffsets_pre, 35)
h = findobj(gca,'Type','patch');
set(h,'FaceColor','c','EdgeColor','b')
a1=axis;
set(gca,'XTick',[-0.025  0  0.025]);%'XTickLabel',{'-0.025','0','0.025'}
set(gca,'FontSize',14,'FontWeight','BOLD');

h2=subplot(3,2,[4 6]);
hist(tsOffsets_post, 35)
h = findobj(gca,'Type','patch');
set(h,'FaceColor','y','EdgeColor','r')
a2=axis;
% axis([-0.050 0.050 0 32])
set(gca,'XTick',[-0.025  0  0.025]);%'XTickLabel',{'-0.025','0','0.025'}
set(gca,'FontSize',14,'FontWeight','BOLD');
y_maxh=max([a1(4); a2(4)]);
set(h1,'YLim',[0 y_maxh])
set(h2,'YLim',[0 y_maxh])



 set(gcf, 'Position', get(0,'Screensize'));
 
                filename=['C:\Users\Ganguly Lab\Documents\MATLAB\Tanuj\Mat_files\Result_figs\BMI\T10\5_24_13\SWS Xgram' num2str(chan_no) '.tiff'];
%                set(gcf, 'Position', get(0,'Screensize')); 
               saveas(gcf,filename);


% TS3=TimeStamps{chan_no(1),sc}*Fs_SPK;
% TS4=TimeStamps{chan_no(2),sc}*Fs_SPK;
% 
% temp3=histc(diff(TS3),(0:.005:1));
% temp4=histc(diff(TS4),(0:.005:1));
% figure;bar(histc((diff(TS3)),[0:.005:1]))
% XLim([0 50])
% percent_3=length(find(temp3<24))/length(temp3);
% percent_4=length(find(temp4<24))/length(temp4);

Output=[length(TS2_postSWS) length(TS1_preSWS)];