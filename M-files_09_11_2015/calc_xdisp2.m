function [kinem_early kinem_late kinem_early2 kinem_B1all kinem_B2all] =calc_xdisp2(a,b)

kinem1 = a.kinem;
kinem2 = b.kinem;
%
% count=0;
% for i = 1:75
%     if count<30
%         if ~isnan(max(kinem1(:,1,i)))
%             count=count+1;
%             subplot(211); plot(squeeze(kinem1(:,1,i)),squeeze(kinem1(:,2,i)),'b'); hold on; axis ij;
%             xlim([00 300]); ylim([0 200]);
%             pause;
%
%         end
%     elseif count<60
%         if ~isnan(max(kinem1(:,1,i)))
%             count=count+1;
%             subplot(211); plot(squeeze(kinem1(:,1,i)),squeeze(kinem1(:,2,i)),'r'); hold on; axis ij;
%             xlim([00 300]); ylim([0 200]);
%             pause;
%         end
%     end
% end
%
% count=0;
% for i = 1:75
%     if count<30
%         if ~isnan(max(kinem2(:,1,i)))
%             count=count+1;
%             subplot(212); plot(squeeze(kinem2(:,1,i)),squeeze(kinem2(:,2,i)),'b'); hold on; axis ij;
%             xlim([00 300]); ylim([0 200]);
%             pause;
%
%         end
%     elseif count<60
%         if ~isnan(max(kinem2(:,1,i)))
%             count=count+1;
%             subplot(212); plot(squeeze(kinem2(:,1,i)),squeeze(kinem2(:,2,i)),'r'); hold on; axis ij;
%             xlim([00 300]); ylim([0 200]);
%             pause;
%         end
%     end
% end
%
count = 0;
count2=0;
for i = 1:size(kinem1,3)
    clear tmp3;
    tmp = kinem1(:,:,i);
    for j = 1:2
        tmp2=tmp(:,j);
        tmp2(isnan(tmp2))=[];
        tmp3(:,j)=tmp2;
    end
    tmp=tmp3;
    if ~isempty(tmp)
        if length(tmp)>30
            count=count+1;
            count2=count2+1;
            if count<=30
                kinem_early(:,:,count)=tmp(1:30,:)
            else
                kinem_late(:,:,count-30)=tmp(1:30,:);
            end            
            kinem_B1all(:,:,count2)=tmp(1:30,:);
        elseif length(tmp)>20
            count2=count2+1;
            kinem_B1all(:,:,count2)=repmat(NaN,[30 2]);
            kinem_B1all(1:length(tmp),:,count2)=tmp(:,:);            
        end
    end
end

count = 0;
count2=0;
for i = 1:size(kinem2,3)
    tmp = kinem2(:,:,i);
    clear tmp3;
    for j = 1:2
        tmp2=tmp(:,j);
        tmp2(isnan(tmp2))=[];
        tmp3(:,j)=tmp2;
    end
    tmp=tmp3;
    if ~isempty(tmp)
        if length(tmp)>30
            count=count+1;
            count2=count2+1; 
            if count<=40
                kinem_early2(:,:,count)=tmp(1:30,:);
            else
                kinem_late2(:,:,count-40)=tmp(1:30,:);
            end
            kinem_B2all(:,:,count2)=tmp(1:30,:);
        elseif length(tmp)>20
            count2=count2+1;
            kinem_B2all(:,:,count2)=repmat(NaN,[30 2]);
            kinem_B2all(1:length(tmp),:,count2)=tmp;
        end
    end
end
% subplot(311); plot(squeeze(mean(kinem_early,3)));
% subplot(312); plot(squeeze(mean(kinem_late,3)));
% subplot(313); plot(squeeze(mean(kinem_early2,3)));

earlymx = squeeze(mean(kinem_early(:,1,:),3));
latemx = squeeze(mean(kinem_late(:,1,:),3));
early_psmx = squeeze(mean(kinem_early2(:,1,11:end),3));

