function [tmp1 tmp2]=make_PCA_traj (ActivitiesB1,ActivitiesB2)
        for i = 1:size(ActivitiesB1,1)
            for j = 1:size(ActivitiesB1,2)
            tmp1(i,j,:) = smooth(squeeze(ActivitiesB1(i,j,:)),20);
            end
        end
        for i = 1:size(ActivitiesB2,1)
            for j = 1:size(ActivitiesB2,2)
            tmp2(i,j,:) = smooth(squeeze(ActivitiesB2(i,j,:)),20);
            end
        end
        for i = 1:size(tmp1,1)
            for j = 1:size(tmp1,3)
                tmp1(i,:,j)=smooth(squeeze(tmp1(i,:,j)),1);
            end
        end
        for i = 1:size(tmp2,1)
            for j = 1:size(tmp2,3)
                tmp2(i,:,j)=smooth(squeeze(tmp2(i,:,j)),1);
            end
        end
  signals = tmp1;
  signals2 = tmp2;
  range1 = 10:20;
  range2 = size(tmp1,3)-10:size(tmp1,3);

% time = 1:size(tmp1,2) %round(size(tmp1,2)/4):round(size(tmp1,2)*3/4);
 time =11:41;
%  plot(time,squeeze(mean(tmp1(1,time,range1),3)),'r'); hold on;
%  plot(time,squeeze(mean(tmp1(1,time,range2),3)),'b'); hold on;
%  plot(time,squeeze(mean(tmp2(1,time,range1),3)),'g'); hold on;
 figure;
  for i = 1:length(range1)
%    subplot(211);
    plot3(squeeze(tmp1(1,time,range1(i))),squeeze(tmp1(2,time,range1(i))),squeeze(tmp1(3,time,range1(i))),'r'); hold on ;set(gca,'Color',[0 0 0 ])
    plot3(squeeze(tmp1(1,1,range1(i))),squeeze(tmp1(2,time(1),range1(i))),squeeze(tmp1(3,time(1),range1(i))),'ro','MarkerSize',5,'LineWidth',2.5); hold on;
    plot3(squeeze(tmp1(1,time,range2(i))),squeeze(tmp1(2,time,range2(i))),squeeze(tmp1(3,time,range2(i))),'b'); hold on;
    plot3(squeeze(tmp1(1,1,range2(i))),squeeze(tmp1(2,time(1),range2(i))),squeeze(tmp1(3,time(1),range2(i))),'bo','MarkerSize',5,'LineWidth',2.5); hold on;
     plot3(squeeze(tmp2(1,time,range1(i))),squeeze(tmp2(2,time,range1(i))),squeeze(tmp2(3,time,range1(i))),'g'); hold on;
    plot3(squeeze(tmp2(1,1,range1(i))),squeeze(tmp2(2,time(1),range1(i))),squeeze(tmp2(3,time(1),range1(i))),'go','MarkerSize',5,'LineWidth',2.5); hold on;

%     subplot(212);
%     plot3(squeeze(tmp1(1,time,range2(i))),squeeze(tmp1(2,time,range2(i))),squeeze(tmp1(3,time,range2(i))),'b'); hold on;;set(gca,'Color',[0 0 0 ])
%     plot3(squeeze(tmp1(1,1,range2(i))),squeeze(tmp1(2,1,range2(i))),squeeze(tmp1(3,1,range2(i))),'bo','MarkerSize',5,'LineWidth',2.5); hold on;
%     plot3(squeeze(tmp2(1,time,range1(i))),squeeze(tmp2(2,time,range1(i))),squeeze(tmp2(3,time,range1(i))),'g'); hold on;
%     plot3(squeeze(tmp2(1,1,range1(i))),squeeze(tmp2(2,1,range1(i))),squeeze(tmp2(3,1,range1(i))),'go','MarkerSize',5,'LineWidth',2.5); hold on;
  end
 
 figure;
 for i = 1:length(range1)
    plot(squeeze(tmp1(1,time,range1(i))),squeeze(tmp1(2,time,range1(i))),'r'); hold on;set(gca,'Color',[0 0 0 ])
    plot(squeeze(tmp1(1,time(1),range1(i))),squeeze(tmp1(2,time(1),range1(i))),'ro','MarkerSize',5,'LineWidth',2.5); hold on;
    plot(squeeze(tmp1(1,time,range2(i))),squeeze(tmp1(2,time,range2(i))),'b'); hold on;
    plot(squeeze(tmp1(1,time(1),range2(i))),squeeze(tmp1(2,time(1),range2(i))),'bo','MarkerSize',5,'LineWidth',2.5); hold on;
    plot(squeeze(tmp2(1,time,range1(i))),squeeze(tmp2(2,time,range1(i))),'g'); hold on;
    plot(squeeze(tmp2(1,time(1),range1(i))),squeeze(tmp2(2,time(1),range1(i))),'go','MarkerSize',5,'LineWidth',2.5); hold on;
 end
 
 figure;
