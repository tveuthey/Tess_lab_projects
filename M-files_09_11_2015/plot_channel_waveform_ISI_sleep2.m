

function [Change_firing]=plot_channel_waveform_ISI_sleep2(Waves1,Waves2,TimeStamps1,TimeStamps2,N,units,sleep_ind_pre, sleep_ind_post,Fs_lfp)
close all
for i=1:length(units)
    close;
    chan_no=units(i);
    
    W1=Waves1{chan_no,N};
    W2=Waves2{chan_no,N};
    T1=TimeStamps1{chan_no,N}*Fs_lfp;
    T2=TimeStamps2{chan_no,N}*Fs_lfp;
    
%    Wpre=W1(:,:);
    Wpre = [];
    Wpost=[];
    l1 = 0;
    l2 = 0;
    T1a=[];
    T2a=[];
 %   ts1a=[];ts1atmp=[];ts1atmp2=[];

%     for j = 1:length(sleep_ind_pre)
%     tsind1 = find(T1>sleep_ind_pre(j,1) & T1<sleep_ind_pre(j,2));
%     Wpre = [Wpre, W1(:,tsind1)];
%     T1a = [T1a,T1a(sind1)];
%     l1 = l1 + (sleep_ind_pre(j,2)-sleep_ind_pre(j,1));    
%     end
% 
%     for j = 1:length(sleep_ind_post)
%     tsind2 = find(T2>sleep_ind_post(j,1) & T2<sleep_ind_post(j,2));
%     Wpost = [Wpost, W2(:,tsind2)];
%     T2a = [T2a,T2a(tsind2)];
% 
%     l2 = l2 + (sleep_ind_post(j,2)-sleep_ind_post(j,1));
%     end
    
    l1 = sleep_ind_pre(end)-sleep_ind_pre(1);
    l2 = sleep_ind_post(end)-sleep_ind_post(1);
    
    sws1=round((l1)/Fs_lfp);
    disp(length(sws1))
    sws2=round((l2)/Fs_lfp);
    disp(length(sws2))
    
    bin_vector=(sws1(1):0.05:sws1(end))-sws1(1);
    % bin_rate
    
    TS1=T1;
    TS2=T2;
    
    ts1_sws1s=find(TS1>sws1(1));
    ts1_sws1e=find(TS1<sws1(end));
    ts1_pre=intersect(ts1_sws1s,ts1_sws1e);
    TS1_preSWS=(TS1(ts1_pre));
    TS1_preSWS=TS1_preSWS-sws1(1);
    Wpre=W1(:,:);
    bin_rate_pre=mean(histc(TS1_preSWS,bin_vector));
    
    ts1_sws2s=find(TS2>sws2(1));
    ts1_sws2e=find(TS2<sws2(end));
    ts1_post=intersect(ts1_sws2s,ts1_sws2e);
    TS1_postSWS=TS2(ts1_post)-sws2(1);
    Wpost=W2(:,:);
    bin_rate_post=mean(histc(TS1_postSWS,bin_vector));
    
    waves_pre=mean(Wpre,2);
    sta_waves_pre=std(Wpre,0,2)/sqrt((size(Wpre,2))-1); hold on;
    
    Change_firing{i}=((bin_rate_post-bin_rate_pre)/bin_rate_pre)*100;
    
    
    subplot(2,2,1)
    shadedErrorBar([],waves_pre,(100*sta_waves_pre),'b',0);hold on; %plot(W,'c')
    
    XLim([0 30]);
    YLim([-0.00025 0.00015]);
    set(gca,'XTick',[0 30],'FontSize',14,'FontWeight','BOLD');
    set(gca,'XTickLabel',{'0','1.2'},'FontSize',14,'FontWeight','BOLD');
    set(gca,'YTick',[-0.00015 0 0.00015],'FontSize',14,'FontWeight','BOLD');
    set(gca,'YTickLabel',{'-150','0','150'},'FontSize',14,'FontWeight','BOLD');
    xlabel('time(msec)','FontSize',14,'FontWeight','BOLD'); ylabel('microvolt','FontSize',14,'FontWeight','BOLD');
    t=['Pre' num2str(bin_rate_pre)];
    title(t,'FontSize',14,'FontWeight','BOLD')
    
    waves_post=mean(Wpost,2);
    sta_waves_post=std(Wpost,0,2)/sqrt((size(Wpost,2))-1); hold on;
    subplot(2,2,2)
    shadedErrorBar([],waves_post,(100*sta_waves_post),'g',0);hold on; %plot(W,'c')
    
    %  plot(waves,'y');
    XLim([0 30]);
    YLim([-0.00025 0.00015]);
    set(gca,'XTick',[0 30],'FontSize',14,'FontWeight','BOLD');
    set(gca,'XTickLabel',{'0','1.2'},'FontSize',14,'FontWeight','BOLD');
    set(gca,'YTick',[-0.00015 0 0.00015],'FontSize',14,'FontWeight','BOLD');
    set(gca,'YTickLabel',{'-150','0','150'},'FontSize',14,'FontWeight','BOLD');
    xlabel('time(msec)','FontSize',14,'FontWeight','BOLD'); ylabel('microvolt','FontSize',14,'FontWeight','BOLD');
    t=['Post' num2str(bin_rate_post)];
    title(t,'FontSize',14,'FontWeight','BOLD')
    
    
    subplot(2,2,3)
    
    bar(histc(diff(TS1_preSWS),[0.005:0.001:0.100]),'EdgeColor','k','FaceColor','r');
    set(gca,'XTick',[0 20 40 60 80 100],'FontSize',14,'FontWeight','BOLD');
    set(gca,'XLim',[0 80.5]);set(gca,'XTickLabel',{'0.00','0.02','0.04','0.06','0.08','0.10'},'FontSize',14,'FontWeight','BOLD')
    xlabel('Interspike Interval (s)','FontSize',14,'FontWeight','BOLD');
    ylabel ('Counts','FontSize',14,'FontWeight','BOLD');
    t=['ISI Histogram Ch' num2str(chan_no)];
    title(t,'FontSize',14,'FontWeight','BOLD')
    
    
    subplot(2,2,4)
    
    bar(histc(diff(TS1_postSWS),[0.005:0.001:0.100]),'EdgeColor','k','FaceColor','g');
    set(gca,'XTick',[0 20 40 60 80 100],'FontSize',14,'FontWeight','BOLD');
    set(gca,'XLim',[0 80.5]);set(gca,'XTickLabel',{'0.00','0.02','0.04','0.06','0.08','0.10'},'FontSize',14,'FontWeight','BOLD')
    xlabel('Interspike Interval (s)','FontSize',14,'FontWeight','BOLD');
    ylabel ('Counts','FontSize',14,'FontWeight','BOLD');
    t=['ISI Histogram Ch' num2str(chan_no)];
    title(t,'FontSize',14,'FontWeight','BOLD')
    
    
    
    set(gcf, 'Position', get(0,'Screensize'));

    %if N==2
        filename= ['C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T12_allblocks\censored\Sleep1nsSleep2ns\Waveform SC' int2str(N) 'Ch' num2str(chan_no) '.tiff'];
        set(gcf, 'Position', get(0,'Screensize'));
        saveas(gcf,filename);
    %elseif N ==3
%        filename= ['C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T28\Day1Session2\Waveform SC3 Ch' num2str(chan_no) '.tiff'];
%         set(gcf, 'Position', get(0,'Screensize'));
%         saveas(gcf,filename);
      %  if N==3
%             filename=['C:\Users\Ganguly Lab\Documents\MATLAB\Tanuj\Mat_files\Result_figs\BMI\S23\2_26_13\Waveform SC2 Ch' num2str(chan_no) '.tiff'];
%             set(gcf, 'Position', get(0,'Screensize'));
%             saveas(gcf,filename);
%         end
     %end
end

Output=Change_firing;