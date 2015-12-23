function [Output c1max c2max c1mean c2mean]=plot_SWS_coherence3_neuromod(TimeStamps1,TimeStamps2,data1,data2, time_pre,time_post,units, chan_no, sc, bin_size,space, Fs_lfp, taper, win)
figure
close all

% [r i]=find(wave>1);
% time_pre=1:round(i(1)-1);
% time_dur=round(i(1)):round(i(end));
% time_post=round(i(end)+1):length(wave);
% 
% time_pre=time_pre(1:round(300*Fs_lfp));
% 
% l1=length(time_pre);
% l2=length(time_dur);
% l3=length(time_post);
% 
data1r=[];
data2r=[];
for i = 1:length(time_pre)
    data1r=[data1r data1(time_pre(i,1):time_pre(i,2))];
end

for i = 1:length(time_post)
    data2r=[data2r data2(time_post(i,1):time_post(i,2))];
end

clear data1 data2
data1=data1r;
data2=data2r;
clear data1r data2r

if length(time_pre)<length(time_post)
    time_post=time_post(1:length(time_pre));
else
    time_pre=time_pre(1:length(time_post));
end

bin_vector=round(time_pre(1)/Fs_lfp):bin_size:(round(time_pre(end)/Fs_lfp)-round(time_pre(1)/Fs_lfp));

