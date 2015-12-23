function plot_raster_peth_alltrials(units,trial_start,trial_marker,TimeStamps,len_bef,len_aft,bin,dir,type)
count = 0;
Fs_lfp = 1017.3;
trltert = round(length(trial_marker)/3);
bp = barsdefaultParams;
bp.prior_id = 'POISSON';
bp.dparams = 4;
bin2 = [len_bef*-1:bin:len_aft]/Fs_lfp';

for a = length(units)
    ts_bin=zeros(length(trial_marker),length(bin2));
    ts_nobin=zeros(length(trial_marker),len_bef+len_aft);
    units_sc = units(a).un;
    sc = a+1;
    for i = 1:length(units_sc)
        ts = TimeStamps{units_sc(i),sc};
        count = count+1;
        for j= 1:length(trial_marker)
            if ~isnan(trial_marker(j))
                t=[trial_marker(j)-len_bef, trial_marker(j)+len_aft]/Fs_lfp;
            else
                t = [(trial_start(j)+1017 -len_bef),(trial_start(j)+1017+len_aft)]/Fs_lfp;
            end
            tstmp = ts(ts>t(1) & ts<t(2));
            trial(j).ts = tstmp;
            bin1 = [t(1):bin/Fs_lfp:t(2)];
            ts_bin(j,:) =  histc(tstmp,bin1);
            ts_nobin(j,:) = histc(tstmp,[t(1):(1/Fs_lfp):t(2)-(1/Fs_lfp)]);
        end
        
        peth(count).bin = nansum(ts_bin);
        peth(count).binearly = nansum(ts_bin(1:trltert,:));
        peth(count).binlate = nansum(ts_bin(end-trltert+1:end,:));
        peth(count).fit = barsP(peth(count).bin,[0 len_bef+len_aft]/Fs_lfp,length(trial_marker),bp);
        peth(count).fitearly = barsP(peth(count).binearly,[0 len_bef+len_aft]/Fs_lfp,trltert,bp);
        peth(count).fitlate = barsP(peth(count).binlate,[0 len_bef+len_aft]/Fs_lfp,trltert,bp);
        
        close all;
        h = figure('units','normalized','outerposition',[0 0 1 1]); pause(0.01);
        subplot(121); hold on;
        plts = ts_nobin;
        plts(plts==0)=NaN;
        
        for k = 1:size(plts,1)
            plot([-1*len_bef:1:len_aft-1],plts(k,:)*k,'.k');
        end
        
        yl = max([peth(count).binearly,peth(count).binlate]);
        t = strcat('Raster for Unit: ',num2str(units_sc(i))); title(t);
        subplot(322); hold on;
        bar(bin2,peth(count).binearly,'r'); title('Early Trials PETH'); ylim([0 yl]); axis tight;
        subplot(324); hold on;
        bar(bin2,peth(count).binlate); title('Late Trials PETH'); ylim([0 yl]); axis tight;
        subplot(326)
        cShadedErrorBar(bin2,peth(count).fitearly.mean,peth(count).fitearly.confBands,'-r',1);
        hold on;
        cShadedErrorBar(bin2,peth(count).fitlate.mean,peth(count).fitlate.confBands,'-b',1);
        title ('Change in Firing Rate: Early Trials (Red) vs. Late Trials');
        t2 = strcat(dir,'PETH Unit',num2str(units_sc(i)),'Centered to ',type);
        pause;
        saveas(h,t2,'tiff')
        % Get object handles
        %         [LEGH,OBJH,OUTH,OUTM] = legend;
        %         % Add object with new handle and new legend string to legend
        %         legend([OUTH;hnew],OUTM{:},'Late Trials')
    end
end