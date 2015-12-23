function [Output]=plot_LFP_multisite_coherence(data_pre,data_post, Fs_lfp, taper, win, Session)
% figure
close all

% [r i]=find(wave>1);
time_pre=length(data_pre)
time_post=length(data_post)

if time_pre<time_post
    data_post=data_post(:,1:time_pre);
else
    data_pre=data_pre(:,1:time_post);
end

data_pre=data_pre';
data_post=data_post';

params.Fs=Fs_lfp;
params.fpass=[0 60];
params.tapers=[taper(1) taper(2)];
params.trialave=1;
params.pad=1;
params.err=[2 0.05];


for i=[1 2 3]
    [C_pre(:,i),phi_pre(:,i),S12_pre(:,i),S1_pre(:,i),S2_pre(:,i),f_pre(i,:),confC_pre(i,:),phistd_pre(:,i),Cerr_pre(:,:,i)]=coherencysegc(data_pre(:,2),data_pre(:,i),win,params);
    [x1 ind1]=find(f_pre<.3);
    [x2 ind2]=find(f_pre<4);
    coh(i,1)= mean(C_pre((ind1(end)+1):(ind2(end)-1),i))
    [x1 ind1]=find(f_pre<6);
    [x2 ind2]=find(f_pre<10);
    coh(i,2)= mean(C_pre((ind1(end)+1):(ind2(end)-1),i))
    [x1 ind1]=find(f_pre<8);
    [x2 ind2]=find(f_pre<15);
    coh(i,3)= mean(C_pre((ind1(end)+1):(ind2(end)-1),i))
    [x1 ind1]=find(f_pre<18);
    [x2 ind2]=find(f_pre<25);
    coh(i,4)= mean(C_pre((ind1(end)+1):(ind2(end)-1),i))
    [x1 ind1]=find(f_pre<40);
    [x2 ind2]=find(f_pre<60);
    coh(i,5)= mean(C_pre((ind1(end)+1):(ind2(end)-1),i))
end

temp=isnan(C_pre);
[a b]=find(temp==1);

c=unique(b);
d=setdiff(1:size(C_pre,2),c);
C_pre5=C_pre(:,d);
C_pre6=mean(C_pre5,2);


%     figure(i)
for i=1:3
    figure(1)
    subplot(1,3,i)
    %     plot(f_pre(i,:),C_pre(:,i)); hold on
    shadedErrorBar(f_pre(i,:),smooth(C_pre(:,i),5),cat(2,smooth(Cerr_pre(1,:,i),5),smooth(Cerr_pre(2,:,i),5)),'b',1); hold on
    axis([0 60 0 1]); box off
end
hold on





for i=[1 2 3]
    [C_post(:,i),phi_post(:,i),S12_post(:,i),S1_post(:,i),S2_post(:,i),f_post(i,:),confC_post(i,:),phistd_post(:,i),Cerr_post(:,:,i)]=coherencysegc(data_post(:,2),data_post(:,i),win,params);
    [x1 ind1]=find(f_post<.3);
    [x2 ind2]=find(f_post<4);
    coh2(i,1)= mean(C_post((ind1(end)+1):(ind2(end)-1),i))
    [x1 ind1]=find(f_post<6);
    [x2 ind2]=find(f_post<10);
    coh2(i,2)= mean(C_post((ind1(end)+1):(ind2(end)-1),i))
    [x1 ind1]=find(f_post<8);
    [x2 ind2]=find(f_post<15);
    coh2(i,3)= mean(C_post((ind1(end)+1):(ind2(end)-1),i))
    [x1 ind1]=find(f_post<18);
    [x2 ind2]=find(f_post<25);
    coh2(i,4)= mean(C_post((ind1(end)+1):(ind2(end)-1),i))
    [x1 ind1]=find(f_post<40);
    [x2 ind2]=find(f_post<60);
    coh2(i,5)= mean(C_post((ind1(end)+1):(ind2(end)-1),i))
end
temp=isnan(C_post);
[a b]=find(temp==1);

c=unique(b);
d=setdiff(1:size(C_post,2),c);
C_post5=C_post(:,d);
C_post6=mean(C_post5,2);
figure(1); hold on
for i=1:3
    %     figure(1);
    subplot(1,3,i)
    %     plot(f_post,C_post(:,i),'r');
    shadedErrorBar(f_post(i,:),smooth(C_post(:,i),5),cat(2,smooth(Cerr_post(1,:,i),5),smooth(Cerr_post(2,:,i),5)),'r',1); hold on
    axis([0 60 0 1]); box off
    line([4 4],[0 1],'LineStyle','--', 'Color',[ 0.5 0.5 0.5]);hold on;
    line([10 10],[0 1],'LineStyle','--', 'Color',[ 0.5 0.5 0.5]);hold on;
    line([18 18],[0 1],'LineStyle','--', 'Color',[ 0.5 0.5 0.5]);hold on;
    line([30 30],[0 1],'LineStyle','--', 'Color',[ 0.5 0.5 0.5]);hold on;
end

t=['Cross-site Coherence' Session ]
title(t);
hold off;
for i=1:3
    for j=1:5
        Change(i,j)=((coh2(i,j)-coh(i,j))/coh(i,j))*100;
    end
end
screen_size = get(0, 'ScreenSize');
f1 = figure(1);
set(f1, 'Position', [0 0 screen_size(3) screen_size(4) ] );

filename=['D:\MultiSiteLFP_LG\T100\' Session '.tiff'];

saveas(f1,filename);

Output=cat(2,coh,coh2,Change);