for i = 1:length(range1)
    subplot(211);
    plot(squeeze(tmp1(1,time,range1(i))),squeeze(tmp1(2,time,range1(i))),'r'); hold on;set(gca,'Color',[0 0 0 ])
    plot(squeeze(tmp1(1,1,range1(i))),squeeze(tmp1(2,1,range1(i))),'ro','MarkerSize',5,'LineWidth',2.5); hold on;
    plot(squeeze(tmp1(1,time,range2(i))),squeeze(tmp1(2,time,range2(i))),'b'); hold on;
    plot(squeeze(tmp1(1,1,range2(i))),squeeze(tmp1(2,1,range2(i))),'bo','MarkerSize',5,'LineWidth',2.5); hold on;
     plot(squeeze(tmp2(1,time,range1(i))),squeeze(tmp2(2,time,range1(i))),'g'); hold on;
     plot(squeeze(tmp2(1,1,range1(i))),squeeze(tmp2(2,1,range1(i))),'go','MarkerSize',5,'LineWidth',2.5); hold on;
    subplot(212)
    plot(squeeze(tmp1(2,time,range1(i))),squeeze(tmp1(3,time,range1(i))),'r'); hold on;set(gca,'Color',[0 0 0 ])
    plot(squeeze(tmp1(2,1,range1(i))),squeeze(tmp1(3,1,range1(i))),'ro','MarkerSize',5,'LineWidth',2.5); hold on;
    plot(squeeze(tmp1(2,time,range2(i))),squeeze(tmp1(3,time,range2(i))),'b'); hold on;
    plot(squeeze(tmp1(2,1,range2(i))),squeeze(tmp1(3,1,range2(i))),'bo','MarkerSize',5,'LineWidth',2.5); hold on;
     plot(squeeze(tmp2(2,time,range1(i))),squeeze(tmp2(3,time,range1(i))),'g'); hold on;
     plot(squeeze(tmp2(2,1,range1(i))),squeeze(tmp2(3,1,range1(i))),'go','MarkerSize',5,'LineWidth',2.5); hold on;
