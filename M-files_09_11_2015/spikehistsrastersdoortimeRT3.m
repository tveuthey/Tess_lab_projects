close all

clear rastertics data_lfp temp_strobe data_lfpfilt data_lfpfilt2 doorind ts_norm t doordelta;
trials_NO=length(Reach);
y_max=0;
block_len=2441;
before_zero=1220; % looking 1.2 sec before and after grab time at 1017 samples/sec
figure;
chan_no=4;
sortcode=2; %use 1 for MU activity, and subsequently 2/3/4 depending on sorted unit yield per channel
%t=[(before_zero/Fs_lfp):(block_len-before_zero/Fs_lfp)];
for chan_no=[chan_no]
    for n=1:trials_NO
    temp_strobe(:,:,n)=strobe(Reach(n)-before_zero:Reach(n)+block_len-before_zero);
    range_lfp=round([Reach(n)-before_zero:Reach(n)+block_len-before_zero]);
    data_lfp(:,:,n)=data(chan_no,range_lfp);
    %mean_data_lfp(chan_no,:)=mean(data_lfp,2)
    
    %% filter parameters
    nf=Fs_lfp/2;
    f_lo=100;
    f_hi=253;
    [b,a]=butter(6,[f_lo/nf,f_hi/nf]);
    
    data_lfpfilt(:,:,n)=filter(b,a,data(chan_no,range_lfp)); 
    data_lfpfilt(:,:,n)=smooth(abs(data_lfpfilt(:,:,n)));
    %old filter GiszterLab
    data_lfpfilt2(n,:)=RMSMovAvg(data(chan_no,range_lfp),80,8);
    data_lfpfilt2(n,:)=inv(diag(std(data_lfpfilt2(n,:),[],2)))*data_lfpfilt2(n,:);

    t=[Reach(n)-before_zero:Reach(n)+block_len-before_zero]/Fs_wave;
    disp(t-t(1));
   
    tstamps=TimeStamps{chan_no,sortcode};
    t2=find(tstamps>t(1));
    t3=find(tstamps>t(end));
    if ~isempty(t2) && ~isempty(t3)
        range2=[t2(1):(t3(1)-1)];%/Fs_lfp;
        ts_range2=tstamps(range2);
        ts_range4{n}=[ts_range2-t(1)];
        bin_vector = [(t(1):0.05:t(end))-t(1)];
        bin_rate = zeros (length (bin_vector),trials_NO);
        spikes = Trial_spike_times {trials_NO,spike_no};
         if ~isempty (ts_range4)
            if length(ts_range4) == 1
                binned = histc(ts_range4,bin_vector);
            else
                binned = histc(ts_range4,bin_vector)';
            end
            bin_rate (:,n) = binned;
         end

     
       
        %ts_bin(:,:,n)= hist(ts_norm,[(t(1):0.05:t(end))-t(1)]);
        %rasterplot(ts_norm,n,4000)
%         mean_ts=mean(timestamps)
%         hist(tstamps(range2),30)
    end
    
%     ph = psth(times, binsize, fs, ntrials, triallen, varargin)
    %pause
    if ~isempty(t2) && ~isempty(t3)
        range3=[t2(1):(t3(1)-1)];
        ts_range3=tstamps(range3);
        ts_norm=ts_range3-t(1);
        disp([chan_no length(find(tstamps(range3)>0))])
        rastertics{n}=[ts_norm];%; tstamps(range3)];
        doorind(:,:,n)=Reward(n)/Fs_wave- t(1);
    end

    end
end
    mean_temp_strobe=mean(temp_strobe,3);
    mean_data_lfp=mean(data_lfp,3);
    mean_data_lfpfilt=mean(data_lfpfilt,3);
    mean_data_lfpfilt2=mean(data_lfpfilt2,1);
  
