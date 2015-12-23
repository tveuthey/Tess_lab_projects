2^function plot_lfp_power_spectrogram(data, window, Fs, filename)
params.Fs = Fs;
params.fpass = [0 60];
params.err = 0;
params.trialave = 0;
params.tapers = [3 5];

[S t f] = mtspecgramc(data, window, params);
zS = zscore(S);
figure
f1 = imagesc(t,f,zS');
set(gca,'YDir','norm');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title(filename);
saveas(f1,['D:\MultiSiteLFP_LG\T100\' filename '.tiff']);
