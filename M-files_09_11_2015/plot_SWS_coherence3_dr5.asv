function [Change_sws_med Change_spindle_med]=plot_SWS_coherence3_dr5(TimeStamps1,TimeStamps2,data1,data2, time_pre1,time_post1,units, chan_no, sc, bin_size, space, Fs_lfp, taper, win,dir)
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

for i=1:length(units)
    lfp_pre = data1;
    lfp_post = data2;
    unit=units(i);
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
        
        %ts1_bin_rate_pre=mean(histc(ts1_pre3,bin_vector));
        %ts1_bin_rate_post=mean(histc(ts1_post3,bin_vector));
        
        if numel(ts1_post3)>numel(ts1_pre3)
            temp_ind=randperm(length(ts1_post3));
            ts1_post=sort(ts1_post3(temp_ind(1:length(ts1_pre3))));
            ts1_pre=ts1_pre3;
        else
            temp_ind=randperm(length(ts1_pre3));
            ts1_pre=sort(ts1_pre3(temp_ind(1:length(ts1_post3))));
            ts1_post=ts1_post3;
        end
        
        spkdata_pre.times = ts1_pre';
        [C_pre,phi_pre,S12_pre,S1_pre,S2_pre,f_pre,zerosp_pre,confC_pre,phistd_pre,Cerr_pre]=coherencysegcpt(lfp_pre',spkdata_pre,win,params,1,1);
        
        temp=isnan(C_pre);
        [a b]=find(temp==1);
        c=unique(b);
        d=setdiff(1:size(C_pre,2),c);
        C_pre5=C_pre(:,d);
        C_pre6=mean(C_pre5,2);
        
        [x1 ind1]=find(f_pre<1);
        [x2 ind2]=find(f_pre<4);
        [x3 ind3]=find(f_pre<10);
        [x4 ind4]=find(f_pre<15);
        
        c1= mean(C_pre((ind1(end)+1):(ind2(end)-1)))';
        sws_premax_med(i) = max(C_pre((ind1(end)+1):(ind2(end)-1)));
        sws_premean_med(i) =c1;
        
        c2= mean(C_pre((ind3(end)+1):(ind4(end)-1)));
        
        spindle_premax_med(i)= max(C_pre((ind3(end)+1):(ind4(end)-1)));
        spindle_premean_med(i)=c2;
        phi_pre_sws_med(i)=mean(phi_pre((ind1(end)+1):(ind2(end)-1)));
        phi_pre_spindle_med(i)=mean(phi_pre((ind3(end)+1):(ind4(end)-1)));
        
        disp(length(lfp_post'))
        [dN_post,t_post]=binspikes(ts1_post,1017.3,[0 round(length(lfp_post)/Fs_lfp)]);
        if length(lfp_post)<length(dN_post)
            dN_post=dN_post(1:length(lfp_post));
        else
            lfp_post=lfp_post(1:length(dN_post));
        end
        spkdata_post.times = ts1_post';
        [C_post,phi_post,S12_post,S1_post,S2_post,f_post,zerosp_post,confC_post,phistd_post,Cerr_post]=coherencysegcpt(lfp_post',spkdata_post,win,params,1,1)
        temp=isnan(C_post);
        [a b]=find(temp==1);
        
        c=unique(b);
        d=setdiff(1:size(C_post,2),c);
        C_post5=C_post(:,d);
        C_post6=mean(C_post5,2);
        
        [x1 ind1]=find(f_post<1);
        [x2 ind2]=find(f_post<4);
        [x3 ind3]=find(f_post<10);
        [x4 ind4]=find(f_post<15);
        
        c3=mean(C_post((ind1(end)+1):(ind2(end)-1)));
        sws_postmax_med(i)= max(C_post((ind1(end)+1):(ind2(end)-1)));
        sws_postmean_med(i)=c3;
        
        c4=mean(C_post((ind3(end)+1):(ind4(end)-1)));
        spindle_postmax_med(i)= max(C_post((ind3(end)+1):(ind4(end)-1)));
        spindle_postmean_med(i)=c4;
        phi_post_sws_med(i)=mean(phi_post((ind1(end)+1):(ind2(end)-1)));
        phi_post_spindle_med(i)=mean(phi_post((ind3(end)+1):(ind4(end)-1)));
        
        
        Change_sws_med(i)=((c3-c1)/c1)*100;
        Change_spindle_med(i)=((c4-c2)/c2)*100;
        phi_change_sws_med(i)     = phi_post_sws_med(i)-phi_pre_sws_med(i);
        phi_change_spindle_med(i) = phi_post_spindle_med(i)-phi_pre_spindle_med(i);
        C_pre_all(i,:)=C_pre;
        C_post_all(i,:)=C_post;
        C_change(i,:)=C_post-C_pre;
        
        disp(((c3-c1)/c1)*100)
        
        h = figure;cshadedErrorBar(f_pre(:),smooth(C_pre(:),20),cat(2,smooth(Cerr_pre(1,:),20),smooth(Cerr_pre(2,:),20))','b',1);
        hold on;
        cshadedErrorBar(f_post(:),smooth(C_post(:),20),cat(2,smooth(Cerr_post(1,:),20),smooth(Cerr_post(2,:),20)),'r',1);
        axis auto;
        box off
        filename = strcat(dir,'SFC post_FP-SCpt', num2str(sc), '_Ch', num2str(unit),'.tiff');
        saveas(h,filename);
        
    end
end
savefile = strcat(dir,'SFC post_FP-SCpt', num2str(sc),'.mat');
save (savefile, 'Change_sws_med', 'Change_spindle_med', 'sws_premax_med', 'sws_postmax_med', 'sws_premean_med', 'sws_postmean_med', 'spindle_premax_med', 'spindle_postmax_med', 'spindle_premean_med', 'spindle_postmean_med', 'phi_pre_sws_med', 'phi_pre_spindle_med', 'phi_post_sws_med', 'phi_post_spindle_med', 'C_pre_all','C_post_all', 'C_change');
close all;

