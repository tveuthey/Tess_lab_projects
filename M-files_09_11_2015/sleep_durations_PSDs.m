function [Sleep_Pre_Duration, Sleep_Post_Duration]= sleep_durations_PSDs(sleep_ind_pre, sleep_ind_post, data,chan_no, Fs_lfp)
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


% data=(data(chan_no,:))-mean(data(chan_no,:));
data=median(data)-mean(median(data));
data_pre=data(pre_tot);
data_post=data(post_tot);


params.tapers=[20 39];
params.Fs=Fs_lfp;
params.fpass=[0 20];
params.pad=1;
params.err=[2 0.05];
params.trialave=1;


dur=round(Fs_lfp);
for i=1
    pre_tot1(:,i)=data_pre((i*1001):((i*1001)+9999));
    post_tot1(:,i)=data_post((i*1001):((i*1001)+9999));
end




[S,f,Serr] = mtspectrumc( pre_tot1, params );
% plot(f,S,'g', 'LineWidth',3); %figure; 
% hold on; 
shadedErrorBar(f,S,Serr,'g')
[S,f,Serr] = mtspectrumc( post_tot1, params );
hold on;
% plot(f,S,'r','LineWidth',3);
% hold on; 
shadedErrorBar(f,S,Serr,'r')
% legend('Pre','Post')
XLim([0 20])
set(gca,'YScale','log')
set(gcf, 'Position', get(0,'Screensize')); 

filename=['C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T12_allblocks\Session2\Pre-F-Post-H PSD.tiff'];
% saveas(gcf,filename)


Sleep_Pre_Duration=round(length(pre_tot)/Fs_lfp);
Sleep_Post_Duration=round(length(post_tot)/Fs_lfp);



