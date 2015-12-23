function [m,s,p] = calc_reachtime(a,b)

rt1 = (a.grasp-a.reach)*1000/30;
rt2 = (b.grasp-b.reach)*1000/30;
rt1(isnan(rt1))=[];
rt2(isnan(rt2))=[];

m(1)=mean(rt1(6:35));
m(2)=mean(rt1(end-29:end));
m(3)=mean(rt2(6:35));

s(1)=std(rt1(6:35));
s(2)=std(rt1(end-29:end));
s(3)=std(rt2(6:35));

s=s/sqrt(30);
[t(1),p(1)] = ttest2(rt1(6:35), rt1(end-29:end));
[t(2),p(2)] = ttest2(rt2(6:35), rt1(end-29:end));
