function [Output2 Output c1max c2max c1mean c2mean p1mean p2mean C_pref C_postf]=plot_SWS_coherence3(TimeStamps,data, units, chan_no, sc, bin_size,space, sleep_ind_pre, sleep_ind_post, Fs_lfp, taper, win)
figure
close all
Output2=zeros(length(units),9);
for i=1:length(units)
%     close
    unit=units(i);
    
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
                                        chan_no=[7];
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
    
    lfp=median(data(:,:));
    % lfp=decimate(lfp,2);
    lfp=base_norm(lfp);
    ts=TimeStamps{unit,sc};%*Fs_lfp;
    ts=ts(1:space:end);
    %   data_sp(1).times=[ts];
    
    
    params.Fs=Fs_lfp;
    params.fpass=[0 200];
    params.tapers=[taper(1) taper(2)];
    params.trialave=1;
    params.pad=1;
    params.err=[2 0.05];
    
    clear ts_pre ts_post lfp_pre lfp_post
    ts_pre=[];
    ts_post=[];
    lfp_pre=[];
    lfp_post=[];
    
    for n=1:size(sleep_ind_pre,1)
        %         clear ts_pre lfp_pre
        %         ts_pre=[];
        %         lfp_pre=[];
        
        %     clear TS10_s1
        sws1=[sleep_ind_pre(n,1):sleep_ind_pre(n,2)];
        %         sleep_dur_pre(n)=([sleep_ind_pre(n,2)-sleep_ind_pre(n,1)]);
        s_ts=find(ts>round(sws1(1)/Fs_lfp));
        e_ts=find(ts<round(sws1(end)/Fs_lfp));
        ts1=intersect(s_ts,e_ts);
        lfp_pre=[lfp_pre lfp(sws1(1):sws1(end))];
        
        % TS10_s1=TS10(ts);
        if n==1
            ts_pre=[ts_pre ts(ts1)-round(sws1(1)/Fs_lfp)];
        else
            
            ts_pre=[ts_pre (ts(ts1)-round(sws1(1)/Fs_lfp))+(round(length(lfp_pre)/Fs_lfp))];
        end
        
        %         [dN_pre,t_pre]=binspikes(ts_pre,1017.3,[0 round(length(lfp_pre)/Fs_lfp)]);
        %         if length(lfp_pre)<length(dN_pre)
        %             dN_pre=dN_pre(1:length(lfp_pre),:);
        %         else
        %             lfp_pre=lfp_pre(1:length(dN_pre),:);
        %         end
        %
        %         [C_pre,phi_pre,S12_pre,S1_pre,S2_pre,f_pre,zerosp_pre,confC_pre,phistd_pre,Cerr_pre]=coherencysegcpb(lfp_pre,dN_pre,3,params,0);
        %           C_pre1=mean(C_pre,1);
        %          C_pre2= C_pre1(~isnan(C_pre1));
        %          C_pre3(n,:)=mean(C_pre2,2)
        disp(n)
        
    end
    lfp_pre=lfp_pre';
    disp(length(lfp_pre'))
    figure(1);
    subplot(2,1,1)
    plot(lfp_pre)
    [dN_pre,t_pre]=binspikes(ts_pre,1017.3,[0 round(length(lfp_pre)/Fs_lfp)]);
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
    
    temp2=isnan(phi_pre);
    [a2 b2]=find(temp2==1);
    
    c2=unique(b2);
    d2=setdiff(1:size(phi_pre,2),c2);
    phi_pre5=phi_pre(:,d2);
    phi_pre6=mean(phi_pre5,2);
    %     figure(i)
    %     subplot(1,2,1)
    %     plot(f_pre,phi_pre); hold on
    
    
    
    
    c1= mean(C_pre((ind1(end)+1):(ind2(end)-1)));
    c1max{i}= max(C_pre((ind1(end)+1):(ind2(end)-1)))
    c1mean{i}=c1
    p1mean{i}= mean(phi_pre((ind1(end)+1):(ind2(end)-1)))
    C_pref(i,:)=C_pre;
    
    c1max2= max(C_pre((ind1(end)+1):(ind2(end)-1)))
    c1mean2=c1
    p1mean2= mean(phi_pre((ind1(end)+1):(ind2(end)-1)))
    line([0 200],[c1 c1],'Color','b');
    
    
    %     [sleep_pre_min min_ind_pre]=min(sleep_dur_pre);
    
    
    for n=1:size(sleep_ind_post,1)
        
        
        %     clear TS10_s1
        sws2=round([sleep_ind_post(n,1):sleep_ind_post(n,2)]);
        %         sleep_dur_post(n)=([sleep_ind_post(n,2)-sleep_ind_post(n,1)]);
        
        s_ts=find(ts>round(sws2(1)/Fs_lfp));
        e_ts=find(ts<round(sws2(end)/Fs_lfp));
        ts1=intersect(s_ts,e_ts);
        lfp_post=[lfp_post lfp(sws2(1):sws2(end))];
        %         TS10_s1=TS10(ts);
        if n==1
            ts_post=[ts_post ts(ts1)-round(sws2(1)/Fs_lfp)];
        else
            ts_post=[ts_post (ts(ts1)-round(sws2(1)/Fs_lfp))+(round(length(lfp_post)/Fs_lfp))];
        end
        disp(n)
        
    end
    
    lfp_post=lfp_post';
    disp(length(lfp_post'))
    
    [dN_post,t_post]=binspikes(ts_post,1017.3,[0 round(length(lfp_post)/Fs_lfp)]);
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
    %     plot(f_post,phi_post,'r');
    plot(f_post,C_post,'r');
    
    [x1 ind1]=find(f_pre<.3);
    [x2 ind2]=find(f_pre<3);
    
    %     temp2=isnan(phi_post);
    %     [a2 b2]=find(temp2==1);
    %
    %     c2=unique(b2);
    %     d2=setdiff(1:size(phi_post,2),c2);
    %     phi_post5=phi_post(:,d2);
    %     phi_post6=mean(phi_post5,2);
    %     plot(f_post,C_post,'r');
    
    
    %     [x1 ind1]=find(f_pre<.3);
    %     [x2 ind2]=find(f_pre<3);
    
    p2mean{i}= mean(phi_post((ind1(end)+1):(ind2(end)-1)))
    p2mean2= mean(phi_post((ind1(end)+1):(ind2(end)-1)))
    
    c2= mean(C_post((ind1(end)+1):(ind2(end)-1)))
    c2max{i}= max(C_post((ind1(end)+1):(ind2(end)-1)))
    c2max2= max(C_post((ind1(end)+1):(ind2(end)-1)))
    c2mean{i}=c2
    c2mean2=c2
     C_postf(i,:)=C_post;
    
    
    line([0 200],[c2 c2],'Color','r');
    Change{i}=((c2-c1)/c1)*100;
    Change2=((c2-c1)/c1)*100;
    disp(((c2-c1)/c1)*100)
    Output2(i,:)=[unit 0 Change2 c1mean2 c2mean2 c1max2 c2max2 p1mean2 p2mean2]
    
    h=figure(i)
    figure(i+32);shadedErrorBar(f_pre,smooth(C_pre.*(1/2),20),cat(2,smooth(Cerr_pre(1,:).*(1/2),20),smooth(Cerr_pre(2,:).*(1/2),20)),'b',1);
    hold on;
    shadedErrorBar(f_post,smooth(C_post.*(1/2),20),cat(2,smooth(Cerr_post(1,:).*(1/2),20),smooth(Cerr_post(2,:).*(1/2),20)),'r',1);
    %     subplot(1,2,2)
    %     plot(f_pre,S1_pre,'k');hold on
    %     plot(f_post,S1_post,'r');
    %       figure(1);
    %     subplot(2,1,2)s
    %     plot(lfp_post)
    Session='T49\2_27_14\ ';
    %     window=num2str(win);
    if sc==2
        filename=['C:\Users\Ganguly Lab\Documents\MATLAB\Tanuj\Mat_files\Result_figs\BMI\' Session 'SWA Coherence New post-SC1' num2str(win) 'Ch' num2str(unit) '.tiff'];
    else
        if sc==3
            filename=['C:\Users\Ganguly Lab\Documents\MATLAB\Tanuj\Mat_files\Result_figs\BMI\' Session 'SWA Coherence New post-SC2' num2str(win) 'Ch' num2str(unit) '.tiff'];
            set(h, 'Position', get(0,'Screensize'));
        end
    end
%          saveas(h,filename);
    %     Phi_Pre=c_phi_pre2;
    % Phi_Post=c_phi_post2;
end
disp ('6667')
Output=Change2;
c1max;
c2max;
c1mean;
c2mean;
p1mean;
p2mean;
end




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





