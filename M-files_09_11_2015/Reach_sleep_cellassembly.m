function [Activities_pre, Activities_post]=Reach_sleep_cellassembly(TimeStamps1,TimeStamps2, time_pre,time_post,Fs_lfp, bin,units,Patterns,dir,template)
count=0;
for a = 1: length(units)
    for i = 1:length(units(a).un)
        count = count+1;
        clear dn_pre ts* trl_datatmp
        unit=units(a).un(i);
        sc = a+1;  
        ts1=TimeStamps1{unit,sc}*Fs_lfp;
        ts2=TimeStamps2{unit,sc}*Fs_lfp;
        dN_pre = [];
        dN_post=[];
        tmplen=0;
        ts1atmp2=[];
        ts1atmp=[];
        ts1a=[];
        ts2a=[];
        ts2atmp2=[];
        ts2atmp=[];
    for j = 1:size(time_pre,1)
        ts1atmp = ts1(ts1>time_pre(j,1) & ts1<time_pre(j,2));
        bin1 = [time_pre(j,1):bin:time_pre(j,2)];
        ts_bin = histc(ts1atmp,bin1);            
        dN_pre = [dN_pre ts_bin];
    end
    
    for j = 1:size(time_post,1)
        ts2atmp = ts2(ts2>time_post(j,1) & ts2<time_post(j,2));
        bin2=[time_post(j,1):bin:time_post(j,2)];
        ts_bin2 = histc(ts2atmp,bin2);
        dN_post = [dN_post ts_bin2];
    end
    Spre(count,:) = dN_pre;
    if ~isempty(dN_post)    
    Spost(count,:) = dN_post;
    else
    Spost(count,:) = zeros(1,length(Spost));
    end
    
    end
end

    if size(Spre,2)>size(Spost,2)
        Spre=Spre(:,1:size(Spost,2));
    else
        Spost=Spost(:,1:size(Spre,2));
    end
    Activities_pre = assembly_activity(Patterns,Spre);
    Activities_post = assembly_activity(Patterns,Spost);
    ymx = max([Activities_pre Activities_post]');
    ymn = min([Activities_pre Activities_post]');
%     
%     ymx = 500;
%     ymn = -100;
    
    for i = 1:(size(Patterns,2))
    figure; clf;
    subplot(221)
    plot(Activities_pre(i,:))
    ylim([ymn(i) ymx(i)])
    title('Ensemble Strength Pre-Learning Sleep Block');

    subplot(222)
    plot(Activities_post(i,:))
    ylim([ymn(i) ymx(i)])
    title('Ensemble Strength Post-Learning Sleep Block');
    
    subplot(223)

    Mn(i,1) = mean(Activities_pre(i,:));
    Mn(i,2)= mean(Activities_post(i,:));
    Err(i,1) = std(Activities_pre(i,:))/sqrt(length(Activities_pre(i,:)));
    Err(i,2) = std(Activities_post(i,:))/sqrt(length(Activities_pre(i,:)));
    [~,p]=ttest2(Activities_pre(i,:),Activities_post(i,:));
   
    errorbar(Mn(i,:),Err(i,:));
    title('Mean Change in Activation Strength');
    pval = strcat('p = ',num2str(p,2));
    text(1.5,Mn(i,2)+0.005,pval);
    
    [h,p,k] = kstest2(Activities_pre(i,:),Activities_post(i,:),.05,'smaller')
    [h2,p2,k2] = kstest2(Activities_pre(i,:),Activities_post(i,:),.05,'larger')


    subplot(224)
    F1 = cdfplot(Activities_pre(i,:));xlim([10 100]);ylim([0.995 1]);
    hold on
    F2 = cdfplot(Activities_post(i,:));xlim([10 100]); ylim([0.995 1]);
    set(F1,'LineWidth',3,'Color','r')
    set(F2,'LineWidth',3)
    legend([F1 F2],'Pre','Post','Location','SE')
    
%     barp(:,1)=hist(Activities_pre(i,:),[-50:1:100])/length(Activities_pre(i,:));
%     barp(:,2)=hist(Activities_post(i,:),[-50:1:100])/length(Activities_post(i,:));
%     bh = bar([-50:100],barp); ylim([0 0.001]); xlim([-50 100]); label(p);
%     ch = get(bh,'child');
%     ch{1}=50;
%     ch{2}=50;
%     
    cd(dir);
    filesav = strcat('Pre-Post Activation Bin',num2str(bin),'Ensemble',num2str(i),'template',template);
    saveas(gcf,filesav,'tiff');
    %pause;
    close all;
    end   
    
    
