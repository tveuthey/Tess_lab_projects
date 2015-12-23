clear
% load('C:\Users\KG\Desktop\BMI 1d\data_block_S32_Cat337-340.mat')
 load('C:\Users\Ganguly Lab\Desktop\S34_learning\data_block_S34_253')


%% find sws epochs
close all
% PARAMETERS
f_lo_env=0.05; %low pass of the rectified data
thresh_val=1.5;
min_sws_len=150;



figure(1);
% set(gcf,'Position',[177  899  2303  420]);
temp3=(data(10,:));

temp_ind=find(temp3>2*std(temp3));
temp3(temp_ind)=0;

% filter to the SWS range
srate = Fs_lfp;
nyq_sample=srate/2;
f_lo=0.1;
f_hi=4;
[b,a]=butter(2,[f_lo/nyq_sample f_hi/nyq_sample]);
y=filtfilt(b,a,temp3);
plot(y,'Linewidth',2)
hold on
%thresholds the data to SWS --> not used for detection; only plot
thresh=std(y)*3;
plot(xlim,[thresh thresh],'k-');


figure
% set(gcf,'Position',[177  899  2303  420]);

sws_2=abs(y).^2; % rectify the sws

%sws_3=smooth(sws_2,500);
[b,a]=butter(2,[f_lo_env/ nyq_sample],'low');
sws_4=filtfilt(b,a,sws_2);
sws_4=decimate(sws_4,100);
thresh=std(sws_4)*thresh_val;

plot(sws_4);
hold on;
plot(xlim,[thresh thresh],'k-');

sws_e=find(sws_4>thresh);
sws_5=zeros(size(sws_4));
sws_5(sws_e)=1;
plot(sws_5*1000);


temp=diff(sws_5);
temp1=find(temp==1);
temp2=find(temp==-1);

%finds the block length using diff
temp3=temp2-temp1(1:length(temp2));
temp4=find(temp3 > min_sws_len); %only gets min block length
plot(temp1(temp4),1000,'r*');

figure(1);
%plot(temp1(temp4)*100,400,'r*');
hold on
%plot(temp2(temp4)*100,400,'g*');
for n=1:length(temp4)
    i1=temp1(temp4(n))*100;
    i2=temp2(temp4(n))*100;
    line([i1 i2],[400 400],'Color','r','LineWidth',3)
end

