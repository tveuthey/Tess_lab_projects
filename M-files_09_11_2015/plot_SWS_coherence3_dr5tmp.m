function [Change_sws_med Change_spindle_med]=plot_SWS_coherence3_dr5(TimeStamps1,TimeStamps2,data1,data2, time_pre1,time_post1,units, chan_no, sc, bin_size, space, Fs_lfp, taper, win,dir)
figure
close all
      params.Fs=Fs_lfp;
        params.fpass=[0 20];
        params.tapers=[taper(1) taper(2)];
        params.trialave=1;
        params.pad=1;
        params.err=[2 0.05];
        
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
% bin_vector_post=round(data(1)/Fs_lfp):bin_size:(round(time_pre(end)/Fs_lfp)-round(time_pre(1)/Fs_lfp));

% lfp=median(data);
% lfp=base_norm(lfp);
% lfp_pre_med=median(data1);
% lfp_pre_med=base_norm(lfp_pre_med);
% lfp_post_med=median(data2);
% lfp_post_med=base_norm(lfp_post_med);
% lfp_pre_med=lfp_pre_med';
% lfp_post_med=lfp_post_med';
%X_loc = [1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3];
%Y_loc = [8,4,7,3,6,2,5,1,4,8,3,7,2,6,1,5,8,4,7,3,6,2,5,1,4,8,3,7,2,6,1,5];

% srate = Fs_lfp;
% nyq_sample=srate/2;
%         FILTER_ORDER=3;
%         f_lo=3;
%         f_hi=0.3;
%         [b2,a2]=butter(FILTER_ORDER,[f_hi f_lo]/nyq_sample);
%         sws_pre=(filtfilt(b2,a2,lfp_pre_med));
%         sws_post=(filtfilt(b2,a2,lfp_post_med));
% 
%             FILTER_ORDER=5;
%             f_lo=18;
%             f_hi=8;
%             [b2,a2]=butter(FILTER_ORDER,[f_hi f_lo]/nyq_sample);
%             spindle_pre=(filtfilt(b2,a2,lfp_pre_med));
%             spindle_post=(filtfilt(b2,a2,lfp_post_med));
%       
        
for i=1:length(units)
    lfp_pre = data1;
    lfp_post = data2;
    unit=units(i);
    clear ts*
    %     Peaks_diff = zeros(4,8);
    
    ts1tmp=TimeStamps1{unit,sc}*Fs_lfp;
    ts2tmp=TimeStamps2{unit,sc}*Fs_lfp;
    
    ts1a=[];
    ts2a=[];
% for j = 1:length(time_pre1)    
%     ts1atmp = ts1tmp(find(ts1tmp>time_pre1(j,1) & ts1tmp<time_pre1(j,2)));
%     if(numel(ts1atmp)>0)
%         ts1atmp2=(ts1atmp-ts1atmp(1))+1;
%         if numel(ts1a)>0
%             ts1atmp2=ts1atmp2+ts1a(end);
%             ts1a = [ts1a ts1atmp2];
%         else ts1a = [ts1atmp2];
%   
%         end
%     end
% end
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

for n=1:length(ts1a)
        ind=round(ts1a(n));
        pre_ind=ind-round(len/2)+1;
        post_ind=ind+round(len/2);
         if length(lfp_pre)>post_ind  && pre_ind>0
            hold_lfp_pre(n,:)=lfp_pre(pre_ind:post_ind);
            %hold_pre_sws(n,:)=sws_pre(pre_ind:post_ind);
            %hold_pre_spindle(n,:)= spindle_pre(pre_ind:post_ind); 
        end
end

for n=1:length(ts2a)
        ind=round(ts2a(n));
        pre_ind=ind-round(len/2)+1;
        post_ind=ind+round(len/2);
        if length(lfp_post)>post_ind+len/2 && pre_ind>0
            hold_lfp_post(n,:)=lfp_post(pre_ind:post_ind);
            %hold_post_sws(n,:)=sws_post(pre_ind:post_ind);
            %hold_post_spindle(n,:)= spindle_post(pre_ind:post_ind); 
        end
end
%    ts2a = ts2tmp(find(ts2tmp>time_post(1) & ts2tmp<time_post(end)));
    
    ts1=ts1a/Fs_lfp;
    ts2=ts2a/Fs_lfp;
   
+
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%spk-field coherence analysis
% 
    if ((numel(ts1)>250) && numel(ts2>250))
        ts1_pre3 = ts1;
        ts1_post3 = ts2;
        
        %ts1_pre = ts1;
        %ts1_post = ts2;
        
        params.Fs=Fs_lfp;
        params.fpass=[0 20];
        params.tapers=[taper(1) taper(2)];
        params.trialave=1;
        params.pad=1;
        params.err=[2 0.05];
        
        ts1_bin_rate_pre=mean(histc(ts1_pre3,bin_vector));
        ts1_bin_rate_post=mean(histc(ts1_post3,bin_vector));
