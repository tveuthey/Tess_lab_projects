function [x1]=make_sleep_epochs(data)

tmpdata=zeros(size(data,1),length(data));
for i = 1:size(data,1)
    tmpdata(i,:) = data(i,:)- mean(data(i,:));
end

%tmpdata2=median(tmpdata);
elec1 = tmpdata(size(data,1)/2,:);
elec2 = tmpdata(size(data,1)/4,:);
clear tmpdata data;

count=0;
count2 =0;
dur=20000;
% subplot(212); plot(tmpdata2);ylim([-1000 2000]);
% title('Jump to first sleep epoch');
% [xall,~]=ginput(1);

% if ~isempty(xall)
%     i=xall-dur/2; hold on; plot(i,-1000,'*k'); title ('Jumped'); hold off;
% else 
i = 1;
% end

%counter = 0;
subplot(212); plot(elec2); ylim([-1000 1000]);
while i < length(elec1)-dur;
%        counter = counter+1;
        subplot(211);
        cla;
        hold on;
        plot(i:i+dur,elec1(i:i+dur)); ylim([-1000 2000]);
        plot(i:i+dur,elec2(i:i+dur)+1000); ylim([-1000 2000]);
        hold off;
        [x,y]=ginput(1);
        if ~isempty(x)
            count=count+1;
            if isodd(count)
                count2=count2+1;
                x1(count2,1)=x;
                title('Marking sleep');
%                 subplot(212);
%                 hold on;
%                 plot(i,[-1000:2000],'r','LineWidth',4);
%                 hold off;
            else
                x1(count2,2)=x;
                title('Not marking');
                hold off;
                
%                 subplot(212)
%                 hold on;
%                 plot(i,[-1000:2000],'k','LineWidth',4);
%                 title('Jump to sleep');
%                 [xall,~]=ginput(1);
%                 hold off;
%                 if ~isempty(xall)
%                     i=xall-dur/2; hold on; plot(i,-1000,'*k'); title ('Jumped'); hold off;
%                 end
            end
            pause;
        end
    i=i+dur/2;        
end
%     saveas(gcf,'sleep_data','tiff');
    close all;