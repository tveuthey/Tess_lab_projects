function [Output]=lfp_analysis_for_BMI_sleep_ripple (Fs_lfp, wave, rip_pre, rip_post, unit)
close all;
% med_LFP=median(data(:,:));
% time_pre=ind_pre(1):ind_pre(end);
% time_post=ind_post(1):ind_post(end);
% med_LFPpre=med_LFP(:,time_pre);
% med_LFPpost=med_LFP(:,time_post);

med_LFP_pre1=resample(rip_pre, 1000, round(Fs_lfp));
med_LFP_post1=resample(rip_post, 1000, round(Fs_lfp));

cat_LFP{1}=med_LFP_pre1;
cat_LFP{2}=med_LFP_post1;

FILTER_ORDER_t=4;
END_SMOOTHING_t=100;
srate_t = 1000;
nyq_sample_t=srate_t/2;
f_lo_t=80;
f_hi_t=1;
[bt,at]=butter(FILTER_ORDER_t,f_hi_t/nyq_sample_t,'high');

for i=[1 2]
    clear data_LFP NFFT Y f
    data_LFP(:,:)=cat_LFP{i};
    %%plotting STFT
%     data_LFP=(abs(filter(bt,at,data_LFP))).^2;
    T = 0:0.001:(length(data_LFP(:,:))/1000);
    subplot(2,2,[i]+2)
    spectrogram(data_LFP(:,:));
    ylabel('Time ','FontSize',14,'FontWeight','BOLD'); xlabel('Hz','FontSize',14,'FontWeight','BOLD');XLim([0 0.5])
    set(gca,'FontSize',14,'FontWeight','BOLD' )
    % [S,F,T,P] = spectrogram(X,256,250,256,1E3);
    % surf(T,F,10*log10(P),'edgecolor','none'); axis tight;
    % view(0,90);
    %     xlabel('Time (Seconds)'); ylabel('Hz');
    %plotting FFT
    
    NFFT (:,:) = 2^nextpow2(length(data_LFP(:,:))); % Next power of 2 from length of y
    Y = fft(data_LFP(:,:),NFFT(:,:))/length(data_LFP(:,:));
    f = 1000/2*linspace(0,1,NFFT(:,:)/2+1);
    
    % Plot single-sided amplitude spectrum.
    subplot(2,2,[1 2])
    if i==1
        plot(f,2*abs(Y(1:NFFT(:,:)/2+1)),'b','LineWidth',2);
    else
        plot(f,2*abs(Y(1:NFFT(:,:)/2+1)),'r','LineWidth',2);
    end
    hold on;
    t=['Single-Sided Amplitude Spectrum of RipplePrePost' num2str(unit)];
    title('Single-Sided Amplitude Spectrum of RipplePrePost','FontSize',14,'FontWeight','BOLD')
    xlabel('Frequency (Hz)','FontSize',14,'FontWeight','BOLD'); XLim([0 0.5])
    ylabel('Amplitude','FontSize',14,'FontWeight','BOLD')
    legend('Pre','Post','Location','NorthEast')
    set(gca,'FontSize',14,'FontWeight','BOLD' )
end

filename=['C:\Users\Ganguly Lab\Documents\MATLAB\Tanuj\Mat_files\Result_figs\BMI\S32\4_17_13\Sleep-RipplePrePost' num2str(unit) '.tiff'];
set(gcf, 'Position', get(0,'Screensize'));
% saveas(gcf,filename);

Output=mean(f);