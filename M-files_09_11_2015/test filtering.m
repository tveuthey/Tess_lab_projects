load('C:\Users\Karunesh\Desktop\BMI_sleep\data_block_S34_Cat302_305Sleep.mat');

%%

figure;
t_phrase='PRE'
% Pre-learning
ind_s=6.26*10^5;
ind_e=1.16*10^6;

%post_learning
t_phrase='POST'
ind_s=2.04*10^6;
ind_e=2.31*10^6;

y=data(1,ind_s:ind_s+150000);



%clear
Fs = Fs_lfp;                    % Sampling frequency
T = 1/Fs;                     % Sample time
                   % Length of signal
L = length(y);  
t = (0:L-1)*T;                % Time vector

y=y-mean(y);

subplot(4,1,1)
plot(y)
title(t_phrase)

%NFFT = L;
NFFT=2^14;
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

subplot(4,1,2)
% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1))) 
xlim([0 50])
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')


subplot(4,1,3)

fs = Fs; % sampling frequency
ol = round(NFFT/2); % overlap between segments
len = NFFT; %500; %length of segmentc
nfft = NFFT; %number of points in fft
nw = 7/2; % Time bandwidth prodcut for pmtm

clear Pxx Xtemp
foo=y;
count=1;
s = len/2 + 1; % The time point at which you are calculating the spectrum
j = 1; %count
[s j]
%This while loop performs the actual computation using pmtm
while s < [length(foo) - len/2]
    seg = foo(s-len/2:s+len/2);
    seg=seg-mean(seg);
    [Pxx(:,j), f] = pmtm(seg,nw,nfft,fs);
    j = j + 1;
    s = s + ol; % create a new point every l ms ie. every 100ms
    %disp([s s-len/2 s+len/2]')
    disp([s length(foo)])
end


max_f=60
f_temp=find(f>max_f);
plot(f,mean(Pxx'))
xlim([0 30])


%
%This loop averages the power every 6 bands (i.e. over ~10Hz), and is saved as Xtemp
STEP_freq=1;
f = Fs/2*linspace(0,1,NFFT/2+1)
highestband = max(f)/2;
for i = 1:STEP_freq:highestband
    %Xtemp(count, :) = mean(10*log10(Pxx(i:i+STEP_freq,:)));
    Xtemp(count, :) = mean((Pxx(i:i+STEP_freq,:)));
    
    count = count + 1;
end
subplot(4,1,4)
temp=mean(Xtemp');
plot_x=1:STEP_freq:highestband;
hold on;
plot(plot_x,temp(1:length(plot_x)))


figure;surface(Xtemp)
shading interp


