function [tmp1 tmp2]=make_PCA_traj_sleep(ActivitiesB1,ActivitiesB2)
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
  range1 = 1:60%1:size(tmp1,3);
  range2 =1:60%1:size(tmp2,3)
  if length(range1)>length(range2)
      range1=range2;
  else 
      range2=range1;
  end
  time =10:30;
  plot(time,squeeze(mean(tmp1(1,time,range1),3)),'m'); hold on;
%  %plot(time,squeeze(mean(tmp1(1,time,range2),3)),'r'); hold on;
  plot(time,squeeze(mean(tmp2(1,time,range2),3)),'g'); hold on;
  figure; 
  for i = 1:length(range1)
    plot3(squeeze(tmp1(1,time,range1(i))),squeeze(tmp1(2,time,range1(i))),squeeze(tmp1(3,time,range1(i))),'m'); hold on; set(gca,'Color',[0 0 0 ]); view([0 90]);
    plot3(squeeze(tmp1(1,1,range1(i))),squeeze(tmp1(2,1,range1(i))),squeeze(tmp1(3,1,range1(i))),'mo','MarkerSize',5,'LineWidth',2.5); hold on;
    plot3(squeeze(tmp2(1,time,range2(i))),squeeze(tmp2(2,time,range2(i))),squeeze(tmp2(3,time,range2(i))),'g'); hold on; view([-4 64]);
    plot3(squeeze(tmp2(1,1,range2(i))),squeeze(tmp2(2,1,range2(i))),squeeze(tmp2(3,1,range2(i))),'go','MarkerSize',5,'LineWidth',2.5); hold on;
  end
 view([0 90]);
 view([90 0]); 
  figure;
 for i = 1:length(range1)
    plot(squeeze(tmp1(1,time,range1(i))),squeeze(tmp1(2,time,range1(i))),'m'); hold on;set(gca,'Color',[0 0 0 ])
    plot(squeeze(tmp1(1,1,range1(i))),squeeze(tmp1(2,1,range1(i))),'mo','MarkerSize',5,'LineWidth',2.5); hold on;
    plot(squeeze(tmp2(1,time,range2(i))),squeeze(tmp2(2,time,range2(i))),'g'); hold on;
    plot(squeeze(tmp2(1,1,range2(i))),squeeze(tmp2(2,1,range2(i))),'go','MarkerSize',5,'LineWidth',2.5); hold on;
 end
 
figure;
for i = 1:length(range1)
    subplot(311);
    plot(squeeze(tmp1(1,time,range1(i))),squeeze(tmp1(2,time,range1(i))),'m'); hold on;set(gca,'Color',[0 0 0 ])
    plot(squeeze(tmp1(1,1,range1(i))),squeeze(tmp1(2,1,range1(i))),'mo','MarkerSize',5,'LineWidth',2.5); hold on;
     plot(squeeze(tmp2(1,time,range2(i))),squeeze(tmp2(2,time,range2(i))),'g'); hold on;
     plot(squeeze(tmp2(1,1,range2(i))),squeeze(tmp2(2,1,range2(i))),'go','MarkerSize',5,'LineWidth',2.5); hold on;
    subplot(312)
    plot(squeeze(tmp1(1,time,range1(i))),squeeze(tmp1(3,time,range1(i))),'m'); hold on;set(gca,'Color',[0 0 0 ])
    plot(squeeze(tmp1(1,1,range1(i))),squeeze(tmp1(3,1,range1(i))),'mo','MarkerSize',5,'LineWidth',2.5); hold on;
     plot(squeeze(tmp2(1,time,range2(i))),squeeze(tmp2(3,time,range2(i))),'g'); hold on;
     plot(squeeze(tmp2(1,1,range2(i))),squeeze(tmp2(3,1,range2(i))),'go','MarkerSize',5,'LineWidth',2.5); hold on;
%    pause;
    subplot(313)
    plot(squeeze(tmp1(2,time,range1(i))),squeeze(tmp1(3,time,range1(i))),'m'); hold on;set(gca,'Color',[0 0 0 ])
    plot(squeeze(tmp1(2,1,range1(i))),squeeze(tmp1(3,1,range1(i))),'mo','MarkerSize',5,'LineWidth',2.5); hold on;
     plot(squeeze(tmp2(2,time,range2(i))),squeeze(tmp2(3,time,range2(i))),'g'); hold on;
     plot(squeeze(tmp2(2,1,range2(i))),squeeze(tmp2(3,1,range2(i))),'go','MarkerSize',5,'LineWidth',2.5); hold on;

end
  
 m1 = mean(tmp1(:,:,range1),3);
 m2 = mean(tmp2(:,:,range2),3);
 
 s1 = std(tmp1(:,:,range1),0,3)/sqrt(length(range1));
 s2 = std(tmp2(:,:,range2),0,3)/sqrt(length(range2));
 
 stp1 = m1+s1;
 stp2 = m2+s2;
 
 stn1 = m1-s1;
 stn2 = m2-s2;
 
 figure;
 plot3(m1(1,time),m1(2,time),m1(3,time),'m'); hold on;set(gca,'Color',[0 0 0 ])
 plot3(m2(1,time),m2(2,time),m2(3,time),'g');
 
 figure;
 plot3(stp1(1,time),stp1(2,time),stp1(3,time),'m','LineWidth',5);hold on; set(gca,'Color',[0 0 0 ])
 plot3(stn1(1,time),stn1(2,time),stn1(3,time),'m','LineWidth',5);
 plot3(stp2(1,time),stp2(2,time),stp2(3,time),'g','LineWidth',5);
 plot3(stn2(1,time),stn2(2,time),stn2(3,time),'g','LineWidth',5);
 view([90 0]);
 view([0 34]);
 
 figure;
 for i = 1:7
 shadedErrorBar(time,m1(i,time),s1(i,time),'m',1); hold on;
 shadedErrorBar(time,m2(i,time),s2(i,time),'g',1);
 pause;
 close all;
 end
 
 subplot(311);
 shadedErrorBar(time,m1(1,time),s1(1,time),'m',1); hold on;
 shadedErrorBar(time,m2(1,time),s2(1,time),'g',1);

 subplot(312);
 shadedErrorBar(time,m1(2,time),s1(2,time),'m',1); hold on;
 shadedErrorBar(time,m2(2,time),s2(2,time),'g',1);

 subplot(313);
 shadedErrorBar(time,m1(3,time),s1(3,time),'m',1); hold on;
 shadedErrorBar(time,m2(3,time),s2(3,time),'g',1);

 for i = 1:size(ActivitiesB1,1) 
     CV1(i,:) = abs(squeeze(std(squeeze(ActivitiesB1(i,time,range1)),0,2))./squeeze(mean(squeeze(ActivitiesB1(i,time,range1)),2)))
     CV2(i,:) = abs(squeeze(std(squeeze(ActivitiesB2(i,time,range2)),0,2))./squeeze(mean(squeeze(ActivitiesB1(i,time,range2)),2)))
 end

 CV1m = mean(CV1,1);
 CV2m = mean(CV2,1);

 for i = 1:4 
 plot(CV1(i,:),'b'); hold on;
 plot(CV2(i,:),'r');
 pause; 
 end
 
  %subplot(313); imagesc(CV3, [0 1000]); colorbar;
 