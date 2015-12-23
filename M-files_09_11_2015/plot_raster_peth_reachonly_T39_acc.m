function plot_raster_peth_reachonly_T39_acc(trial_start,trial_marker,TimeStamps,len_bef,len_aft,bin,dir,type,acc)
count = 0;
inc_count=0;
corr_count=0;
Fs_lfp = 1017.3;
trp=[];
trn=[];
sc=1;

%%%%%setting paramaters for spline estimation (BARS)
bp = barsdefaultParams;
bp.prior_id = 'POISSON';
bp.dparams = 4;
bin2 = [len_bef*-1:bin:len_aft]/Fs_lfp';

ts_bin_corr=zeros(length(trial_marker),length(bin2));
ts_nobin=zeros(length(trial_marker),len_bef+len_aft);

for i = 1:length(TimeStamps)
    ts = TimeStamps(i).ts;
    count = count+1;
    ts_bin_corr=zeros(length(trial_marker),length(bin2));
    ts_bin_inc=zeros(length(trial_marker),length(bin2));    
    inc_count=0;
    corr_count=0;
    ts_nobin_inc=zeros(length(trial_marker),len_bef+len_aft);
    ts_nobin_corr=zeros(length(trial_marker),len_bef+len_aft);

    for j= 1:length(trial_marker)
        if(acc(j)==1)
            corr_count=corr_count+1;
%        if ~isnan(trial_marker(j))
            t=[trial_marker(j)-len_bef, trial_marker(j)+len_aft]/Fs_lfp;
            tstmp = ts(ts>t(1) & ts<t(2));
            bin1 = [t(1):bin/Fs_lfp:t(2)];
            ts_bin_corr(corr_count,:) =  histc(tstmp,bin1);
            ts_nobin(j,:) = histc(tstmp,[t(1):(1/Fs_lfp):t(2)-(1/Fs_lfp)]);
            ts_nobin_corr(corr_count,:) =  histc(tstmp,[t(1):(1/Fs_lfp):t(2)-(1/Fs_lfp)]);
        elseif (acc(j)==0)
            inc_count=inc_count+1; 
            t=[trial_marker(j)-len_bef, trial_marker(j)+len_aft]/Fs_lfp;
            tstmp = ts(ts>t(1) & ts<t(2));
            bin1 = [t(1):bin/Fs_lfp:t(2)];
            ts_bin_incorr(inc_count,:) =  histc(tstmp,bin1);
            ts_nobin(j,:) = histc(tstmp,[t(1):(1/Fs_lfp):t(2)-(1/Fs_lfp)]);
            ts_nobin_incorr(inc_count,:) =  histc(tstmp,[t(1):(1/Fs_lfp):t(2)-(1/Fs_lfp)]);
        end
    end
    sf = inc_count/corr_count;
    %ts_bin_corr=round(ts_bin_corr*sf);
    peth(count).un = i;
    peth(count).bin_corr = round(nansum(ts_bin_corr)*sf);
    peth(count).bin_inc = nansum(ts_bin_incorr);
    
    if (max(max(peth(count).bin_corr))>1 && max(max(peth(count).bin_inc))>1)
        %peth(count).fit = barsP(peth(count).bin,[0 len_bef+len_aft]/Fs_lfp,length(trial_marker),bp);
        peth(count).fit_corr = barsP(peth(count).bin_corr,[0 len_bef+len_aft]/Fs_lfp,round(corr_count*sf),bp);
        peth(count).fit_incorr = barsP(peth(count).bin_inc,[0 len_bef+len_aft]/Fs_lfp,inc_count,bp);
        close all;
        peth(count).fit.models=[]; peth(count).fit_corr.models=[]; peth(count).fit_incorr.models=[];
        h = figure('units','normalized','outerposition',[0 0 1 1]); pause(0.01);        
        subplot(221); hold on;
        plts= ts_nobin_corr;
        plts(plts==0)=NaN;
        for k = 1:size(plts,1)
                plot([-1*len_bef:1:len_aft-1],plts(k,:)*k,'.b'); 
        end        
        title(['Correct Trials Unit' num2str(i)]);
        
        subplot(223); hold on;
        plts= ts_nobin_incorr;
        plts(plts==0)=NaN;
        for k = 1:size(plts,1)
                plot([-1*len_bef:1:len_aft-1],plts(k,:)*k,'.r');
        end
      t = strcat('Incorrect Trials Unit: ',num2str(i)); title(t);

        yl = max([peth(count).bin_corr,peth(count).bin_inc]);
  %      t = strcat('Raster for Unit: ',num2str(i)); title(t);
        subplot(322); hold on;
        bar(bin2,peth(count).bin_corr,'b'); title('Correct Trials PETH'); ylim([0 yl]); %axis tight;
        plot(zeros(yl+1,1),[0:1:yl],'--k');
        mo = [type,' onset'];
        text((-0.3*len_bef)/Fs_lfp, yl-.5,mo);
        
        subplot(324); hold on;
        bar(bin2,peth(count).bin_inc,'r'); title('Incorrect PETH'); ylim([0 yl]); %axis tight;
        plot(zeros(yl+1,1),[0:1:yl],'--k');
        mo = [type,' onset'];
        text((-0.3*len_bef)/Fs_lfp, yl-.5,mo);
        
        subplot(326)
        cShadedErrorBar(bin2,peth(count).fit_corr.mean,peth(count).fit_corr.confBands,'-b',1);
        hold on;
        cShadedErrorBar(bin2,peth(count).fit_incorr.mean,peth(count).fit_incorr.confBands,'-r',1);
        title ('Change in Firing Rate: Correct Trials (Blue) vs. Incorrect Trials (Red)');
        plot(zeros(yl+1,1),[0:1:yl],'--k');
        mo = [type,' onset'];
        text((-0.3*len_bef)/Fs_lfp, yl-.5,mo);        
        t2 = strcat(dir,'PETH Unit',num2str(i),'SC',num2str(sc),'Centered to ',type,'acctrials');
        %pause;
        saveas(h,t2,'tiff')
        close all;
        %figure h = figure('units','normalized','outerposition',[0 0 1 1]); pause(0.01);
        lm = peth(count).fit_corr.confBands;
        pre = (len_bef/bin)*0.5;
        ze = (len_bef/bin);
        post = (len_aft/bin)*0.8+ze;
        lmh = max(lm(1:pre,2));
        lml = min(lm(1:pre,1));
        p = find(lm(ze:post,1)>(lmh));
        v = find(lm(ze:post,2)<(lml));
        
        if length(p)>2
            trp(count)=i;
        end
        if length(v)>2
            trn(count)=i;
        end
    end
