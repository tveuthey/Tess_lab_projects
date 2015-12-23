function [Change_sws Change_spindle sws_premax sws_postmax sws_premean sws_postmean spindle_premax spindle_postmax spindle_premean spindle_postmean phi_post_all phi_pre_all phi_change]=plot_SWS_coherence3_dr(TimeStamps1,TimeStamps2,data1,data2, time_pre1,time_post1,units, chan_no, sc, bin_size, space, Fs_lfp, taper, win,dir)
figure
close all

%bin_size .05 space 1, taper 3 5 window 5

% [r i]=find(wave>1);
% time_pre=1:round(i(1)-1);
% time_dur=round(i(1)):round(i(end));
% time_post=round(i(end)+1):length(wave);
% 
% time_pre=time_pre(1:round(300*Fs_lfp));
 
 

data1r=[];
data2r=[];
    for j = 1:length(time_pre1)
        a(j)=time_pre1(j,2)-time_pre1(j,1);
    end
    
    [~,ind_pre] = max(a);
    for j = 1:length(time_post1)
        b(j)=time_post1(j,2)-time_post1(j,1);
    end
    [~,ind_post] = max(b);

time_pre =[time_pre1(ind_pre,1):1:time_pre1(ind_pre,2)];
time_post = [time_post1(ind_post,1):1:time_post1(ind_post,2)];

l1=length(time_pre);
l3=length(time_post);

 if l1 < l3
     time_post=time_post(1:length(time_pre));
 else
     time_pre=time_pre(1:length(time_post));
 end
 
data1 = [data1(:,time_pre(1):time_pre(end))];
data2 = [data2(:,time_post(1):time_post(end))];


bin_vector=[round(time_pre(1)/Fs_lfp):bin_size:round(time_pre(end)/Fs_lfp)]-round(time_pre(1)/Fs_lfp);
% bin_vector_post=round(data(1)/Fs_lfp):bin_size:(round(time_pre(end)/Fs_lfp)-round(time_pre(1)/Fs_lfp));

% lfp=median(data);
% lfp=base_norm(lfp);
lfp_pre_med=median(data1);
lfp_pre_med=base_norm(lfp_pre_med);
lfp_post_med=median(data2);
lfp_post_med=base_norm(lfp_post_med);
lfp_pre_med=lfp_pre_med';
lfp_post_med=lfp_post_med';
X_loc = [1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3];
Y_loc = [8,4,7,3,6,2,5,1,4,8,3,7,2,6,1,5,8,4,7,3,6,2,5,1,4,8,3,7,2,6,1,5];

    for i=1:length(units)
        lfp_pre = lfp_pre_med;
        lfp_post = lfp_post_med;
        close
        unit=units(i);    
        clear ts*
        ts_pre=[];
        ts_post=[];
        Peaks_diff = zeros(4,8);
    
        ts1tmp=TimeStamps1{unit,sc};
        ts2tmp=TimeStamps2{unit,sc};

        ts1tmp=ts1tmp*Fs_lfp;
        ts2tmp=ts2tmp*Fs_lfp;
    ts1a=[];
    ts2a=[];
    ts1a = ts1tmp(find(ts1tmp>time_pre(1) & ts1tmp<time_pre(end)));
    ts2a = ts2tmp(find(ts2tmp>time_post(1) & ts2tmp<time_post(end)));    

    ts1=ts1a/Fs_lfp;
    ts2=ts2a/Fs_lfp;    
    ts1_pre3 = ts1-ts1(1);
    ts1_post3 = ts2-ts2(1);
    
    params.Fs=Fs_lfp;
    params.fpass=[0 60];
    params.tapers=[taper(1) taper(2)];
    params.trialave=1;
    params.pad=1;
    params.err=[2 0.05];

    ts1_bin_rate_pre=mean(histc(ts1_pre3,bin_vector));
    ts1_bin_rate_post=mean(histc(ts1_post3,bin_vector));        
    ts1_change=((ts1_bin_rate_post-ts1_bin_rate_pre)/ts1_bin_rate_pre)*100;

    if ts1_change>0
        temp_ind=randperm(length(ts1_post3));
        ts1_post=sort(ts1_post3(temp_ind(1:length(ts1_pre3))));
        ts1_pre=ts1_pre3;
    else
        temp_ind=randperm(length(ts1_pre3));
        ts1_pre=sort(ts1_pre3(temp_ind(1:length(ts1_post3))));
        ts1_post=ts1_post3;
    end
