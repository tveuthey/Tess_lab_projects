
function [diff_EMG]= differential_EMG(raw_EMG,chan1, chan2)

l=length(chan1);
t=10000:20000;
for i=1:l
    diff_EMG(i,:)=raw_EMG(chan1(i),:)-raw_EMG(chan2(i),:);
end
% figure(1)
% subplot(12,3,[i]); plot(raw_EMG(chan1(i),t));subplot(12,3,[i+3]); plot(raw_EMG(chan2(i),t))
% 
% 
% 
% 
% %% differential
% 
% 
% 
% 
% 
% 
chan_emgs=size(sEMG,1);
for i=1:chan_emgs;
    sEMG_norm(i,:)=((sEMG(i,:))-(mean(sEMG(i,:))))/std(sEMG(i,:));
    plot(sEMG_norm(i,:)/20+i); hold on;
end