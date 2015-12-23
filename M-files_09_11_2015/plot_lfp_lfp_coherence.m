function plot_lfp_lfp_coherence(data1,data2, time_pre1,time_post1,bin_size, Fs_lfp, taper, dir)
figure
close all
        params.Fs=Fs_lfp;
        params.fpass=[0 20];
        params.tapers=[taper(1) taper(2)];
        params.trialave=1;
        params.pad=1;
        params.err=[2 0.05];
        win = 5;
%bin_size .05 space 1, taper 3 5 window 5

% [r i]=find(wave>1);
% time_pre=1:round(i(1)-1);
% time_dur=round(i(1)):round(i(end));
% time_post=round(i(end)+1):length(wave);
%
% time_pre=time_pre(1:round(300*Fs_lfp));



data1r=[];
data2r=[];
% for j = 1:length(time_pre1)
%     a(j)=time_pre1(j,2)-time_pre1(j,1);
% end
% 
% [~,ind_pre] = max(a);
% for j = 1:length(time_post1)
%     b(j)=time_post1(j,2)-time_post1(j,1);
% end
% [~,ind_post] = max(b);

% time_pre =[time_pre1(ind_pre,1):1:time_pre1(ind_pre,2)];
% time_post = [time_post1(ind_post,1):1:time_post1(ind_post,2)];

for j = 1:length(time_pre1)
    data1r = [data1r data1(:,time_pre1(j,1):time_pre1(j,2))];
end
        
for j = 1:length(time_post1)
    data2r = [data2r data2(:,time_post1(j,1):time_post1(j,2))];
end
clear data1 data2
data1=data1r;
data2=data2r;

l1=length(data1);
l3=length(data2);

if l1 < l3
    time_pre= 1:length(data1);
    time_post=1:length(data1);
else
    time_pre= 1:length(data2);
    time_post= 1:length(data2);
end

data1 = data1(:,time_pre(1):time_pre(end));
data2 = data2(:,time_post(1):time_post(end));


%bin_vector=[round(time_pre(1)/Fs_lfp):bin_size:round(time_pre(end)/Fs_lfp)]-round(time_pre(1)/Fs_lfp);
% bin_vector_post=round(data(1)/Fs_lfp):bin_size:(round(time_pre(end)/Fs_lfp)-round(time_pre(1)/Fs_lfp));

% lfp=median(data);
% lfp=base_norm(lfp);
% lfp_pre_med=median(data1);
% lfp_pre_med=base_norm(lfp_pre_med);
% lfp_post_med=median(data2);
% lfp_post_med=base_norm(lfp_post_med);
%data1=base_norm(data1);
%data2=base_norm(data2);

%data1=data1';
%data2=data2';
[x,~]=size (data1);
if (x==32)
X_loc = [1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3];
Y_loc = [8,4,7,3,6,2,5,1,4,8,3,7,2,6,1,5,8,4,7,3,6,2,5,1,4,8,3,7,2,6,1,5];
elseif x==64
   X_loc = [1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8];
   Y_loc = [1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8,];
end    

