figure;
l1=1;
l2=10;
reso=25;
for i=0:10
%     close

subplot(1,2,1)
plot(hold_s1d_pre10(([1:reso]+(reso*i)),:)')
hold on;
% plot(mean(hold_s1d_pre10'),'LineWidth',5)
plot(mean(hold_s1d_pre10(([1:reso]+(reso*i)),:)),'r','LineWidth',3);
hold on;plot(mean(hold_s1d_post10(([1:reso]+(reso*i)),:)),'g','LineWidth',3)
hold off
YLim([-800 200])
subplot(1,2,2)
plot(hold_s1d_post10(([1:reso]+(reso*i)),:)')
hold on;plot(mean(hold_s1d_post10(([1:reso]+(reso*i)),:)),'g','LineWidth',3)
hold on;plot(mean(hold_s1d_pre10(([1:reso]+(reso*i)),:)),'r','LineWidth',3);
hold off
YLim([-800 200])
pause

end
%%
close all
figure;
l1=1;
l2=10;
reso=74;
unit=10
hold_s1d_pre10=abs(hold_s1d_pre10);
hold_s1d_post10=abs(hold_s1d_post10);
for i=0:10
%     close

subplot(1,2,1)
plot(hold_s1d_pre10(([1:reso]+(reso*i)),:)')
hold on;
% plot(mean(hold_s1d_pre10'),'LineWidth',5)
plot(mean(hold_s1d_pre10(([1:reso]+(reso*i)),:)),'r','LineWidth',3);
hold on;plot(mean(hold_s1d_post10(([1:reso]+(reso*i)),:)),'g','LineWidth',3)
hold off
% YLim([-800 200])
subplot(1,2,2)
plot(hold_s1d_post10(([1:reso]+(reso*i)),:)')
hold on;plot(mean(hold_s1d_post10(([1:reso]+(reso*i)),:)),'g','LineWidth',3)
hold on;plot(mean(hold_s1d_pre10(([1:reso]+(reso*i)),:)),'r','LineWidth',3);
hold off

% YLim([-800 200])
pause
 
filename=['C:\Users\Ganguly Lab\Documents\MATLAB\Tanuj\Mat_files\Result_figs\BMI\S32\4_17_13 Late\Indiv RippleCh' num2str(unit) '.tiff'];
                    saveas(gcf,filename);
              
                    
                    
               

end