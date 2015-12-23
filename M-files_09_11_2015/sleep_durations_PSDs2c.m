function [Sleep_Pre_Duration, Sleep_Post_Duration, percent_change]= sleep_durations_PSDs2c(sleep_ind_pre, sleep_ind_post, data1,data2,chan_no, Fs_lfp)
close all
%clear pre_tot post_tot
pre_tot=[];
post_tot=[];

%%%%%%%%%%%%%%Z_scoring matrix
pre_tot1 = data1;
post_tot1 = data2;

for i=1: size(sleep_ind_pre,1)
    sleep_pre=[sleep_ind_pre(i,1):sleep_ind_pre(i,2)];
    pre_tot=[pre_tot sleep_pre];
end

for i=1: size(sleep_ind_post,1)
    sleep_post=[sleep_ind_post(i,1):sleep_ind_post(i,2)];
    post_tot=[post_tot sleep_post];
end

pre_tot1 = pre_tot1(:,pre_tot);
post_tot1 = post_tot1(:,post_tot);

Spre_dur = length(pre_tot1);
Spost_dur = length(post_tot1);

if (length(pre_tot1)> length(post_tot1))
    pre_tot1=pre_tot1(:,1:length(post_tot1));
else 
    post_tot1=post_tot1(:,1:length(pre_tot1));
end
Sleep_duration_used = length(pre_tot1);
% data=(data(chan_no,:))-mean(data(chan_no,:));
% data1=median(data1)-mean(median(data1));
% data2=median(data2)-mean(median(data2));
% data_pre=data1(pre_tot);
% data_post=data2(post_tot);

%%

params.tapers=[5 9];
params.Fs=Fs_lfp;
params.fpass=[0 20];
params.pad=1;
params.err=[2 0.05];
%params.trialave=0;

dur=round(10*Fs_lfp);

icount = 0;
% for i=1%:10:(length(pre_tot1)/Fs_lfp) 
%     icount = icount+1;
%     pre_tot2=pre_tot1(:,(i*1):((i*1)+9999));
%     post_tot2=post_tot1(:,(i*1):((i*1)+9999));
% end
movingwin = [10 10];
win = 10
segave = 1;
clear pre_tot post_tot;

%[S1,f1,Serr1] = mtspectrumc(pre_tot2', params);

% [S,t,f,Serr] = mtspecgramc(pre_tot1', movingwin, params);
% imagesc(S(:,:,25)'); colorbar;
% tic


for ch = 1:32
    chan_no=ch;
pre_tottmp=(pre_tot1(ch,:))-mean(pre_tot1(ch,:));
post_tottmp=(post_tot1(ch,:))-mean(post_tot1(ch,:));

[tS1,tf1,tvarS1,tC1,tSerr1]=mtspectrumsegc(pre_tottmp,win,params,segave);
[tS2,tf2,tvarS2,tC2,tSerr2]=mtspectrumsegc(post_tottmp,win,params,segave);

    X_loc = [1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3];
    Y_loc = [8,4,7,3,6,2,5,1,4,8,3,7,2,6,1,5,8,4,7,3,6,2,5,1,4,8,3,7,2,6,1,5];

S1(ch,:)=tS1;
C1(ch,:,:)=tC1;
Serr1(ch,:,:)=tSerr1;

S2(ch,:)=tS2;
C2(ch,:,:)=tC2;
Serr2(ch,:,:)=tSerr2;

S_diff(ch,:)=tS2-tS1;
C_diff(ch,:,:)=tC2-tC1;
Serr2_diff(ch,:,:)=tSerr2-tSerr1;

Swf = find(tf1>0.3 & tf1<3);
SWpre = mean(tS1(Swf));
SWpost = mean(tS2(Swf));
SWAch = sqrt(SWpost)-sqrt(SWpre);
SWPch = SWpost - SWpre;
SWperch = ((SWpost - SWpre)/SWpre)*100;

PSD_pre(X_loc(chan_no),Y_loc(chan_no)) = SWpre;
PSD_post(X_loc(chan_no),Y_loc(chan_no)) = SWpost;
PSD_changeA(X_loc(chan_no),Y_loc(chan_no))=SWAch;    
PSD_changeP(X_loc(chan_no),Y_loc(chan_no))=SWPch;    
PSD_perch(X_loc(chan_no),Y_loc(chan_no))=SWperch
end

bar3(log(PSD_pre)); tit = 'SWS Spectrum Prelearning';title(tit);saveas(gcf,tit,'tiff');
bar3(log(PSD_post)); tit = 'SWS Power Postlearning';title(tit);saveas(gcf,tit,'tiff');
bar3(PSD_changeA); tit = 'SWS Amplitude Change';title(tit);  zlim([-50 150]);saveas(gcf,tit,'tiff');
bar3(PSD_changeP); tit = 'SWS Power Change';title(tit);  zlim([-50 150]); saveas(gcf,tit,'tiff');
bar3(PSD_perch); tit = 'SWS Percent Change';title(tit);  zlim([-50 150]); saveas(gcf,tit,'tiff');
imagesc(PSD_perch);tit = 'SWS Percent Change_cont'; title(tit);  zlim([-50 150]); saveas(gcf,tit,'tiff');

save PSD.mat PS* S*


