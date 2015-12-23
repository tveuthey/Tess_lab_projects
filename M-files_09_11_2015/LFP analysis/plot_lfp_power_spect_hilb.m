function plot_lfp_power_spect_hilb(data, Fs, filename)

[cfs,sigma_fs,hData]=processingHilbertTransform_filterbankGUI_onechan(data, Fs, [0 60]);
hilbdata = zscore(abs(squeeze(hData))',0,2);
figure
f1 = imagesc(1:length(hilbdata)./Fs, cfs, hilbdata);
set(gca,'YDir','norm');
title(filename);
xlabel('Time (s)');
ylabel('Frequency (Hz)');
saveas(f1,['D:\MultiSiteLFP_LG\T100\' filename '_power_hilb_unsmoothed.tiff']);