%     time_axis=[1:length(data_lfp)];
%     [time_axis2]=[time_axis]/Fs_lfp;
% mean_ts=mean(hist(ts_norm,3);    
% mean_ts=mean(ts_bin,3);
% for j=1:trials_NO
% times=cat(2,ts_range4{});
    PEH_rate = sum(bin_rate,2)/trials_NO/0.05; % average firing rate for the the rate
    if y_max < max(PEH_rate )  % finds the maximum rate for all targets
        y_max = max(PEH_rate );
    end
% maxLength=max(cellfun(@(x)numel(x),ts_range4));
% times=cell2mat(cellfun(@(x)cat(2,x,NaN(1,maxLength-length(x))),ts_range4,'UniformOutput',false));
% times2=times(:,(isfinite(times(1,:))));
% end
    axh=subplot(5,1,1);
    plot(mean_temp_strobe,'c'); %axis([0 1218 -5 5]); set(axh, 'XGrid', 'on');set(gca,'XTick',[0 349 697 609 1046 1393 1742]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'})
    hold on;
    a=axis;
    line([before_zero before_zero],a(3:4),'Color','g')
    hold off
    axi=subplot(5,1,2);
    axi_a=min(mean_data_lfp(:,:));
    axi_b=max(mean_data_lfp(:,:));
    plot(mean_data_lfp(:,:),'b'); %axis([0 1218 axi_a axi_b]); set(axi, 'XGrid', 'on');set(gca,'XTick',[0 203 406 609 812 1015 1218]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'})
    
    ax3=subplot(5,1,3);
%     mean_data_lfpfilt2=smooth(abs(mean_data_lfpfilt(:,:,chan_no)))';
   axi_3min=min(mean_data_lfpfilt);
    axi_3max=max(mean_data_lfpfilt);
    plot(mean_data_lfpfilt(:,:),'r-'); %axis([0 1218 axi_3min axi_3max]); set(ax3, 'XGrid', 'on');set(gca,'XTick',[0 203 406 609 812 1015 1218]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'})
%     hold on;
%     axi_3min=min(mean_data_lfpfilt2);
%     axi_3max=max(mean_data_lfpfilt2);
%     plot(mean_data_lfpfilt2(:,:),'g-'); %axis(round([0 152 axi_3min axi_3max])); set(ax3, 'XGrid', 'on');set(gca,'XTick',[0   25.3750   50.7500   76.1250  101.5000  126.8750  152.2500]);set(gca,'XTickLabel',{'-120','-80','-40','0','40','80','120'})
%     hold off;
    ax4=subplot(5,1,4)
    hold on;
%     ts_max=max(mean_ts)+1
%     bar(mean_ts);axis([0 48 0 ts_max]);set(gca,'XTick',[0 8 16 24 32 40 48]); set(ax4, 'XGrid', 'on');set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'})
% ax4 = psth(times2, 50, Fs_SPK, trials_NO, 58594,ax4)
max_trials=trials_NO
plot ([(t(1):0.05:t(end))-t(1)],15*PEH_rate/y_max+max_trials,'k','LineWidth',2);
% ts_cat2=cat(3,ts_cat)
% subplot(5,1,5)
% rasterplot(ts_cat2,[trials_NO-1],4000,[],508)
   
    for n4=1:trials_NO-1
        [doordelta,ind]=sort(doorind,3);
    rastertics2{n4}=rastertics{ind(n4)};
    rastertics3{n4}=[rastertics2{n4};rastertics2{n4}];
    subplot(5,1,5)
        plot(rastertics3{n4},[0 1]+n4,'k','LineWidth',2);plot(doordelta(n4),[0 1]+n4,'rx');XLim([0 2.4]);set(gca,'XTick',[0 0.4 .8 1.2 1.6 2.0 2.4]);set(gca,'XTickLabel',{'-1.2','-0.8','-0.4','0','0.4','0.8','1.2'}) %axis([0 2.4 (0+n4) (1+n4)]);%hold off;
      
        hold on
    end
    XLabel('time (sec)')
    
    saveas(gcf,'Mat_files/Result_figs/Block317_Chan1_SC1','pdf')
  

% mean_temp_strobe=mean(temp_strobe,3);
% %mean_data_lfp=mean(data_lfp,3);
% mean_data_lfp=mean(data_lfp,1);
% mean_ts=mean(ts_bin(:,:),1);
% figure(chan_no)
% subplot(5,1,1);
% plot(mean_temp_strobe,'c')
% hold on;
% a=axis;
% line([before_zero before_zero],a(3:4),'Color','g')
% hold off
% subplot(5,1,2)
% plot(mean_data_lfp(:,:,chan_no,:))
% subplot(5,1,4)
% bar(mean_ts)
% ts_cat2=cat(3,ts_cat)
% subplot(5,1,5)
% rasterplot(ts_cat2,[trials_NO-1],4000,[],508)

