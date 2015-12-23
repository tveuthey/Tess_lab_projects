% close all 4,5
%chan_nos=[4,5,7,8,10,11,12,13,15,17,19,20,22,24,26,27,29,32];
%chan_nos=[20,22,24,26,27,29,32];
chan_nos = units;
%[1,2,3,4,5,6,7,8,10,11,12,13,15,17,20,22,24,26,27,29,32];

for ii = 1:length(chan_nos)
% close all
clear rastertics data_lfp data_lfp1 temp_strobe data_lfpfilt data_lfpfilt2 doorind ts_norm t doordelta binned bin_rate bin_rate2 hold val data_filt1 label data_hil data_hil_corr data_hil_incorr data_lfpfilt_corr;
clear data_lfpfilt_incorr data_hil data_hil1 waves_corr waves_incorr waves_range2
sigma = 4;
size = 30;
x = linspace(-size / 2, size / 2, size);
gaussFilter = exp(-x .^ 2 / (2 * sigma ^ 2));
gaussFilter = gaussFilter / sum (gaussFilter); % normalize

bin_rate=[];
bin_rate_gauss=[];
trials_NO=length(Reach);
y_max=0;
%time for LFPs, rasters, PETHs
block_len=1016*3;
before_zero=2032*2; % looking 4.0 sec before and 2.0 sec after door open time at 1017 samples/sec
% figure;
sortcode=2; %use 1 for MU activity, and subsequently 2/3/4 depending on sorted unit yield per channel
bin_size = 50;
for chan_no =chan_nos(ii)
    peak(1,ii)= chan_no;
    for n=1:trials_NO;
        t=[Reach(n)-before_zero:Reach(n)+block_len]/Fs_lfp;
        tstamps=TimeStamps{chan_no,sortcode};
        trial1=find(tstamps>t(1)); 
        trial2=find(tstamps>t(end));
        if(~isempty (trial1) && ~isempty(trial2))
        trialrange=[trial1(1):trial2(1)-1];%/Fs_lfp;
        
        pre_bv = [(t(1):0.05:t(end))-t(1)];
        pre_bv2 = [(t(1):0.001:t(end))-t(1)];
        ts_range=tstamps(trialrange);
        rastertics{n}=ts_range;
        trcnt{n}=[ts_range-t(1)];
        binned= histc(trcnt{n},pre_bv)*20;    
        binned2= histc(trcnt{n},pre_bv2);      
        bin_rate =[bin_rate; binned];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%GAUSSIAN FILTER
        b_gauss = conv(binned, gaussFilter, 'same');
        bin_rate_gauss =[bin_rate_gauss; b_gauss];
%         subplot(3,1,2);plot(temp3); axis([0 length(temp3) -0.2 1.2]);title('Block 185 +/-300 uA 3.5min ','FontSize',16,'FontWeight','BOLD')
        hold on;
%         subplot(211)
         y = ones(1,length(binned2));
        binned3 = [binned2;binned2];
%         rastertics2{n}=[rastertics{n};rastertics{n}];
%         subplot(211); plot(rastertics2{n},[0 1]+n,'k','LineWidth',2);
            if ~isempty(find(binned2))

                subplot(211); plot(find(binned2)/Fs_lfp,n,'k.','LineWidth',2); YLim([1 trials_NO]); %XLim([0 (length(binned3)/Fs_lfp)])
%         plot(b_gauss,ii)
            end
%         pause;
        end
        subplot(211); plot(4,1:length(trials_NO),'-','LineWidth',3);
    end
end
t = strcat('Unit ',int2str(chan_no));
title(t);
% pause;
hold off;

mfr = mean(bin_rate_gauss);
mfr_1 = mean(bin_rate_gauss(1:30,:));
mfr_2 = mean(bin_rate_gauss(31:end,:));
% stdfr = std(bin_rate_gauss);
hold on
flag=0;
for i = 1:15
    ul = mean(mfr(20:50))+(std(mfr(20:50))*4);
    ll = mean(mfr(20:50))-(std(mfr(20:50))*4);
    t = mean(mfr(59+i:63+i));
    if(t>ul)
        col(ii)='r';
        peak(2,ii)= find(mfr(60:100) == (max(mfr(60:100))))+40; 
        break
    elseif (t <ll)
        col(ii)='g';
        peak(2,ii)= find(mfr(60:100) == (min(mfr(60:100))))+40; 
        break
    else
        col(ii)='k';
        peak(2,ii)= find(mfr(60:100) == (max(mfr(60:100))))+40; 

    end
end
subplot(212)
hold on;
plot(1:101,mfr(20:120),col(ii));
plot(1:100,mean(mfr(20:50))-(std(mfr(20:50))*4),'b','LineWidth',3)
plot(1:100,mean(mfr(20:50))+(std(mfr(20:50))*4),'b','LineWidth',3)
text(60,min(mfr(20:120)),'Reward');
 text(find(mfr==max(abs(mfr(40:80)))),max(abs(mfr(40:80))),int2str(chan_no));
%saveas(gcf,output,'tiff')
 saveas(gcf,strcat('Task_Block2_Unit',int2str(chan_no)),'tiff')
%
% close all;
hold off;
%pause;
close all;
end
 save(strcat('Block2','peak.mat'),'peak');
  
for i = 1:length(chan_nos)
    hold on;
    scatter(peak(2,i),i,'*',col(i));
    text(peak(2,i),i+.2,int2str(chan_nos(i)))
end
    plot(60,1:.01:9,'LineWidth',3);

    saveas(gcf,strcat('Task_Block2_peaks','tiff'));
    