for i = 1:x
    for j = 1:x
        e1=base_norm(data1(i,:))';
        e2=base_norm(data1(j,:))';
        e3=base_norm(data2(i,:))';
        e4=base_norm(data2(j,:))';
        [C_pre,phi_pre,S12_pre,S1_pre,S2_pre,f_pre,confC_pre,phistd_pre,Cerr_pre]=coherencyc(e1,e2,params);
        [C_post,phi_post,S12_post,S1_post,S2_post,f_post,confC_post,phistd_post,Cerr_post]=coherencyc(e3,e4,params);
        
        sw=find(f_pre>0.3 & f_pre<4); 
        th=find(f_pre>4 & f_pre<8);
        sp=find(f_pre>10 & f_pre<15);
        
        Cswspre = mean(C_pre(sw,:));
        Cswspost = mean(C_post(sw,:));
        Csppre = mean(C_pre(sp,:));
        Csppost = mean(C_post(sp,:));
        SWScoh_diff = (Cswspost-Cswspre)./Cswspre;
        Spincoh_diff=(Csppost-Csppre)./Csppre;
        SWtmppre(X_loc(j),Y_loc(j)) = Cswspre;
        SWtmppost(X_loc(j),Y_loc(j)) = Cswspost;
        SWtmpdiff(X_loc(j),Y_loc(j)) = SWScoh_diff;
        SPtmppre(X_loc(j),Y_loc(j)) = Csppre;
        SPtmppost(X_loc(j),Y_loc(j)) = Csppost;
        SPtmpdiff(X_loc(j),Y_loc(j)) = Spincoh_diff;
        SW(i,j)=SWScoh_diff;
        Spindle(i,j)=Spincoh_diff;
        SWpre(i,j)=Cswspre;
        Spindlepre(i,j)=Csppre;
        SWpost(i,j)=Cswspost;
        Spindlepost(i,j)=Csppost;
        
    end
     t = strcat('Channel ',num2str(i));
h = figure(1);
imagesc(SWtmpdiff, [-0.5 0.5]); shading interp; colorbar; title (t);
filename = strcat(dir,'SWS_coherence_change_channel', num2str(i), '.tiff');
saveas(h,filename);
close all;

h = figure(1);
imagesc(SPtmpdiff, [-0.5 0.5]); shading interp; colorbar; title (t)
filename = strcat(dir,'Spindle_coherence__channel', num2str(i), '.tiff');
saveas(h,filename);

end
h = figure(1);
imagesc(SWpre, [-0.5 0.5]); shading interp; colorbar;
filename = strcat(dir,'SWS_coherence_pre.tiff');
saveas(h,filename);
close all;

h = figure(1);
imagesc(Spindlepre, [-0.5 0.5]); shading interp; colorbar; title (t);
filename = strcat(dir,'Spindle_coherence_pre.tiff');
saveas(h,filename);
close all;
h = figure(1);
imagesc(SWpost, [-0.5 0.5]); shading interp; colorbar;
filename = strcat(dir,'SWS_coherence_post.tiff');
saveas(h,filename);
close all;

h = figure(1);
imagesc(Spindlepost, [-0.5 0.5]); shading interp; colorbar; title (t);
filename = strcat(dir,'Spindle_coherence_post.tiff');
saveas(h,filename);
close all;

h = figure(1);
imagesc(SW, [-0.5 0.5]); shading interp; colorbar;
filename = strcat(dir,'SWS_coherence_change_channel_all.tiff');
saveas(h,filename);
close all;

h = figure(1);
imagesc(Spindle, [-0.5 0.5]); shading interp; colorbar; title (t);
filename = strcat(dir,'Spindle_coherence_change_channel_all.tiff');
saveas(h,filename);
close all;

% SWS_mean = mean(SW,3); t = 'SWS_mean_allch'
% h = figure(1);
% imagesc(SWS_mean, [-0.5 0.5]); shading interp; colorbar; title (t);
% filename = strcat(dir,'SWS_coherence_change_channel_all.tiff');
% saveas(h,filename);
% close all;
% 
% spindle_mean=mean(Spindle,3); t = 'Spindle_mean_allch';
% h = figure(1);
% imagesc(spindle_mean, [-0.5 0.5]); shading interp; colorbar; title (t);
% filename = strcat(dir,'Spindle_coherence_change_all.tiff');
% saveas(h,filename);
% close all;

[sswhubpos sswhubneg ssphubpos ssphubneg] = lfp_graph(SW,Spindle);

filemat = strcat(dir,'lfp_lfp_coh.mat');

save ('filemat', 'SW', 'Spindle', 'SWpre','SWpost','Spindlepre','Spindlepost','sswhubpos','sswhubneg','ssphubpos','ssphubneg'); 
