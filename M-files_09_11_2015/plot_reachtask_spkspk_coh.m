function [Change_sws_med Change_spindle_med]=plot_reachtask_spkfld_coh(TimeStamps1,data1,trial_mark,units, sc, bin_size,Fs_lfp, taper, dir)
figure
close all
        params.Fs=Fs_lfp;
        params.fpass=[0 100];
        params.tapers=[taper(1) taper(2)];
        params.trialave=0;
        params.pad=1;
        params.err=[2 0.05];
        
%bin_size .05 space 1, taper 3 5 window 5

% [r i]=find(wave>1);

% med_data=median(data1,1);
% med_data=base_norm(med_data);
trl_len=round(Fs_lfp/2);
trl_num = length(trial_mark);
trl=zeros(trl_num,trl_len);
trl_data=zeros(trl_len,trl_num);
for i = 1:length(trial_mark)
trl(i,:) = round(trial_mark(i):trial_mark(i)+trl_len*2);
trl_data(:,i) = med_data(trl(i,:));
end

for i=1:length(units)
    clear C phi S12 S1 S2 f zerosp confC phistd Cerr dn_pre ts* trl_datatmp e
    unit=units(i);
    trl_datatmp=trl_data;
    ts1tmp=TimeStamps1{unit,sc}*Fs_lfp;
    
    ts1a=[];
    e=[];
    dN_pre=zeros(trl_len,trl_num);
    for j = 1:trl_num
        tstmp = ts1tmp(ts1tmp>trl(j,1) & ts1tmp<trl(j,end));
        tstmp=(tstmp-trl(j,1))/Fs_lfp;
        if(~isempty(tstmp))
        [dN_pre(:,j),~]=binspikes(tstmp,1017.3,[0 0.5]);
       % [dN_pre,t_pre]=binspikes(ts1_pre,1017.3,[0
       % round(length(lfp_pre)/Fs_lfp)]);
      %  ts(j).trials=tstmp/Fs_lfp;
        else
            e=[e j];
        end
    end
    
    trl_rt = sum(dN_pre);
    trlcnt = round(length(trl_rt)/2);
    plot(trl_rt);
        pause;
    m(1)=mean(trl_rt(1:trlcnt));
    m(2)=mean(trl_rt(trlcnt:end));
    stdev(1)=std(trl_rt(1:trlcnt));
    stdev(2) =std(trl_rt(trlcnt:end));
    cv1 = m/stdev;
   [H(1),P(2)] = ttest2(trl_rt(1:trlcnt),trl_rt(trlcnt:end));
   bar(m);
   title(P);
   pause;
   if ~isempty(e)
    trl_datatmp(:,e)=[];
    dN_pre(:,e)=[];
   end
    [C,phi,S12,S1,S2,f,zerosp,confC,phistd,Cerr]=coherencycpb(trl_datatmp,dN_pre,params,0);
    th = find((f>4 & f<8));
    al = find((f>8 & f<12));
    be = find((f>13 & f<30));
    ga = find(f>30 & f<60);
    hga = find(f>70 & f<140);
    
   imagesc(C, [0 1]); colorbar;
    pause;
    [~,cohnum] = size(C);
    cohnum=round(cohnum/2);
    Cthetapre = mean(C(th,1:cohnum),1);
    Cthetapost = mean(C(th,cohnum:end),1);
    
    Calphapre = mean(C(al,1:cohnum),1);
    Calphapost = mean(C(al,cohnum:end),1);
    Cbetapre = mean(C(be,1:cohnum),1);
    Cbetapost = mean(C(be,cohnum:end),1);
    Cgammapre  = mean(C(ga,1:cohnum),1);
    Cgammapost = mean(C(ga,cohnum:end),1);
    Chgammapre  = mean(C(hga,1:cohnum),1);
    Chgammapost = mean(C(hga,cohnum:end),1);
    ThetaBetapre=Cthetapre./Cbetapre;
    ThetaBetapost=Cthetapost./Cbetapost;
    [h(1),p(1)] = ttest2(Cthetapre,Cthetapost)
    [h(2),p(2)] = ttest2(Calphapre,Calphapost)
    [h(3),p(3)] = ttest2(Cbetapre,Cbetapost)
    [h(4),p(4)] = ttest2(Cgammapre,Cgammapost)
    [h(5),p(5)] = ttest2(Chgammapre,Chgammapost)
    [h(6),p(6)] = ttest2(ThetaBetapre,ThetaBetapost)

    figure; hold on
    subplot(221); bar([Cthetapre Cthetapost]); title('Theta'); legend(num2str(p(1)), num2str(mean(Cthetapre,2)),num2str(mean(Cthetapost,2)));
    subplot(222); bar([Calphapre Calphapost]); title('Alpha'); legend(num2str(p(2)), num2str(mean(Calphapre,2)),num2str(mean(Calphapost,2)));
    subplot(223); bar([Cbetapre Cbetapost]); title('Beta'); legend(num2str(p(3)),num2str(mean(Cbetapre,2)),num2str(mean(Cbetapost,2)));
    subplot(224); bar([Cgammapre Cgammapost]); title('Gamma'); legend(num2str(p(4)),num2str(mean(Cgammapre,2)),num2str(mean(Cgammapost,2)));
    
    mean(Calphapre)
    mean(Calphapost)
    mean(Cbetapre)
    mean(Cbetapost)
    mean(Cthetapre)
    mean(Cthetapost)
    mean(Cgammapre)
    mean(Cgammapost)
    pause;
    
    
    % plot(C);
   % pause;
   %[C,phi,S12,S1,S2,f,zerosp,confC,phistd,Cerr]=coherencycpt(trl_data,ts,params,0)

    %ts1=trl_ts1/Fs_lfp;
   
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%spk-field coherence analysis
% 
%     if ((numel(ts1)>250) && numel(ts2>250))
%         ts1_pre3 = ts1;
%         ts1_post3 = ts2;
%         
%         %ts1_pre = ts1;
%         %ts1_post = ts2;
%         
%         params.Fs=Fs_lfp;
%         params.fpass=[0 20];
%         params.tapers=[taper(1) taper(2)];
%         params.trialave=1;
%         params.pad=1;
%         params.err=[2 0.05];
%         
      %   ts1_bin_rate_pre=mean(histc(ts1,bin_vector));