for i=1:length(units)
    close
    unit=units(i);
    
    clear ts_pre ts_post lfp_pre lfp_post
    ts_pre=[];
    ts_post=[];
    lfp_pre=[];
    lfp_post=[];
    
    if isempty(chan_no)==1
        if unit==1
            chan_no=[3];
        else
            if unit==2
                chan_no=[4];
            else
                if unit==3
                    chan_no=[6];
                else if unit==4
                        chan_no=[6];
                    else if unit==5
                            chan_no=[7];
                        else if unit==6
                                chan_no=[8];
                            else if unit==7
                                    chan_no=[2];
                                else if unit==8
                                        chan_no=[15];
                                    else if unit==9
                                            chan_no=[11];
                                        else if unit==10
                                                chan_no=[12];
                                            else if unit==11
                                                    chan_no=[13];
                                                else if unit==12
                                                        chan_no=[14];
                                                    else if unit==13
                                                            chan_no=[15];
                                                        else if unit==14
                                                                chan_no=[16];
                                                            else if unit==15
                                                                    chan_no=[31];
                                                                else if unit==16
                                                                        chan_no=[9];
                                                                    else if unit==17
                                                                            chan_no=[19];
                                                                        else if unit==18
                                                                                chan_no=[20];
                                                                            else if unit==19
                                                                                    chan_no=[21];
                                                                                else if unit==20
                                                                                        chan_no=[22];
                                                                                    else if unit==21
                                                                                            chan_no=[23];
                                                                                        else if unit==22
                                                                                                chan_no=[24];
                                                                                            else if unit==23
                                                                                                    chan_no=[21];
                                                                                                else if unit==24
                                                                                                        chan_no=[31];
                                                                                                    else if unit==25
                                                                                                            chan_no=[27];
                                                                                                        else if unit==26
                                                                                                                chan_no=[28];
                                                                                                            else if unit==27
                                                                                                                    chan_no=[29];
                                                                                                                else if unit==28
                                                                                                                        chan_no=[30];
                                                                                                                    else if unit==29
                                                                                                                            chan_no=[31];
                                                                                                                        else if unit==30
                                                                                                                                chan_no=[32];
                                                                                                                            else if unit==31
                                                                                                                                    chan_no=[15];
                                                                                                                                else if unit==32
                                                                                                                                        chan_no=[25];
                                                                                                                                    end
                                                                                                                                end
                                                                                                                            end
                                                                                                                        end
                                                                                                                    end
                                                                                                                end
                                                                                                            end
                                                                                                        end
                                                                                                    end
                                                                                                end
                                                                                            end
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        disp('using' )
        disp(chan_no)
        disp('for')
        disp(unit)
    end
    
    lfp=data(chan_no,:);
    lfp=median(data);
    lfp=base_norm(lfp);
    
    ts1tmp=TimeStamps1{unit,sc};
    ts2tmp=TimeStamps2{unit,sc}; 
    ts1tmp=ts1tmp*Fs_lfp;
    ts2tmp=ts2tmp*Fs_lfp;
    ts1a=[];
    ts2a=[];
    
    for j = 1:length(time_pre)
        clear ts1tmpa ts1tmpb ts1tmpc
        ts1tmpa=ts1a>time_pre(j,1);
        ts1tmpb=ts1a<time_pre(j,2);
        ts1tmpc=intsersect(ts1tmpa,ts1tmpb);
        ts1a= [ts1a ts1tmpc];
    end
    
    for j = 1:length(time_ppst)
        clear ts2tmpa ts2tmpb ts2tmpc
        ts2tmpa=ts2a>time_post(j,1);
        ts2tmpb=ts2a<time_post(j,2);
        ts2tmpc=intsersect(ts2tmpa,ts2tmpb);
        ts2a= [ts2a ts2tmpc];
    end
    ts1a=ts1a/Fs_lfp;
    ts2a=ts2a/Fs_lfp; 
    ts1=ts1a(1:space:end);
    ts2=ts2a(1:space:end);

    %   data_sp(1).times=[ts];
    
    
    params.Fs=Fs_lfp;
    params.fpass=[0 60];
    params.tapers=[taper(1) taper(2)];
    params.trialave=1;
    params.pad=1;
    params.err=[2 0.05];
    
    
    
    
    ts1_pres=find(ts1>round(time_pre(1)/Fs_lfp));
    ts1_pree=find(ts1<round(time_pre(end)/Fs_lfp));
    ts1_pre1=intersect(ts1_pres,ts1_pree);
    ts1_pre2=(ts1(ts1_pre1));
    ts1_pre3=ts1_pre2-ts1_pre2(1);
    ts1_bin_rate_pre=mean(histc(ts1_pre3,bin_vector));
    lfp_pre=[lfp_pre lfp(time_pre)];
    
    ts1_posts=find(ts1>round(time_post(1)/Fs_lfp));
    ts1_poste=find(ts1<round(time_post(end)/Fs_lfp));
    ts1_post1=intersect(ts1_posts,ts1_poste);
    ts1_post2=(ts1(ts1_post1));
    ts1_post3=ts1_post2-ts1_post2(1);
    ts1_bin_rate_post=mean(histc(ts1_post3,bin_vector));
    lfp_post=[lfp_post lfp(time_post)];
    
    
    ts1_change=((ts1_bin_rate_post-ts1_bin_rate_pre)/ts1_bin_rate_pre)*100;
    
    if ts1_change>0
        temp_ind=randperm(length(ts1_post3));
        ts1_post=sort(ts1_post3(temp_ind(1:length(ts1_pre3))));
        %         ts1_post=ts1_post3(1:((ts1_bin_rate_post-ts1_bin_rate_pre)/ts1_bin_rate_pre):end);
        ts1_pre=ts1_pre3;
    else
        temp_ind=randperm(length(ts1_pre3));
        ts1_pre=sort(ts1_pre3(temp_ind(1:length(ts1_post3))));
        %         ts1_pre=ts1_pre3(1:((ts1_bin_rate_pre-ts1_bin_rate_post)/ts1_bin_rate_post):end);
        ts1_post=ts1_post3;
    end
    
    lfp_pre=lfp_pre';
    disp(length(lfp_pre'))
    %     figure(1);
    %     subplot(2,1,1)
    %     plot(lfp_pre)
    [dN_pre,t_pre]=binspikes(ts1_pre,1017.3,[0 round(length(lfp_pre)/Fs_lfp)]);
    if length(lfp_pre)<length(dN_pre)
        dN_pre=dN_pre(1:length(lfp_pre),:);
    else
        lfp_pre=lfp_pre(1:length(dN_pre),:);
    end
    
    [C_pre,phi_pre,S12_pre,S1_pre,S2_pre,f_pre,zerosp_pre,confC_pre,phistd_pre,Cerr_pre]=coherencysegcpb(lfp_pre,dN_pre,win,params,1);
    
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
    
    
    c1= mean(C_pre((ind1(end)+1):(ind2(end)-1)))
    c1max{i}= max(C_pre((ind1(end)+1):(ind2(end)-1)))
    c1mean{i}=c1
    
    line([0 60],[c1 c1],'Color','b');
    
    %     [sleep_pre_min min_ind_pre]=min(sleep_dur_pre);
    
    
    
    lfp_post=lfp_post';
    disp(length(lfp_post'))
    
    [dN_post,t_post]=binspikes(ts1_post,1017.3,[0 round(length(lfp_post)/Fs_lfp)]);
    if length(lfp_post)<length(dN_post)
        dN_post=dN_post(1:length(lfp_post),:);
    else
        lfp_post=lfp_post(1:length(dN_post),:);
    end
    [C_post,phi_post,S12_post,S1_post,S2_post,f_post,zerosp_post,confC_post,phistd_post,Cerr_post]=coherencysegcpb(lfp_post,dN_post,win,params,1);
    temp=isnan(C_post);
    [a b]=find(temp==1);
    
    c=unique(b);
    d=setdiff(1:size(C_post,2),c);
    C_post5=C_post(:,d);
    C_post6=mean(C_post5,2);
    plot(f_post,C_post,'r');
    
    [x1 ind1]=find(f_pre<.3);
    [x2 ind2]=find(f_pre<3);
    
    
    
    c2= mean(C_post((ind1(end)+1):(ind2(end)-1)))
      c2max{i}= max(C_post((ind1(end)+1):(ind2(end)-1)))
      c2mean{i}=c2
      
    line([0 60],[c2 c2],'Color','r');
    Change{i}=((c2-c1)/c1)*100;
    disp(((c2-c1)/c1)*100)
    
    
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
    Session='R38\';
    %     window=num2str(win);
    if sc==2
        filename=['C:\Users\Ganguly Lab\Documents\MATLAB\Tanuj\Mat_files\Result_figs\New (Acute_Neuromod_I)\' Session 'SFC post_FP-SC2_Ch' num2str(unit) '.tiff'];
    else
        if sc==3
            filename=['C:\Users\Ganguly Lab\Documents\MATLAB\Tanuj\Mat_files\Result_figs\New (Acute_Neuromod_I)\' Session ' SFC post_FP-SC3_Ch' num2str(unit) '.tiff'];
        else
            if sc==4
                filename=['C:\Users\Ganguly Lab\Documents\MATLAB\Tanuj\Mat_files\Result_figs\New (Acute_Neuromod_I)\' Session ' SFC post_FP-SC4_Ch' num2str(unit) '.tiff'];
                %             set(h, 'Position', get(0,'Screensize'));
            else
                if sc==5
                    filename=['C:\Users\Ganguly Lab\Documents\MATLAB\Tanuj\Mat_files\Result_figs\New (Acute_Neuromod_I)\' Session ' SFC post_FP-SC5_Ch' num2str(unit) '.tiff'];
                    %             set(h, 'Position', get(0,'Screensize'));
                end
            end
            %             set(h, 'Position', get(0,'Screensize'));
        end
    end
    saveas(h,filename);
end
Output=Change;
c1max;
c2max;
c1mean;
c2mean;


% %
%     Session='T12\6_3_13Early\ ';
% %     window=num2str(win);
%     filename=['C:\Users\Ganguly Lab\Documents\MATLAB\Tanuj\Mat_files\Result_figs\BMI\' Session 'SWA Coherence New post-SC1' num2str(win) 'Ch' num2str(unit) '.tiff'];
%     set(h, 'Position', get(0,'Screensize'));
% %
%             saveas(h,filename);
% %     end
% % end
% % Output=change;





