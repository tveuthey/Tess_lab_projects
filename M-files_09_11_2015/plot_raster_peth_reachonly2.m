function plot_raster_peth_reachonly2(units,trial_start,trial_marker,TimeStamps,len_bef,len_aft,bin,dir,type)

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

for a = 1:length(units)
    ts_bin=zeros(length(trial_marker),length(bin2));
    ts_nobin=zeros(length(trial_marker),len_bef+len_aft);
    units_sc = units(a).un;
    sc = a+1;
    for i = 1:length(units_sc)
        ts = TimeStamps{units_sc(i),sc};
        count = count+1;
        gdtrlcnt=0;
        for j= 1:length(trial_marker)
            if (~isnan(trial_marker(j))&~isnan(ts))
                t=[trial_marker(j)-len_bef, trial_marker(j)+len_aft]/Fs_lfp;
                %             else
                %                 t = [(trial_start(j)+1017 -len_bef),(trial_start(j)+1017+len_aft)]/Fs_lfp;
                %             end
                tstmp = ts(ts>t(1) & ts<t(2));
                bin1 = [t(1):bin/Fs_lfp:t(2)];
                 ts_bin(j,:) =  histc(tstmp,bin1);
                ts_nobin(j,:) = histc(tstmp,[t(1):(1/Fs_lfp):t(2)-(1/Fs_lfp)]);
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
        peth(count).binearly = nansum(ts_bin(1:30,:));
        peth(count).binlate = nansum(ts_bin(end-29:end,:));
        
        if (max(max(peth(count).binearly))>1 && max(max(peth(count).binlate))>1)
            peth(count).fit = barsP(peth(count).bin,[0 len_bef+len_aft]/Fs_lfp,length(trial_marker),bp);
            peth(count).fitearly = barsP(peth(count).binearly,[0 len_bef+len_aft]/Fs_lfp,30,bp);
            peth(count).fitlate = barsP(peth(count).binlate,[0 len_bef+len_aft]/Fs_lfp,30,bp);
            close all;
            peth(count).fit.models=[]; peth(count).fitearly.models=[]; peth(count).fitlate.models=[];
            h = figure('units','normalized','outerposition',[0 0 1 1]); pause(0.01);
            subplot(121); hold on;
            plts = ts_nobin;
            plts(plts==0)=NaN;
            for k = 1:size(plts,1)
                if ~isnan(trial_marker(k))
                plot([-1*len_bef:1:len_aft-1],plts(k,:)*k,'.k');
                else
                plot([-1*len_bef:1:len_aft-1],plts(k,:)*k,'.r');
                end
            end
            yl = max([peth(count).binearly,peth(count).binlate]);
            t = strcat('Raster for Unit: ',num2str(units_sc(i))); title(t);
            subplot(322); hold on;
            bar(bin2,peth(count).binearly,'r'); title('Early Trials PETH'); ylim([0 yl]); %axis tight;
            plot(zeros(yl+1,1),[0:1:yl],'--k');
            mo = [type,' onset'];
            text((-0.3*len_bef)/Fs_lfp, yl-.5,mo);
            
            subplot(324); hold on;
            bar(bin2,peth(count).binlate); title('Late Trials PETH'); ylim([0 yl]); %axis tight;
            plot(zeros(yl+1,1),[0:1:yl],'--k');
            mo = [type,' onset'];
            text((-0.3*len_bef)/Fs_lfp, yl-.5,mo);
            
            subplot(326)
            cShadedErrorBar(bin2,peth(count).fitearly.mean,peth(count).fitearly.confBands,'-r',1);
            hold on;
            cShadedErrorBar(bin2,peth(count).fitlate.mean,peth(count).fitlate.confBands,'-b',1);
            title ('Change in Firing Rate: Early Trials (Red) vs. Late Trials');
            plot(zeros(yl+1,1),[0:1:yl],'--k');
            mo = [type,' onset'];
            text((-0.3*len_bef)/Fs_lfp, yl-.5,mo);
            
            t2 = strcat(dir,'PETH Unit',num2str(units_sc(i)),'SC',num2str(sc),'Centered to ',type,'reachtrials');
            %       pause;
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
yl = max(max(tm))+2;
legend(h,'Location','Northwest'); legend boxoff;  xlabel ('Seconds'); ylabel ('Instantaneous spike num');
ylim([0 yl]);
plot(zeros(yl+1,1),[0:1:yl],'--k');
mo = [type,' onset'];
text(0.1, yl-0.5,mo);
t = ['Spike Timing Across Positively Modulated-Related Units']; title(t);
t2 = strcat(dir,'Spike Timing Positive TR',type,'reachtrials');
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
        h(c) = plot(bin2,peth(l).fit.mean, 'Color', colors(c, :),...
            'DisplayName',sprintf('%d,%d',peth(l).un(1),peth(l).un(2)));
        tm(:,c)=peth(l).fit.mean;
    end
end
yl = max(max(tm))+2;
legend(h,'Location','Northwest'); legend boxoff;  xlabel ('Seconds'); ylabel ('Instantaneous spike num');
ylim([0 yl]);
plot(zeros(yl+1,1),[0:1:yl],'--k');
mo = [type,' onset'];
text(0.1, yl-0.5,mo);
t = ['Spike Timing Across Negatively Modulated-Related Units']; title(t);
t2 = strcat(dir,'Spike Timing Negative TR',type,'reachtrials');
saveas(gcf,t2,'tiff');
close all;
%pause;
savefile = [dir,'peth2_reachtrialsonly_centeredto',type,'.mat'];
save (savefile, 'peth', 'trp', 'trn');
close all; clc;
end