earlysdx = squeeze(std(kinem_early(:,1,:),0,3))/sqrt(size(kinem_early,3));
latesdx = squeeze(std(kinem_late(:,1,:),0,3))/sqrt(size(kinem_late,3));
early_pssdx = squeeze(std(kinem_early2(:,1,11:end),0,3))/sqrt(size(kinem_early2,3));

earlymy = squeeze(mean(kinem_early(:,1,:),3));
latemy = squeeze(mean(kinem_late(:,1,:),3));
early_psmy = squeeze(mean(kinem_early2(:,1,11:end),3));

earlysdy = squeeze(std(kinem_early(:,2,:),0,3))/sqrt(size(kinem_early,3));
latesdy = squeeze(std(kinem_late(:,2,:),0,3))/sqrt(size(kinem_late,3));
early_pssdy = squeeze(std(kinem_early2(:,2,11:end),0,3))/sqrt(size(kinem_early2,3));

figure;
subplot(211);
shadedErrorbar(1:30,earlymx,earlysdx,'b',0); hold on;
shadedErrorbar(1:30,latemx,latesdx,'r',0); hold on;
shadedErrorbar(1:30,early_psmx,early_pssdx,'g',0); hold on; axis ij;

subplot(212);
shadedErrorbar(1:30,earlymy,earlysdy,'b',0); hold on;
shadedErrorbar(1:30,latemy,latesdy,'r',0); hold on;
shadedErrorbar(1:30,early_psmy,early_pssdy,'g',0); hold on; axis ij;

% pause;
%
%     subplot(211); plot(squeeze(mean(kinem_early(:,1,:),3)),'b'); hold on;
%     plot(squeeze(mean(kinem_late(:,1,:),3)),'r'); hold on;
%     plot(squeeze(mean(kinem_early2(:,1,11:end),3)),'g'); hold on;
%
%     subplot(212); plot(squeeze(mean(kinem_early(:,2,:),3)),'b'); hold on;
%     plot(squeeze(mean(kinem_late(:,2,:),3)),'r'); hold on;
%     plot(squeeze(mean(kinem_early2(:,2,11:end),3)),'g'); hold on;
%     pause;
%
% figure;
%     subplot(211); plot(squeeze(std(kinem_early(:,1,:),0,3))/squeeze((mean(kinem_early(:,1,:),3))),'b'); hold on;
%     plot(squeeze(std(kinem_late(:,1,:),0,3))/squeeze((mean(kinem_late(:,1,:),3))),'r');
%     plot(squeeze(std(kinem_early2(:,1,:),0,3))/squeeze((mean(kinem_early2(:,1,:),3))),'g');
%
%     subplot(212); plot(squeeze(std(kinem_early(:,2,:),0,3)),'b'); hold on;
%     plot(squeeze(std(kinem_late(:,2,:),0,3)),'r'); hold on;
%     plot(squeeze(std(kinem_early2(:,2,11:end),0,3)),'g'); hold on;
%     pause;
%
% % for i = 1:size(kinem1,3)
% %     xmax(i) = min(kinem1(:,1,i));
% % end
% % xmax(isnan(xmax))=[];
% %  plot(smooth(xmax,10),'b'); axis ij;
% %  hold on;
% %
% % for i = 1:size(kinem2,3)
% %     xmax2(i) = min(kinem2(:,1,i));
% % end
% % xmax2(isnan(xmax2))=[];
% % xmax2s=smooth(xmax2,10);
% %
% % plot(110:length(xmax2)+109-5,xmax2s(6:end),'r'); axis ij;
% %
% % m(1)=mean(xmax(6:35));
% % m(2)=mean(xmax(end-29:end));
% % m(3)=mean(xmax2(6:35));
% %
% % s(1)=std(xmax(6:35));
% % s(2)=std(xmax(end-29:end));
% % s(3)=std(xmax2(6:35));
% %
% % s=s/sqrt(30);
% % [t(1),p(1)] = ttest2(xmax(6:35), xmax(end-29:end));
% % [t(2),p(2)] = ttest2(xmax2(6:35), xmax(end-29:end));