%    pause;
end
  
 m1 = mean(tmp1(:,:,range1),3);
 m2 = mean(tmp1(:,:,range2),3);
 m3 = mean(tmp2(:,:,range1),3);
 
 s1 = std(tmp1(:,:,range1),0,3)/sqrt(length(range1));
 s2 = std(tmp1(:,:,range2),0,3)/sqrt(length(range2));
 s3 = std(tmp2(:,:,range1),0,3)/sqrt(length(range1));
 
 stp1 = m1+s1;
 stp2 = m2+s2;
 stp3 = m3+s3;
 
 stn1 = m1-s1;
 stn2 = m2-s2;
 stn3 = m3-s3;

 figure;
 plot3(m1(1,time),m1(2,time),m1(3,time),'r','LineWidth',5); hold on;set(gca,'Color',[0 0 0 ])
 plot3(m2(1,time),m2(2,time),m2(3,time),'b','LineWidth',5);
 plot3(m3(1,time),m3(2,time),m3(3,time),'g','LineWidth',5);

 figure;
 plot3(stp1(1,time),stp1(2,time),stp1(3,time),'r','LineWidth',5);hold on; set(gca,'Color',[0 0 0 ])
 plot3(stn1(1,time),stn1(2,time),stn1(3,time),'r','LineWidth',5);
 plot3(stp2(1,time),stp2(2,time),stp2(3,time),'b','LineWidth',5);
 plot3(stn2(1,time),stn2(2,time),stn2(3,time),'b','LineWidth',5);
 plot3(stp3(1,time),stp3(2,time),stp3(3,time),'g','LineWidth',5);
 plot3(stn3(1,time),stn3(2,time),stn3(3,time),'g','LineWidth',5);
 
 figure;
 time1=[-125:25:625];
 for i = 1:2
 shadedErrorBar(time1,m1(i,time),s1(i,time),'r',1); hold on;
 shadedErrorBar(time1,m2(i,time),s2(i,time),'b',1);
 shadedErrorBar(time1,m3(i,time),s3(i,time),'g',1);
 pause;
 close all;
 end
 
 time1=[0:100:1000];
 subplot(311);
 shadedErrorBar(time1,m1(1,time),s1(1,time),'r',1); hold on;
 shadedErrorBar(time1,m2(1,time),s2(1,time),'b',1);
 shadedErrorBar(time1,m3(1,time),s3(1,time),'g',1);

 subplot(312);
 shadedErrorBar(time1,m1(2,time),s1(2,time),'r',1); hold on;
 shadedErrorBar(time1,m2(2,time),s2(2,time),'b',1);
 shadedErrorBar(time1,m3(2,time),s3(2,time),'g',1);

 subplot(313);
 shadedErrorBar(time1,m1(3,time),s1(3,time),'r',1); hold on;
 shadedErrorBar(time1,m2(3,time),s2(3,time),'b',1);
 shadedErrorBar(time1,m3(3,time),s3(3,time),'g',1);

 subplot(324);
 shadedErrorBar(time1,m1(4,time),s1(4,time),'r',1); hold on;
 shadedErrorBar(time1,m2(4,time),s2(4,time),'b',1);
 shadedErrorBar(time1,m3(4,time),s3(4,time),'g',1);

 subplot(325);
 shadedErrorBar(time1,m1(5,time),s1(5,time),'r',1); hold on;
 shadedErrorBar(time1,m2(5,time),s2(5,time),'b',1);
 shadedErrorBar(time1,m3(5,time),s3(5,time),'g',1);

 subplot(326);
 shadedErrorBar(time1,m1(6,time),s1(6,time),'r',1); hold on;
 shadedErrorBar(time1,m2(6,time),s2(6,time),'b',1);
 shadedErrorBar(time1,m3(6,time),s3(6,time),'g',1);

 
 for i = 1:size(ActivitiesB1,1) 
     CV1(i,:) = abs(squeeze(std(squeeze(ActivitiesB1(i,time,range1)),0,2))./squeeze(mean(squeeze(ActivitiesB1(i,time,range1)),2)))
     CV2(i,:) = abs(squeeze(std(squeeze(ActivitiesB1(i,time,range2)),0,2))./squeeze(mean(squeeze(ActivitiesB1(i,time,range2)),2)))
     CV3(i,:) = abs(squeeze(std(squeeze(ActivitiesB2(i,time,range1)),0,2))./squeeze(mean(squeeze(ActivitiesB2(i,time,range1)),2))) 
 end

 CV1m = mean(CV1,1);
 CV2m = mean(CV2,1);
 CV3m = mean(CV3,1);

 for i = 1:3
 plot(time1,CV1(i,:),'b'); hold on;
 plot(time1, CV2(i,:),'r');
 plot(time1,CV3(i,:),'g');
 pause; 
 close all
 end
 
 subplot(311); imagesc(CV1, [0 200]); colorbar;
 subplot(312); imagesc(CV2, [0 200]); colorbar;
 subplot(313); imagesc(CV3, [0 200]); colorbar;
 