%         ts1_change=((ts1_bin_rate_post-ts1_bin_rate_pre)/ts1_bin_rate_pre)*100;        
%        ts1_change=numel(ts1_post3)-numel(ts1_pre3);
        if numel(ts1_post3)>numel(ts1_pre3) 
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
        [C_pre,phi_pre,S12_pre,S1_pre,S2_pre,f_pre,zerosp_pre,confC_pre,phistd_pre,Cerr_pre]=coherencysegcpb(lfp_pre',dN_pre,win,params,1);
        temp=isnan(C_pre);
        [a b]=find(temp==1);
        c=unique(b);
        d=setdiff(1:size(C_pre,2),c);
        C_pre5=C_pre(:,d);
        C_pre6=mean(C_pre5,2);
        %      figure(i)
        %     subplot(1,2,1)
        %     plot(f_pre,C_pre); hold on
        [x1 ind1]=find(f_pre<1);
        [x2 ind2]=find(f_pre<4);
        [x3 ind3]=find(f_pre<10);
        [x4 ind4]=find(f_pre<15);
        
        c1= mean(C_pre((ind1(end)+1):(ind2(end)-1)))
        sws_premax_med(i) = max(C_pre((ind1(end)+1):(ind2(end)-1)))
        sws_premean_med(i) =c1;
        
        c2= mean(C_pre((ind3(end)+1):(ind4(end)-1)))
        
        spindle_premax_med(i)= max(C_pre((ind3(end)+1):(ind4(end)-1)))
        spindle_premean_med(i)=c2;
        phi_pre_sws_med(i)=mean(phi_pre((ind1(end)+1):(ind2(end)-1)));
        phi_pre_spindle_med(i)=mean(phi_pre((ind3(end)+1):(ind4(end)-1)));
        
        %     line([0 60],[c1 c1],'Color','b');
        
        %     [sleep_pre_min min_ind_pre]=min(sleep_dur_pre);
        disp(length(lfp_post'))
        [dN_post,t_post]=binspikes(ts1_post,1017.3,[0 round(length(lfp_post)/Fs_lfp)]);
        if length(lfp_post)<length(dN_post)
            dN_post=dN_post(1:length(lfp_post));
        else
            lfp_post=lfp_post(1:length(dN_post));
        end
        [C_post,phi_post,S12_post,S1_post,S2_post,f_post,zerosp_post,confC_post,phistd_post,Cerr_post]=coherencysegcpb(lfp_post',dN_post,win,params,1);
        temp=isnan(C_post);
        [a b]=find(temp==1);
        
        c=unique(b);
        d=setdiff(1:size(C_post,2),c);
        C_post5=C_post(:,d);
        C_post6=mean(C_post5,2);
        %     plot(f_post,C_post,'r');
        
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
        
        %     phi_pre_all_med(i)=phi_pre;
        %     figure(i)
        %     plot(f_pre,C_pre,'b'); hold on
        %     plot(f_post,C_post,'r');
        pltlng = length(find(f_pre<21));
        h = figure;cshadedErrorBar(f_pre(:),smooth(C_pre(:),20),cat(2,smooth(Cerr_pre(1,:),20),smooth(Cerr_pre(2,:),20))','b',1);
        hold on;
        cshadedErrorBar(f_post(:),smooth(C_post(:),20),cat(2,smooth(Cerr_post(1,:),20),smooth(Cerr_post(2,:),20)),'r',1);
        % shadedErrorBar(f_post_SP,smooth(C_post_SP,20),cat(2,smooth(Cerr_post_SP(1,:),20),smooth(Cerr_post_SP(2,:),20)),'g',1);
        axis auto;
        box off
     
        
       %     figure(i);shadedErrorBar(f_pre,smooth(C_pre,20),cat(2,smooth(Cerr_pre(1,:),20),smooth(Cerr_pre(2,:),20)),'b',1);
        %     h=figure(i);
        %     hold on;
        %     shadedErrorBar(f_post,smooth(C_post,20),cat(2,smooth(Cerr_post(1,:),20),smooth(Cerr_post(2,:),20)),'r',1);
        %     box off
        
        %      errorbar(f_pre,smooth(C_pre,20),Cerr_pre,'b');hold on
        
        
        
        %     errorbar(f_post,smooth(C_post,20),Cerr_pre,'r');
        %Session='T25\Control1\';
        %    filename=['C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\' Session 'SFC post_FP-SC' num2str(sc) '_Ch' num2str(unit) '.tiff'];
        filename = strcat('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\',dir,'SFC post_FP-SCnew_', num2str(sc), '_Ch', num2str(unit),'.tiff');
        saveas(h,filename);
        savefile = strcat('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\',dir,'SFC post_FP-SCnew_', num2str(sc), '_Ch', num2str(unit));
        save (savefile, 'Change_sws_med', 'Change_spindle_med', 'sws_premax_med', 'sws_postmax_med', 'sws_premean_med', 'sws_postmean_med', 'spindle_premax_med', 'spindle_postmax_med', 'spindle_premean_med', 'spindle_postmean_med', 'phi_pre_sws_med', 'phi_pre_spindle_med', 'phi_post_sws_med', 'phi_post_spindle_med', 'C_pre_all','C_post_all', 'C_change');
        close all;


end
end