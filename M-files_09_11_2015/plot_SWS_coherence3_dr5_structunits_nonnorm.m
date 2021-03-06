function [Change_sws_med Change_spindle_med]=plot_SWS_coherence3_dr5_structunits_nonnorm(TimeStamps1,TimeStamps2,data1,data2, time_pre1,time_post1,units, chan_no, sc, bin_size, space, Fs_lfp, taper, win,dir)
figure
close all
      params.Fs=Fs_lfp;
        params.fpass=[0 20];
        params.tapers=[taper(1) taper(2)];
        params.trialave=1;
        params.pad=1;
        params.err=[2 0.05];
        
data1r=[];
data2r=[];
sc=1;
for j = 1:length(time_pre1)
    data1r = [data1r data1(chan_no,round(time_pre1(j,1)):round(time_pre1(j,2)))];
end
        
for j = 1:length(time_post1)
    data2r = [data2r data2(chan_no,round(time_post1(j,1)):round(time_post1(j,2)))];
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

data1 = data1(time_pre(1):time_pre(end));
data2 = data2(time_post(1):time_post(end));

data1 = data1-mean(data1);
data2=data2-mean(data2);
bin_vector=[round(time_pre(1)/Fs_lfp):bin_size:round(time_pre(end)/Fs_lfp)]-round(time_pre(1)/Fs_lfp);

lfp_pre = data1;
lfp_post = data2;
        
for i=1:length(TimeStamps1)
    unit=i;
    clear ts*
    
    ts1tmp=TimeStamps1{unit,sc}*Fs_lfp;
    ts2tmp=TimeStamps2{unit,sc}*Fs_lfp;
    
    ts1a=[];
    ts2a=[];

    tmplen=0;
    ts1atmp2=[];
    ts1atmp=[];
    for j = 1:length(time_pre1)
        ts1atmp = ts1tmp(ts1tmp>time_pre1(j,1) & ts1tmp<time_pre1(j,2));
        if(numel(ts1atmp)>0)
            ts1atmp2=(ts1atmp-time_pre1(j,1));
            ts1atmp2=ts1atmp2+tmplen;
            ts1a = [ts1a ts1atmp2];
        end
        tmplen = tmplen + (time_pre1(j,2)-time_pre1(j,1));
    end

tmplen=0;
for j = 1:length(time_post1)
    ts2atmp = ts2tmp(find(ts2tmp>time_post1(j,1) & ts2tmp<time_post1(j,2)));
    if(numel(ts2atmp)>0)
        ts2atmp2=(ts2atmp-time_post1(j,1));
        ts2atmp2=ts2atmp2+tmplen;
        ts2a = [ts2a ts2atmp2];
    end
        tmplen = tmplen + (time_post1(j,2)-time_post1(j,1));    
end

len = (2.5)*Fs_lfp;
    
    ts1=ts1a/Fs_lfp;
    ts2=ts2a/Fs_lfp;
            
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%spk-field coherence analysis
 
    if (numel(ts1)>25 & numel(ts2)>25)
        ts1_pre3 = ts1;
        ts1_post3 = ts2;
                
        params.Fs=Fs_lfp;
        params.fpass=[0 20];
        params.tapers=[taper(1) taper(2)];
        params.trialave=1;
        params.pad=1;
        params.err=[2 0.05];
        
ts1_bin_rate_pre=mean(histc(ts1_pre3,bin_vector));
ts1_bin_rate_post=mean(histc(ts1_post3,bin_vector));

             ts1_pre=ts1_pre3;
             ts1_post=ts1_post3;

          h = figure;cshadedErrorBar(f_pre(:),smooth(C_pre(:),20),cat(2,smooth(Cerr_pre(1,:),20),smooth(Cerr_pre(2,:),20))','b',1);
        hold on;
        cshadedErrorBar(f_post(:),smooth(C_post(:),20),cat(2,smooth(Cerr_post(1,:),20),smooth(Cerr_post(2,:),20)),'r',1);
        axis auto;
        box off
        filename = strcat(dir,'SFC post_FP-SCpt_notnorm', num2str(sc), '_Ch', num2str(unit),'.tiff');
        saveas(h,filename);

    end
end
        savefile = strcat(dir,'SFC post_FP-SCpt_notnorm', num2str(sc),'.mat');
        save (savefile, 'Change_sws_med', 'Change_spindle_med', 'sws_premax_med', 'sws_postmax_med', 'sws_premean_med', 'sws_postmean_med', 'spindle_premax_med', 'spindle_postmax_med', 'spindle_premean_med', 'spindle_postmean_med', 'phi_pre_sws_med', 'phi_pre_spindle_med', 'phi_post_sws_med', 'phi_post_spindle_med', 'C_pre_all','C_post_all', 'C_change','ts1_bin_rate_pre','ts1_bin_rate_post');
        close all;

