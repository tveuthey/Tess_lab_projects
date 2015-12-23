function [sswhubpos sswhubneg ssphubpos ssphubneg] = lfp_graph(SW,Spindle)
thresh = [0.05,0.1,0.15,0.2,0.25,0.3];
if length(SW)==64    
j= [0.1 -0.1 0.2 -0.2 0.2 -0.2 0.1 -0.1];    
xy(:,1)=[ones(1,8)+j,ones(1,8)*2+j,ones(1,8)*3+j,ones(1,8)*4+j, ones(1,8)*5+j, ones(1,8)*6+j, ones(1,8)*7+j, ones(1,8)*8+j];     
xy(:,2)=[(1:8)+j,(1:8)+j, (1:8)+j,(1:8)+j,(1:8)+j,(1:8)+j,(1:8)+j,(1:8)+j];
else
j= [0.1 -0.1 0.2 -0.2 0.2 -0.2 0.1 -0.1];    
xy(:,1)=[ones(1,8)+j,ones(1,8)*2+j,ones(1,8)*3+j,ones(1,8)*4+j];     
xy(:,2)=[1:8, 1:8, 1:8, 1:8];
end

for i = 1:length(thresh) 
close all;
th = thresh(i);

SWneg = SW<=-th;
SWpos = SW>=th;

Spindleneg = Spindle<=-th;
Spindlepos = Spindle>=th;

dneg=sum(SWneg);
mneg=mean(dneg);
sneg=std(dneg);
swhubneg=find(dneg>(mneg+2*sneg));
sswhubneg{i}=swhubneg;

dpos =sum(SWpos);
mpos=mean(dpos);
spos=std(dpos);
swhubpos=find(dpos>(mpos+2*spos));
sswhubpos{i}=swhubpos;
tn=[];tp=[];

for j = 1:length(swhubneg)
    t=num2str(swhubneg(j));
    tn = [tn ' ' t];
end

for j = 1:length(swhubpos)
    t=num2str(swhubpos(j));
    tp = [tp ' ' t];
end

tn=strcat('SWS Negative Hubs = ',tn);
tp=strcat('SWS Positive Hubs = ',tp);

% figure;
% subplot(211); gplot(SWneg,xy,'r*-'); title(tn); 
% axis([0.8 4.2 0.8 8.2]);
% subplot(212); gplot(SWpos,xy,'r*-');title(tp); 
% axis([0.8 4.2 0.8 8.2]);

t=strcat('Slow Wave - Graph Threshold ',num2str(th));
figure;

subplot(211); gplot(SWpos,xy,'b*-');title(t); axis([0.3 4.7 0.8 8.2]);
legend(tp);
subplot(212); gplot(SWneg,xy,'r*-'); axis([0.3 4.7 0.8 8.2]);
legend(tn);
f = strcat(t,'.tiff');
saveas (gcf,f);
%pause;
%%%%%%%%%%%%%%%%%%%%%%%%%%Spindle Hub Analysis
close all;
dneg=sum(Spindleneg);
mneg=mean(dneg);
sneg=std(dneg);
sphubneg=find(dneg>(mneg+2*sneg));

dpos =sum(Spindlepos);
mpos=mean(dpos);
spos=std(dpos);
sphubpos=find(dpos>(mpos+2*spos));
tn=[];tp=[];

ssphubneg{i}=sphubneg;
ssphubpos{i}=sphubpos;

for j = 1:length(sphubneg)
    t=num2str(sphubneg(j));
    tn = [tn ' ' t];
end

for j = 1:length(sphubpos)
    t=num2str(sphubpos(j));
    tp = [tp ' ' t];
end
t=strcat('Spindle Graph - Threshold ',num2str(th));

tn=strcat('Spindle Negative Hubs = ',tn);
tp=strcat('Spindle Positive Hubs = ',tp);

figure;
subplot(211); gplot(Spindlepos,xy,'b*-');title(t);
axis([0.4 4.7 0.8 8.2]);
legend(tp);

subplot(212); gplot(Spindleneg,xy,'r*-');
axis([0.4 4.7 0.8 8.2]);
legend(tn);

f = strcat(t,'.tiff');
saveas (gcf,f);
%pause;
end

