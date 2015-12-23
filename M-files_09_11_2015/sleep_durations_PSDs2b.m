function [Sleep_Pre_Duration, Sleep_Post_Duration, percent_change]= sleep_durations_PSDs2b(sleep_ind_pre, sleep_ind_post, data1,data2,chan_no, Fs_lfp)
close all
clear pre_tot post_tot
pre_tot=[];
post_tot=[];

for i=1: size(sleep_ind_pre,1)
    sleep_pre=[sleep_ind_pre(i,1):sleep_ind_pre(i,2)];
    pre_tot=[pre_tot sleep_pre];
end

for i=1: size(sleep_ind_post,1)
    sleep_post=[sleep_ind_post(i,1):sleep_ind_post(i,2)];
    post_tot=[post_tot sleep_post];
end


data1=(data1(chan_no,:))-mean(data1(chan_no,:));
data2=(data2(chan_no,:))-mean(data2(chan_no,:));
data_pre=data1(round(pre_tot));
data_post=data2(round(post_tot));

%%

params.tapers=[5 9];
params.Fs=Fs_lfp;
params.fpass=[0.5 20];
params.pad=0;
params.err=[2 0.05];
params.trialave=1;

% if (length(pre_tot)> length(post_tot))
%     data_ = length(post_tot)/Fs_lfp;
% else 
%     length_trial = length(pre_tot)/Fs_lfp;
% end
%movingwin = [10 10];
win = 10;
segave = 1;


[S1,f1,varS1,C1,Serr1]=mtspectrumsegc(data_pre,win,params,segave);
[S2,f2,varS2,C2,Serr2]=mtspectrumsegc(data_post,win,params,segave);
cshadedErrorBar(f1,S1,[Serr1],'g')
hold on;
cshadedErrorBar(f2,S2,[Serr2],'r')
XLim([0 20])
set(gca,'YScale','log')
set(gcf, 'Position', get(0,'Screensize')); 


ind_sws1=find(f1>=1,3,'first');
ind_sws2=find(f1<=4.0,3,'last');
ind_sws3=find(f1>=10,3,'first');
ind_sws4=find(f1<=15,3,'last');

pre_swa=mean(S1(ind_sws1(1):ind_sws2(end)));
post_swa=mean(S2(ind_sws1(1):ind_sws2(end)));
pre_sp=mean(S1(ind_sws3(1):ind_sws4(end)));
post_sp=mean(S2(ind_sws3(1):ind_sws4(end)));

swa_ch=((post_swa-pre_swa)/pre_swa)/100;
sp_ch=((post_sp-pre_sp)/pre_sp)/100;

percent_change=[swa_ch sp_ch]*10000;

% % filename=['C:\Users\Ganguly Lab\Documents\MATLAB\Tanuj\Mat_files\Result_figs\BMI\S23\2_3_13\Pre-F-Post-H PSD.tiff'];
filename= ['Sleep_PSD.tiff'];
%       
saveas(gcf,filename)

SWpre = pre_swa;
SWpost = post_swa;
SWAch = sqrt(SWpost)-sqrt(SWpre);
SWPch = SWpost - SWpre;
SWperch = ((SWpost - SWpre)/SWpre)*100;
SPpre= pre_sp;
SPpost= post_sp;
SPPch=SPpost-SPpre;
SPperch=((SPpost - SPpre)/SPpre)*100;

Sleep_Pre_Duration=round(length(data_pre)/Fs_lfp);
Sleep_Post_Duration=round(length(data_post)/Fs_lfp);

save PSD.mat S* Sleep* C* f1



