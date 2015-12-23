%originally plot_rater_peth_M1str
%modified 05/10/2015 TV

function plot_raster_peth_M1M2_TV(units,trial_marker,TimeStamps,len_bef,len_aft,bin,Block_name,type,ratID)

count = 0;
Fs_lfp = 1017.3;
trp=[];
trn=[];
%trltert = round(length(trial_marker)/3);

%%%%%setting paramaters for spline estimation (BARS)
bp = barsdefaultParams;
bp.prior_id = 'POISSON';
bp.dparams = 4;
bin2 = [len_bef*-1:bin:len_aft]/Fs_lfp';

% for each sort code (for all the units)
for a = 1:length(units)
    ts_bin=zeros(length(trial_marker),length(bin2));
    ts_nobin=zeros(length(trial_marker),len_bef+len_aft);
    units_sc = units(a).un;
    sc = a;
    
    %for channel that has that sort code
    for i = 1:length(units_sc)
        ts = TimeStamps{units_sc(i),sc};
        count = count+1;
        gdtrlcnt=0;
        
        %for each trial
        for j= 1:length(trial_marker)
            if (~isnan(trial_marker(j))&~isnan(ts))
                t=[trial_marker(j)-len_bef, trial_marker(j)+len_aft]/Fs_lfp;
                %             else
                %                 t = [(trial_start(j)+1017 -len_bef),(trial_start(j)+1017+len_aft)]/Fs_lfp;
                %             end
                tstmp = ts(ts>t(1) & ts<t(2));
                if ~isempty(tstmp)
                    bin1 = [t(1):bin/Fs_lfp:t(2)];
                    ts_bin(j,:) =  histc(tstmp,bin1);
                    ts_nobin(j,:) = histc(tstmp,[t(1):(1/Fs_lfp):t(2)-(1/Fs_lfp)]);
                else
                    ts_bin(j,:) = NaN;
                    ts_nobin(j,:)=NaN;
                end
            else
                ts_bin(j,:) = NaN;
                ts_nobin(j,:)=NaN;
            end
        end
        
        %         trltert = round(length(trial_marker)/3);
        %         nn = ~isnan(ts_bin(:,1));
        %         sm=0;cnte=0; cntl = 0;
        %         if (sum(nn))>2*trltert
        %             while sm <= trltert;
        %                 cnte=cnte+1;
        %                 sm = sm + nn(cnte);
        %             end
        %
        %             sm=0;
        %             while sm < trltert;
        %                 sm = sm + nn(end-cntl);
        %                 cntl=cntl+1;
        %             end
        %         else
        %             while sm <= sum(nn)/2 && cnte<numel(nn);
        %                 cnte=cnte+1;
        %                 sm = sm + nn(cnte);
        %             end
        %
        %             sm=0;
        %             while sm <= sum(nn)/2 && cnte<numel(nn);
        %                 sm = sm + nn(end-cntl);
        %                 cntl=cntl+1;
        %             end
        %         end
        nn = ~isnan(ts_bin(:,1));
        peth(count).un = [units_sc(i),sc];
        peth(count).bin = nansum(ts_bin);
        peth(count).med = nanmean(ts_bin);
        peth(count).std = nanstd(ts_bin)/sqrt(size(ts_bin,1));
        peth(count).tl=size(ts_bin,1);
        %         peth(count).binearly = nansum(ts_bin(1:30,:));
        %         peth(count).binlate = nansum(ts_bin(end-29:end,:));
        %
        if (max(max(peth(count).bin))>1)
            peth(count).fit = barsP(peth(count).bin,[0 len_bef+len_aft]/Fs_lfp,length(trial_marker),bp);
            %      peth(count).fitearly = barsP(peth(count).binearly,[0 len_bef+len_aft]/Fs_lfp,30,bp);
            %      peth(count).fitlate = barsP(peth(count).binlate,[0 len_bef+len_aft]/Fs_lfp,30,bp);
            close all;
            peth(count).fit.models=[]; peth(count).fitearly.models=[]; peth(count).fitlate.models=[];
            
            %plot raster
            h = figure('units','normalized','outerposition',[0 0 1 1]); pause(0.01);
            subplot(121); hold on;
            plts = ts_nobin;
            %        plts(plts==0)=NaN;
            for k = 1:size(plts,1)
                tmp = find(plts(k,:)==1);
                if ~isempty(tmp)
                    plot([(tmp-len_bef)/1000;(tmp-len_bef)/1000],[k,k+.5],'k'); axis auto;
                end
                %             if ~isnan(trial_marker(k))
                %                 plot([-1*len_bef:1:len_aft-1],plts(k,:)*k,'.k');
                %             else
                %                 plot([-1*len_bef:1:len_aft-1],plts(k,:)*k,'.r');
                %             end
            end
            yl = max([peth(count).bin]);
            t = strcat('Raster for Unit: ',num2str(units_sc(i)),' Sort code',num2str(sc)); title(t);
            
            %plot histogram
            subplot(222); hold on;
            bar(bin2,peth(count).bin,'r'); title('Trials PETH'); ylim([0 yl]); %axis tight;
            %             plot(zeros(int8(yl)+1,1),[0:1:yl],'--k'); %was not sure if
            %             int8 is causing a crash when yl is >127
            plot(zeros((yl)+1,1),[0:1:yl],'--k');
            mo = [type,' onset'];
            text((-0.3*len_bef)/Fs_lfp, yl-.5,mo);
            
            %             subplot(324); hold on;
            %             bar(bin2,peth(count).binlate); title('Late Trials PETH'); ylim([0 yl]); %axis tight;
            %             plot(zeros(yl+1,1),[0:1:yl],'--k');
            %             mo = [type,' onset'];
            %             text((-0.3*len_bef)/Fs_lfp, yl-.5,mo);
            %
            
            %plot spline fit of firing rate
            subplot(224); hold on;
            cshadedErrorBar(bin2,peth(count).fit.mean,peth(count).fit.confBands,'-r',1);
            title ('Spline Fit of Firing Rate:');
            plot(zeros((yl)+1,1),[0:1:yl],'--r');
            %             plot(zeros(int8(yl)+1,1),[0:1:yl],'--r');
            mo = [type,' onset'];
            text((-0.3*len_bef)/Fs_lfp, yl-.5,mo);
            
            t2 = strcat(ratID,'_',Block_name,'_PETH_Unit',num2str(units_sc(i)),'_SC',num2str(sc),'_Centered_to_',type,'_reachtrials');
            
            %title below used for DR's PETH graphs
            %t2 = strcat(dir,'PETH Unit',num2str(units_sc(i)),'SC',num2str(sc),'Centered to ',type,'reachtrials');
            
            % pause;
            saveas(h,t2,'tiff')
            close all;
            %figure h = figure('units','normalized','outerposition',[0 0 1 1]); pause(0.01);
            lm = peth(count).fit.confBands;
            lm = peth(count).fit.confBands;
            lm = peth(count).fit.confBands;
            pre = (len_bef/bin)*0.5;
            ze = (len_bef/bin);
            post = (len_aft/bin)*0.8+ze;
            lmh = max(lm(1:pre,2));
            lml = min(lm(1:pre,1));
            p = find(lm(ze:post,1)>(lmh));
            v = find(lm(ze:post,2)<(lml));
            
            if length(p)>2
                trp(count)=units_sc(i);
            end
            if length(v)>2
                trn(count)=units_sc(i);
            end
        end
    end
