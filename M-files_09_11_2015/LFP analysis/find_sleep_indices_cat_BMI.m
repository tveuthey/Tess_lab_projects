function [sleep_inds]=find_sleep_indices_cat_BMI(data, wave, chan_no,epochs)

close all;
    [i j]=size(data);
    data_lfp=zeros(i,j);
for n=1:epochs
    close
    figure(n);
    if isempty (chan_no)==1
    subplot(2,1,2);plot(median(data(:,:)));
    else
        subplot(2,1,2);plot(data(chan_no,:));
    end
    ylim([-10 10]);
    subplot(2,1,1);plot(wave);
    set(gcf, 'Position', get(0,'Screensize'));
%     pause;
    
    [x,y]=ginput;
%     pause;
%     close all;
    temp_x1(n)=round(x(1));
    temp_x2(n)=round(x(2));
    inds=round(temp_x1(n):temp_x2(n));
    inds2(n,:)=[temp_x1(n) temp_x2(n)];

    data_lfp(:,inds)=data(:,inds);
%     n1=(temp_x1(n)-1);
%     n2=length(data)-(temp_x2(n)+1);
%     data_lfp=cat(2,zeros(m,n1),data(:,inds),zeros(m,n2));
%     if n>=2
%         
%     end
    last=temp_x2(n);
end
close
temp=median(data_lfp);
plot(temp);
x1=find(temp>0,1,'first');
sleep_inds=[inds2];
% data_lfp=data_lfp;
