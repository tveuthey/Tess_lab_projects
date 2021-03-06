trials_NO=length(Reach);
block_len=4000;
before_zero=2000;
chan_no=25;
sortcode=2;
%t=[(before_zero/Fs_lfp):(block_len-before_zero/Fs_lfp)];
for chan_no=[chan_no]
    for n=1:trials_NO-1
    temp_strobe(:,:,n)=strobe(Reach(n)-before_zero:Reach(n)+block_len-before_zero);
    range_lfp=round([Reach(n)-before_zero:Reach(n)+block_len-before_zero]);
    data_lfp(n,:,chan_no)=data(chan_no,range_lfp);
    %mean_data_lfp(chan_no,:)=mean(data_lfp,2)

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
%         mean_ts=mean(timestamps)
%         hist(tstamps(range2),30)
    end
    
    %pause
    end
end
mean_temp_strobe=mean(temp_strobe,3);
%mean_data_lfp=mean(data_lfp,3);
mean_data_lfp=mean(data_lfp,1);
mean_ts=mean(ts_bin(:,:),1);
figure(chan_no)
subplot(5,1,1);
plot(mean_temp_strobe,'c')
hold on;
a=axis;
line([before_zero before_zero],a(3:4),'Color','g')
hold off
subplot(5,1,2)
plot(mean_data_lfp(:,:,chan_no,:))
subplot(5,1,4)
bar(mean_ts)

