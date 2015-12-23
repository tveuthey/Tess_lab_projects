function [m,s,p] = calc_ydisp (a,b)

kinem1 = a.kinem;
kinem2 = b.kinem;

for i = 1:size(kinem1,3)
    xmax(i) = min(kinem1(:,2,i));
end
xmax(isnan(xmax))=[];
 plot(smooth(xmax,10),'b'); axis ij;
 hold on;
 
for i = 1:size(kinem2,3)
    xmax2(i) = min(kinem2(:,2,i));
end
xmax2(isnan(xmax2))=[];
xmax2s=smooth(xmax2,10);

plot(110:length(xmax2)+109-5,xmax2s(6:end),'r'); axis ij;
 
m(1)=mean(xmax(6:35));
m(2)=mean(xmax(end-29:end));
m(3)=mean(xmax2(6:35));

s(1)=std(xmax(6:35));
s(2)=std(xmax(end-29:end));
s(3)=std(xmax2(6:35));

s=s/sqrt(30);
[t(1),p(1)] = ttest2(xmax(6:35), xmax(end-29:end));
[t(2),p(2)] = ttest2(xmax2(6:35), xmax(end-29:end));
