function plot_raster_peth_trial_by_trial (units,trial_start,trial_marker,TimeStamps,len_bef,len_aft,bin,dir,type)

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
totnumunits = 0;

for a = 1:length(units)
totnumunits =length(units(a).un)+totnumunits;
end

ts_nobin_allunits = zeros(totnumunits,length(trial_marker),len_bef+len_aft);
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
                tstmp = ts(ts>t(1) & ts<t(2));
                bin1 = [t(1):bin/Fs_lfp:t(2)];
                ts_bin(j,:) =  histc(tstmp,bin1);
                ts_nobin(j,:) = histc(tstmp,[t(1):(1/Fs_lfp):t(2)-(1/Fs_lfp)]);
                ts_nobin_allunits(count,j,:)=histc(tstmp,[t(1):(1/Fs_lfp):t(2)-(1/Fs_lfp)]);
            else
                ts_bin(j,:) = NaN;
                ts_nobin(j,:)=NaN;
                ts_nobin_allunits(count,j,:)=NaN;
            end
        end   
        nn = ~isnan(ts_bin(:,1));
        peth(count).un = [units_sc(i),sc];
        peth(count).bin = nansum(ts_bin);
        peth(count).binearly = nansum(ts_bin(1:30,:));
        peth(count).binlate = nansum(ts_bin(end-29:end,:));
             end
end

%ts_nobin_allunits= ts_nobin_allunits(Sortind,:,:); 
tnan = isnan(ts_nobin_allunits(1,:,1));
ts_nobin_allunits(:,tnan,:)=[];
ts_nobin_allunits2=ts_nobin_allunits;
ts_nobin_meanerl = squeeze(mean(ts_nobin_allunits(:,11:40,:),2));
ts_nobin_meanlate= squeeze(mean(ts_nobin_allunits(:,end-29:end,:),2));
ts_nobin_meanall=squeeze(mean(ts_nobin_allunits,2));

for i = 1:size(ts_nobin_meanerl,1)
    count=0;
    for j = 1:25:size(ts_nobin_meanerl,2)-25
    count=count+1;    
    ts_bin_meanerl(i,count)=sum(ts_nobin_meanerl(i,j:j+25));
    end
end

for i = 1:size(ts_nobin_meanlate,1)
    count=0;
    for j = 1:25:size(ts_nobin_meanerl,2)-25
        count=count+1;    
        ts_bin_meanlate(i,count)=sum(ts_nobin_meanlate(i,j:j+25));
    end
end

for i = 1:size(ts_nobin_meanall,1)
    count=0;
    for j = 1:25:size(ts_nobin_meanerl,2)-25
        count=count+1;    
        ts_bin_meanall(i,count)= sum(ts_nobin_meanall(i,j:j+25));
    end
end

for i = 1:size(ts_bin_meanall,1)
    [~,a]=sort(ts_bin_meanall(i,:),'descend');
    ts_mx(i)=a(1);
end
[~,sall] = sort(ts_mx);

for i = 1:size(ts_bin_meanerl,1)
    [~,a]=sort(ts_bin_meanall(i,:),'descend');
    ts_mx(i)=a(1);
end

[~,serl] = sort(ts_mx);

for i = 1:size(ts_bin_meanerl,1)
    [~,a]=sort(ts_bin_meanlate(i,:),'descend');
    ts_mx(i)=a(1);
end
[~,slate] = sort(ts_mx);

ts_bin_meanall = ts_bin_meanall(sall,:);
ts_bin_meanerl = ts_bin_meanerl(serl,:);
ts_bin_meanlate = ts_bin_meanlate(slate,:);
ts_nobin_allunitserl=ts_nobin_allunits2(serl,1:30,:);
ts_nobin_allunitslate=ts_nobin_allunits2(slate,end-29:end,:);


figure('units','normalized','outerposition',[0 0 1 1],'Color', [1 1 1]);
subplot(311)
imagesc(zscore(ts_bin_meanerl')',[-1 6]); axis xy; colorbar; title('Early Trials');
subplot(312);
imagesc(zscore(ts_bin_meanlate')',[-1 6]); axis xy; colorbar; title('Late Trials');
subplot(313);
imagesc(zscore(ts_bin_meanall')',[-1 6]); axis xy; colorbar; title('All Trials');


% figure;
% cmap = colormap;
% x=0;
% for j = 1:size(ts_nobin_allunitserl,2)
%     if x<500
%         for k = 1:size(ts_nobin_allunitserl,1)
%             subplot(211);
%             plot([-500:1:1000],squeeze(ts_nobin_allunitserl(k,j,500:2000))*k,'.','Color',cmap(k,:)); hold on; title ('Early Trials');
%             subplot(212);
%             plot([-500:1:1000],squeeze(ts_nobin_allunitslate(k,j,500:2000))*k,'.','Color',cmap(k,:)); hold on; title ('Late Trials');
%         end
%         [x,y]=ginput(1);
%         close all;
%     end
% end
% 
% pause;
%close all;
end