%         ts1_bin_rate_post=mean(histc(ts1_post3,bin_vector));
% %         ts1_change=((ts1_bin_rate_post-ts1_bin_rate_pre)/ts1_bin_rate_pre)*100;        
% %        ts1_change=numel(ts1_post3)-numel(ts1_pre3);
%         if numel(ts1_post3)>numel(ts1_pre3) 
%             temp_ind=randperm(length(ts1_post3));
%             ts1_post=sort(ts1_post3(temp_ind(1:length(ts1_pre3))));
%             ts1_pre=ts1_pre3;
%         else
%             temp_ind=randperm(length(ts1_pre3));
%             ts1_pre=sort(ts1_pre3(temp_ind(1:length(ts1_post3))));
%             ts1_post=ts1_post3;
%         end
%         %     lfp_pre=lfp_pre;
%         disp(length(lfp_pre'))
%         %     figure(1);
%         %     subplot(2,1,1)
%         %     plot(lfp_pre)
%         if length(lfp_pre)<length(dN_pre)
%             dN_pre=dN_pre(1:length(lfp_pre));
%         else
%             lfp_pre=lfp_pre(1:length(dN_pre));
%         end
%         [C_pre,phi_pre,S12_pre,S1_pre,S2_pre,f_pre,zerosp_pre,confC_pre,phistd_pre,Cerr_pre]=coherencysegcpb(lfp_pre,dN_pre,win,params,1);
%         temp=isnan(C_pre);
%         [a b]=find(temp==1);
%         c=unique(b);
%         d=setdiff(1:size(C_pre,2),c);
%         C_pre5=C_pre(:,d);
%         C_pre6=mean(C_pre5,2);
%         %      figure(i)
%         %     subplot(1,2,1)
%         %     plot(f_pre,C_pre); hold on
%         [x1 ind1]=find(f_pre<.3);
%         [x2 ind2]=find(f_pre<3);
%         [x3 ind3]=find(f_pre<8);
%         [x4 ind4]=find(f_pre<15);
%         
%         c1= mean(C_pre((ind1(end)+1):(ind2(end)-1)))
%         sws_premax_med(i) = max(C_pre((ind1(end)+1):(ind2(end)-1)))
%         sws_premean_med(i) =c1;
%         
%         c2= mean(C_pre((ind3(end)+1):(ind4(end)-1)))
%         
%         spindle_premax_med(i)= max(C_pre((ind3(end)+1):(ind4(end)-1)))
%         spindle_premean_med(i)=c2;
%         phi_pre_sws_med(i)=mean(phi_pre((ind1(end)+1):(ind2(end)-1)));
%         phi_pre_spindle_med(i)=mean(phi_pre((ind3(end)+1):(ind4(end)-1)));
%         
%         %     line([0 60],[c1 c1],'Color','b');
%         
%         %     [sleep_pre_min min_ind_pre]=min(sleep_dur_pre);
%         disp(length(lfp_post'))
%         [dN_post,t_post]=binspikes(ts1_post,1017.3,[0 round(length(lfp_post)/Fs_lfp)]);
%         if length(lfp_post)<length(dN_post)
%             dN_post=dN_post(1:length(lfp_post));
%         else
%             lfp_post=lfp_post(1:length(dN_post));
%         end
%         [C_post,phi_post,S12_post,S1_post,S2_post,f_post,zerosp_post,confC_post,phistd_post,Cerr_post]=coherencysegcpb(lfp_post,dN_post,win,params,1);
%         temp=isnan(C_post);
%         [a b]=find(temp==1);
%         
%         c=unique(b);
%         d=setdiff(1:size(C_post,2),c);
%         C_post5=C_post(:,d);
%         C_post6=mean(C_post5,2);
%         %     plot(f_post,C_post,'r');
%         
%         [x1 ind1]=find(f_post<.3);
%         [x2 ind2]=find(f_post<3);
%         [x3 ind3]=find(f_post<11);
%         [x4 ind4]=find(f_post<16);
%         
%         c3=mean(C_post((ind1(end)+1):(ind2(end)-1)));
%         sws_postmax_med(i)= max(C_post((ind1(end)+1):(ind2(end)-1)));
%         sws_postmean_med(i)=c3;
%         
%         c4=mean(C_post((ind3(end)+1):(ind4(end)-1)));
%         spindle_postmax_med(i)= max(C_post((ind3(end)+1):(ind4(end)-1)));
%         spindle_postmean_med(i)=c4;
%         phi_post_sws_med(i)=mean(phi_post((ind1(end)+1):(ind2(end)-1)));
%         phi_post_spindle_med(i)=mean(phi_post((ind3(end)+1):(ind4(end)-1)));
%         
%         
%         Change_sws_med(i)=((c3-c1)/c1)*100;
%         Change_spindle_med(i)=((c4-c2)/c2)*100;
%         phi_change_sws_med(i)     = phi_post_sws_med(i)-phi_pre_sws_med(i);
%         phi_change_spindle_med(i) = phi_post_spindle_med(i)-phi_pre_spindle_med(i);
%         C_pre_all(i,:)=C_pre;
%         C_post_all(i,:)=C_post;
%         C_change(i,:)=C_post-C_pre;
%         
%         disp(((c3-c1)/c1)*100)
%         
%         %     phi_pre_all_med(i)=phi_pre;
%         %     figure(i)
%         %     plot(f_pre,C_pre,'b'); hold on
%         %     plot(f_post,C_post,'r');
%         pltlng = length(find(f_pre<21));
%         h = figure;shadedErrorBar(f_pre(:),smooth(C_pre(:),20),cat(2,smooth(Cerr_pre(1,:),20),smooth(Cerr_pre(2,:),20))','b',1);
%         hold on;
%         shadedErrorBar(f_post(:),smooth(C_post(:),20),cat(2,smooth(Cerr_post(1,:),20),smooth(Cerr_post(2,:),20)),'r',1);
%         % shadedErrorBar(f_post_SP,smooth(C_post_SP,20),cat(2,smooth(Cerr_post_SP(1,:),20),smooth(Cerr_post_SP(2,:),20)),'g',1);
%         axis auto;
%         box off
%      
%         
%        %     figure(i);shadedErrorBar(f_pre,smooth(C_pre,20),cat(2,smooth(Cerr_pre(1,:),20),smooth(Cerr_pre(2,:),20)),'b',1);
%         %     h=figure(i);
%         %     hold on;
%         %     shadedErrorBar(f_post,smooth(C_post,20),cat(2,smooth(Cerr_post(1,:),20),smooth(Cerr_post(2,:),20)),'r',1);
%         %     box off
%         
%         %      errorbar(f_pre,smooth(C_pre,20),Cerr_pre,'b');hold on
%         
%         
%         
%         %     errorbar(f_post,smooth(C_post,20),Cerr_pre,'r');
%         %Session='T25\Control1\';
%         %    filename=['C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\' Session 'SFC post_FP-SC' num2str(sc) '_Ch' num2str(unit) '.tiff'];
% %         filename = strcat(dir,'SFC post_FP-SCnew_', num2str(sc), '_Ch', num2str(unit),'.tiff');
% %         saveas(h,filename);
% %         close all;

end
 
% tmpdir = strcat(dir,'cens/');
% if(~exist(tmpdir,'dir'))
%     mkdir(tmpdir)
% end
% Change_sws_med=1;
% Change_spindle_med=1;
%     cd(dir)
% % if exist('b_pre','var')
% h = figure(1);
% imagesc(mean(b_change,3), [-0.5 0.5]); shading interp; axis ([0 20 0 20]); colorbar;
% filename = strcat(dir,'bicoh_diff_mean', num2str(sc),'.tiff');
% saveas(h,filename);
% close all;
%     savefile = strcat('bicoherdata_SC_', num2str(sc), '.mat');
% %     save (savefile,... %'Change_sws', 'Change_spindle', 'sws_premax', 'sws_postmax', 'sws_premean', 'sws_postmean', 'spindle_premax', 'spindle_postmax', 'spindle_premean', 'spindle_postmean', 'phi_pre_sws', 'phi_pre_spindle', 'phi_post_sws', 'phi_post_spindle', 'phi_change_sws', 'phi_change_spindle', 'data1', 'data2', 'time_pre',...
% %     'Change_sws_med', 'Change_spindle_med', 'sws_premax_med', 'sws_postmax_med', 'sws_premean_med', 'sws_postmean_med', 'spindle_premax_med', 'spindle_postmax_med', 'spindle_premean_med', 'spindle_postmean_med', 'phi_pre_sws_med', 'phi_pre_spindle_med', 'phi_post_sws_med', 'phi_post_spindle_med', 'phi_change_sws_med' ,'phi_change_spindle_med', 'C_pre_all','C_post_all', 'C_change');
% %     
% %     save (savefile, 'Change_sws_med', 'Change_spindle_med', 'sws_premax_med', 'sws_postmax_med', 'sws_premean_med', 'sws_postmean_med', 'spindle_premax_med', 'spindle_postmax_med', 'spindle_premean_med', 'spindle_postmean_med', 'phi_pre_sws_med', 'phi_pre_spindle_med', 'phi_post_sws_med', 'phi_post_spindle_med', 'phi_change_sws_med' ,'phi_change_spindle_med', 'C_pre_all','C_post_all', 'C_change');
% save(savefile,'b_pre','b_post','b_change');