%     lfp_pre=lfp_pre;
    disp(length(lfp_pre'))
    %     figure(1);
    %     subplot(2,1,1)
    %     plot(lfp_pre)
    [dN_pre,t_pre]=binspikes(ts1_pre,1017.3,[0 round(length(lfp_pre)/Fs_lfp)]);
    if length(lfp_pre)<length(dN_pre)
        dN_pre=dN_pre(1:length(lfp_pre));
    else
        lfp_pre=lfp_pre(1:length(dN_pre));
    end
    
    [C_pre,phi_pre,S12_pre,S1_pre,S2_pre,f_pre,zerosp_pre,confC_pre,phistd_pre,Cerr_pre]=coherencysegcpb(lfp_pre_med,dN_pre,win,params,1);
    temp=isnan(C_pre);
    [a b]=find(temp==1);
    c=unique(b);
    d=setdiff(1:size(C_pre,2),c);
    C_pre5=C_pre(:,d);
    C_pre6=mean(C_pre5,2);
    figure(i)
    %     subplot(1,2,1)
    plot(f_pre,C_pre); hold on    
    [x1 ind1]=find(f_pre<.3);
    [x2 ind2]=find(f_pre<3);
    [x3 ind3]=find(f_pre<8);
    [x4 ind4]=find(f_pre<18);    
    c1 = mean(C_pre((ind1(end)+1):(ind2(end)-1)))
    sws_premax = max(C_pre((ind1(end)+1):(ind2(end)-1)))
    sws_premean(X_loc(chan_no),Y_loc(chan_no) =c1;
    c2= mean(C_pre((ind3(end)+1):(ind4(end)-1)))
    spindle_premax(X_loc(chan_no),Y_loc(chan_no)= max(C_pre((ind3(end)+1):(ind4(end)-1)))
    spindle_premean(X_loc(chan_no),Y_loc(chan_no)=c2
    
    Peaks_diff(X_loc(chan_no),Y_loc(chan_no))=change1;
    
    line([0 60],[c1 c1],'Color','b');
    
    %     [sleep_pre_min min_ind_pre]=min(sleep_dur_pre);
     disp(length(lfp_post'))
    [dN_post,t_post]=binspikes(ts1_post,1017.3,[0 round(length(lfp_post)/Fs_lfp)]);
    if length(lfp_post)<length(dN_post)
        dN_post=dN_post(1:length(lfp_post));
    else
        lfp_post=lfp_post(1:length(dN_post));
    end
    [C_post,phi_post,S12_post,S1_post,S2_post,f_post,zerosp_post,confC_post,phistd_post,Cerr_post]=coherencysegcpb(lfp_post,dN_post,win,params,1);
    temp=isnan(C_post);
    [a b]=find(temp==1);
    
    c=unique(b);
    d=setdiff(1:size(C_post,2),c);
    C_post5=C_post(:,d);
    C_post6=mean(C_post5,2);
    plot(f_post,C_post,'r');
    
    [x1 ind1]=find(f_post<.3);
    [x2 ind2]=find(f_post<3);    
    [x3 ind3]=find(f_post<8);
    [x4 ind4]=find(f_post<18);    
    
    c3=mean(C_post((ind1(end)+1):(ind2(end)-1)));
    sws_postmax{i}= max(C_post((ind1(end)+1):(ind2(end)-1)));
    sws_postmean{i}=c3;

    c4=mean(C_post((ind3(end)+1):(ind4(end)-1)));
    spindle_postmax{i}= max(C_post((ind3(end)+1):(ind4(end)-1)));
    spindle_postmean{i}=c4;

%     line([0 60],[c3 c3],'Color','r');
    Change_sws{i}=((c3-c1)/c1)*100;
    Change_spindle{i}=((c4-c2)/c2)*100;

    disp(((c3-c1)/c1)*100)

    phi_pre_all{i}=phi_pre;
    phi_post_all{i}=phi_post;
    phi_change{i} = phi_post-phi_pre;
    
    h=figure(i)
    %     subplot(1,2,2)
    %     plot(f_pre,S1_pre,'k');hold on
    %     plot(f_post,S1_post,'r');
    %     figure(1);
    %     subplot(2,1,2)
    %     plot(lfp_post)
figure;shadedErrorBar(f_pre,smooth(C_pre,20),cat(2,smooth(Cerr_pre(1,:),20),smooth(Cerr_pre(2,:),20)),'b',1);
hold on;
shadedErrorBar(f_post,smooth(C_post,20),cat(2,smooth(Cerr_post(1,:),20),smooth(Cerr_post(2,:),20)),'r',1);
% shadedErrorBar(f_post_SP,smooth(C_post_SP,20),cat(2,smooth(Cerr_post_SP(1,:),20),smooth(Cerr_post_SP(2,:),20)),'g',1);
box off
    
%      errorbar(f_pre,smooth(C_pre,20),Cerr_pre,'b');hold on
%     errorbar(f_post,smooth(C_post,20),Cerr_pre,'r');
    %Session='T25\Control1\';
%    filename=['C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\' Session 'SFC post_FP-SC' num2str(sc) '_Ch' num2str(unit) '.tiff'];
     filename = strcat(dir,'SFC post_FP-SC', num2str(sc), '_Ch', num2str(unit),'.tiff')
    saveas(h,filename);
    end
    