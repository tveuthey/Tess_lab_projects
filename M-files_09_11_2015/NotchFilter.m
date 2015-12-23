function out=NotchFilter(data,frq,fs);
%%close all;
%%clear all;
%%load ecg_signalas.mat;
dim=size(data);
t=0:1/fs:(dim(2)/fs-1/fs);
% figure
% subplot(2,2,1); plot(t, data);
% title(' Oroginal ECG');
% xlabel('Time (s)');
% grid on;


YY=[data, zeros(1, 512-length(data))];
dim1=size(YY);
Y = fft(YY,dim1(2)/2);
Pyy = 10*log10(Y.* conj(Y) / length(Y));
f = fs*(0:(length(Y)-1)/2)/length(Y);
% subplot(2,2,3);plot(f,Pyy(1:(length(Y)/2)));
% title('Original ECG frequency characteristic');
% xlabel('Frequency (Hz)');
% grid on;

w0=2*pi*((frq)/(fs));
G=1/(2-2*cos(w0));

z1=cos(w0)+j*sin(w0);
z2=cos(w0)-j*sin(w0);

out=filter( [1/G, -2*cos(w0)/G, 1/G],1, data);
% subplot(2,2,2); plot(t, out);
% title('Filtered ECG signal');
% xlabel('Time (s)');
% grid on;

YYF=[out, zeros(1, 512-length(data))];
dim1=size(YYF);
FY = fft(YYF,dim1(2)/2);
Pyy1 = 10*log10(FY.* conj(FY) / length(FY));
f1 = fs*(0:(length(Y)-1)/2)/length(Y);
% subplot(2,2,4);plot(f1,Pyy1(1:((length(FY)/2))));
% title(' Filtered ECG frequency characteristic');
% xlabel('Frequency (Hz)');
% grid on;
%  figure
 %kfreqz([1/G, -2*cos(w0)/G, 1/G], 1,500,fs);