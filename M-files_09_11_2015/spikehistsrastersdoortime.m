clear ts_bin;
clear rastertics data_lfp temp_strobe data_lfpfilt
trials_NO=length(Reach);
block_len=4000;
before_zero=2000;
chan_no=22;
sortcode=2;
%t=[(before_zero/Fs_lfp):(block_len-before_zero/Fs_lfp)];
for chan_no=[chan_no]
    for n=1:trials_NO-1
    temp_strobe(:,:,n)=strobe(Reach(n)-before_zero:Reach(n)+block_len-before_zero);
    range_lfp=round([Reach(n)-before_zero:Reach(n)+block_len-before_zero]);
    data_lfp(n,:,chan_no)=data(chan_no,range_lfp);
    %mean_data_lfp(chan_no,:)=mean(data_lfp,2)
    
    
    nf=Fs_lfp/2;
    f_lo=100;
    f_hi=253;
    [b,a]=butter(6,[f_lo/nf,f_hi/nf]);
%[b,a]=butter(6,[f_hi/n],'low');
    data_lfpfilt(n,:,chan_no)=filter(b,a,data(chan_no,range_lfp)); 

    t=[Reach(n)-before_zero:Reach(n)+block_len-before_zero]/Fs_wave;
   disp(t-t(1))
   
    tstamps=TimeStamps{chan_no,sortcode};
    t2=find(tstamps>t(1));
    t3=find(tstamps>t(end));
    if ~isempty(t2) && ~isempty(t3)
        range2=[t2(1):(t3(1)-1)];%/Fs_lfp;
        ts_range2=tstamps(range2);
        ts_norm=ts_range2-t(1);
        disp(ts_norm)
        ts_bin(n,:)= hist(ts_norm,[(t(1):0.1:t(end))-t(1)]);
        %rasterplot(ts_norm,n,4000)
%         mean_ts=mean(timestamps)
%         hist(tstamps(range2),30)
    end
    
    %pause
    if ~isempty(t2) && ~isempty(t3)
        range3=[t2(1):(t3(1)-1)];
        ts_range3=tstamps(range3);
        ts_norm=ts_range3-t(1);
        disp([chan_no length(find(tstamps(range3)>0))])
        rastertics{n}=[ts_norm;ts_norm]%; tstamps(range3)];
        doorind(n)=Reward(n)/Fs_wave- t(1);
        
%             if t2<new_index(n)> t3;
%                 new_index2(n)=[new_index(n)-t(1)];        
%             end
        subplot(5,1,5)
        plot(rastertics{n},[0 1]+n,'k','LineWidth',2); plot(doorind(n),[0 1]+n,'rx');%hold off;
        %rasterplot(rastertics,n,range3)
        hold on
        %axis([0 8 0 Trial_No])
%         xlabel('Time(sec)')
%         ylabel('Trials')
%         title('Rasters with Door Open Indicator (^x)')
    end
    [doordelta,ind]=sort(doorind);
    rastertics2{:}=rastertics{ind};
    subplot(5,1,5)
        plot(rastertics2{n},[0 1]+n,'k','LineWidth',2); plot(doordelta(n),[0 1]+n,'rx');%hold off;
        %rasterplot(rastertics,n,range3)
        hold on

%     if ~isempty(t2) && ~isempty(t3)
%         range3=[t2(1):(t3(1)-1)];
%         ts_range3=tstamps(range3);
%         ts_cat(:,:,n)=ts_range3;
% %         ts_norm=cat(1,ts_range3(n));
% %         disp([chan_no length(find(tstamps(range3)>0))])
% %         rastertics{n}=[ts_norm;ts_norm]%; tstamps(range3)];
% %         subplot(5,1,5)
% %         plot(rastertics{n},[0 1]+n,'k','LineWidth',2);
% %         rasterplot(rastertics,n,range3)
% %         hold on
%     end
    mean_temp_strobe=mean(temp_strobe,3);
    mean_data_lfp=mean(data_lfp,1);
    mean_data_lfpfilt=mean(data_lfpfilt,1);
%     time_axis=[1:length(data_lfp)];
%     [time_axis2]=[time_axis]/Fs_lfp;
    mean_ts=mean(ts_bin(:,:),1);
    axh=subplot(5,1,1);
    plot(mean_temp_strobe,'c'); axis([0 4000 -5 5]); set(axh, 'XGrid', 'on');set(gca,'XTickLabel',{'0','1','2','3','4','5','6','7','8'})
    hold on;
    a=axis;
    line([before_zero before_zero],a(3:4),'Color','g')
    hold off
    axi=subplot(5,1,2);
    axi_a=min(mean_data_lfp(:,:,chan_no));
    axi_b=max(mean_data_lfp(:,:,chan_no));
    plot(mean_data_lfp(:,:,chan_no),'b'); axis([0 4000 axi_a axi_b]); set(axi, 'XGrid', 'on');set(gca,'XTickLabel',{'0','1','2','3','4','5','6','7','8'})
    ax3=subplot(5,1,3);
    mean_data_lfpfilt2=smooth(abs(mean_data_lfpfilt(:,:,chan_no)))';
   axi_3min=min(mean_data_lfpfilt2);
    axi_3max=max(mean_data_lfpfilt2);
    plot(mean_data_lfpfilt2,'r-'); axis([0 4000 axi_3min axi_3max]); 
    set(ax3, 'XGrid', 'on');set(gca,'XTickLabel',{'0','1','2','3','4','5','6','7','8'})
    ax4=subplot(5,1,4)
    bar(mean_ts); set(ax4, 'XGrid', 'on');set(gca,'XTickLabel',{'0','1','2','3','4','5','6','7','8'})
% ts_cat2=cat(3,ts_cat)
% subplot(5,1,5)
% rasterplot(ts_cat2,[trials_NO-1],4000,[],508)
    end
end
   
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

