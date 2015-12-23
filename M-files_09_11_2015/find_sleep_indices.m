function [sleep_inds]=find_sleep_indices(data, chan_no,epochs)
    [i j]=size(data);
    data_lfp=zeros(i,j);
   meddata = median(data(:,:));
    figure(1);
    if isempty (chan_no)==1
    plot(meddata); axis ([0 length(data) -10000 10000]);
    else
        plot(data(chan_no,:));axis ([0 length(data) -5000 5000]);
        
    end
%     subplot(2,1,1);plot(wave); 
    set(gcf, 'Position', get(0,'Screensize'));
    epochs=input('Please enter number of epochs to use: ');
hold on;

for n=1:epochs
    %close
    [x,y]=ginput(2);
   plot(x(1),0,'k*');
   plot(x(2),0,'r*');
   
%     pause;
   % close all;
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