end


close all;

%summary figure for positively-modulated units
figure('units','normalized','outerposition',[0 0 1 1]); pause(0.01);
nm = length(find(trp));
h = zeros(1, nm);
colors =colormap(hsv(nm));
c = 0;
for l = 1:length(trp)
    if trp(l)~=0
        hold on;
        c = c+1;
        h(c) = plot(bin2,peth(l).fit.mean, 'Color', colors(c, :),...
            'DisplayName',sprintf('%d,%d',peth(l).un(1),peth(1).un(2)));
        tm(:,c)=peth(l).fit.mean;
    end
end

if exist('tm')
    yl = max(max(tm))+2;
    legend(h,'Location','Northwest'); legend boxoff;  xlabel ('Seconds'); ylabel ('Instantaneous spike num');
    ylim([0 yl]);
    plot(zeros((floor(yl))+1,1),[0:1:yl],'--k');
    %         plot(zeros(int8(floor(yl))+1,1),[0:1:yl],'--k');
    mo = [type,' onset'];
    text(0.1, yl-0.5,mo);
    t = ['Spike Timing Across Positively Modulated-Related Units']; title(t);
    t2 = strcat(ratID,Block_name,'_Spike_Timing_Positive_TR',type,'reachtrials'); %previous title line
    %pause;
    saveas(gcf,t2,'tiff');
end
close all;

%summary figure for negatively-modulated units
h = figure('units','normalized','outerposition',[0 0 1 1]); pause(0.01);
nm = length(find(trn));
h = zeros(1, nm);
colors =colormap(hsv(nm));
c = 0;

for l = 1:length(trn)
    if trn(l)~=0
        hold on;
        c = c+1;
        h(c) = plot(bin2,peth(l).fit.mean, 'Color', colors(c, :),...
            'DisplayName',sprintf('%d,%d',peth(l).un(1),peth(l).un(2)));
        tm(:,c)=peth(l).fit.mean;
    end
end
if exist('tm')
    yl = max(max(tm))+2;
    legend(h,'Location','Northwest'); legend boxoff;  xlabel ('Seconds'); ylabel ('Instantaneous spike num');
    ylim([0 yl]);
    plot(zeros((floor(yl))+1,1),[0:1:yl],'--k');
    %         plot(zeros(int8(floor(yl))+1,1),[0:1:yl],'--k');
    
    mo = [type,' onset'];
    text(0.1, yl-0.5,mo);
    t = ['Spike Timing Across Negatively Modulated-Related Units']; title(t);
    t2 = strcat(ratID,Block_name,'_Spike Timing Negative TR',type,'reachtrials');
    saveas(gcf,t2,'tiff');
    close all;
end
%pause;
savefile = [ratID,Block_name,'_peth2_reachtrialsonly_centeredto_',type,'.mat'];
save (savefile, 'peth', 'trp', 'trn','ratID','Block_name');

close all; %clc;
end
