clear ts_bin;
clear rastertics temp_strobe range_lfp data_lfp
trials_NO=length(Reach);
   disp(t-t(1))
block_len=6000;
before_zero=2000;
chan_no=9;
sortcode=2;
%t=[(before_zero/Fs_lfp):(block_len-before_zero/Fs_lfp)];
for ii = 1:length(chan_nos)
    chan_no=chan_nos(ii)
    figure;
    clear rastertics temp_strobe range_lfp data_lfp

    for n=1:trials_NO-1
    temp_strobe(:,:,n)= strobe(Reach(n)-before_zero:Reach(n)+block_len-before_zero);
    range_lfp= round([Reach(n)-before_zero:Reach(n)+block_len-before_zero]);
    data_lfp(n,:,chan_no)= data(chan_no,range_lfp);
    
    %mean_data_lfp(chan_no,:)=mean(data_lfp,2)
    t=[Reach(n)-before_zero:Reach(n)+block_len-before_zero]/Fs_wave;
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
        subplot(5,1,5)
        plot(rastertics{n},[0 1]+n,'k','LineWidth',2);
        %rasterplot(rastertics,n,range3)
        hold on
    end
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
    mean_ts=mean(ts_bin(:,:),1);
    axh=subplot(5,1,1);
    plot(mean_temp_strobe,'c'); axis([0 4000 -5 5]); set(axh, 'XGrid', 'on')
    hold on;
    a=axis;
    line([before_zero before_zero],a(3:4),'Color','g')
    hold off
    axi=subplot(5,1,2)
    axi_a=min(mean_data_lfp(:,:,chan_no))
    axi_b=max(mean_data_lfp(:,:,chan_no))
    plot(mean_data_lfp(:,:,chan_no)); axis([0 4000 axi_a axi_b]); set(axi, 'XGrid', 'on')
    subplot(5,1,4)
    bar(mean_ts)
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