end

close all;
figure('units','normalized','outerposition',[0 0 1 1]); pause(0.01);
nm = length(find(trp));
h = zeros(1, nm);
colors =colormap(hsv(nm));
c = 0;
for l = 1:length(trp)
    if trp(l)~=0
        hold on;
        c = c+1;
        h(c) = plot(bin2,peth(l).fit_corr.mean, 'Color', colors(c, :),...
            'DisplayName',sprintf('%d,%d',peth(l).un(1)));
        tm(:,c)=peth(l).fit_corr.mean;
    end
end
yl = max(max(tm))+2;
legend(h,'Location','Northwest'); legend boxoff;  xlabel ('Seconds'); ylabel ('Instantaneous spike num');
ylim([0 yl]);
plot(zeros(yl+1,1),[0:1:yl],'--k');
mo = [type,' onset'];
text(0.1, yl-0.5,mo);
t = ['Spike Timing Across Positively Modulated-Related Units']; title(t);
t2 = strcat(dir,'Spike Timing Positive TR',type,'acc_trials');
%pause;
saveas(gcf,t2,'tiff');

close all;
h = figure('units','normalized','outerposition',[0 0 1 1]); pause(0.01);
nm = length(find(trn));
h = zeros(1, nm);
colors =colormap(hsv(nm));
c = 0;
for l = 1:length(trn)
    if trn(l)~=0
        hold on;
        c = c+1;
        h(c) = plot(bin2,peth(l).fit_corr.mean, 'Color', colors(c, :),...
            'DisplayName',sprintf('%d,%d',peth(l).un(1)));
        tm(:,c)=peth(l).fit_corr.mean;
    end
end
yl = max(max(tm))+2;
legend(h,'Location','Northwest'); legend boxoff;  xlabel ('Seconds'); ylabel ('Instantaneous spike num');
ylim([0 yl]);
plot(zeros(yl+1,1),[0:1:yl],'--k');
mo = [type,' onset'];
text(0.1, yl-0.5,mo);
t = ['Spike Timing Across Negatively Modulated-Related Units']; title(t);
t2 = strcat(dir,'Spike Timing Negative TR',type,'acctrials');
saveas(gcf,t2,'tiff');
close all;
%pause;
savefile = [dir,'peth_acctrials_centeredto',type,'.mat'];
save (savefile, 'peth', 'trp', 'trn');
close all; clc;
end
