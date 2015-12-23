

temp=data(1,:);

%%
FILTER_ORDER=4;
% s_inds=round(x(1):x(2));
s_inds=round(1:end);
srate = Fs_lfp;
nyq_sample=srate/2;
f_lo=4;
f_hi=500;
[b,a]=butter(FILTER_ORDER,[f_lo/ nyq_sample f_hi/nyq_sample]);
for n=1:32
    data_lfp(n,s_inds)=(data(n,s_inds)-mean(data(n,:)))/(2*std(data(n,s_inds)));
    data_lfpfilt(n,s_inds)=filter(b,a,data_lfp(n,s_inds));
    disp(n)
end


%%
ind_thresh=50;
temp2=mean(data_lfp);
temp2=temp2-mean(temp2);
ind1=find(temp2>(4*(std(temp2))));
ind2=diff(ind1)>ind_thresh;
ind1=ind1(ind2);

figure;
%plot(data_lfp(1,:),'k')
%hold on
plot(temp2,'k')
hold on
plot([ind1; ind1],[-1 1],'r')

