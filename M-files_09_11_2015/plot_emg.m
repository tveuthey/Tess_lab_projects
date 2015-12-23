plot_emg(diff_EMG)

chan_emgs=size(diff_EMG,1);

for i=1:chan_emgs;
    diff_EMG_norm(i,:)=((diff_EMG(i,:))-(mean(diff_EMG(i,:))))/std(diff_EMG(i,:));
    plot(diff_EMG_norm(i,:)/20+i); hold on;
end