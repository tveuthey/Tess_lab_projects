figure
subplot(4,1,1);
t=0:0.001:10;
freq1=50;
y=(sin (2*freq1*pi*t));
f=real(fft(y));
f=f.^2;
f=f/max(f);
plot(f,'b'); hold on;

freq2=1;
y2=(sin (2*freq2*pi*t));
f2=real(fft(y2));
f2=f2.^2;
f2=f2/max(f2);
plot(f2,'r')
set(gca,'XLim',[0 2000])


y3=y2.*y;
f3=real(fft(y3));
f3=f3.^2;
f3=f3/max(f3);
plot(f3,'k')
set(gca,'XLim',[0 1000])
subplot(4,1,2);
plot(y3);set(gca,'XLim',[0 1000])

subplot(4,1,3)
h=10
l=100
temp=hilbert2(y3,1000,h,l);
plot(abs(temp))
%hold on;
%temp2=hilbert(y,1000,10,50,1);
%plot(abs(temp2),'b')
set(gca,'XLim',[0 1000])

subplot(4,1,4)
plot((real(fft(temp)).^2))
title([h l])
set(gca,'XLim',[0 1000])

%% step function modulation
clear
figure(2)
subplot(4,1,1);
t=0:0.001:10;
freq1=20;
y=(sin (2*freq1*pi*t));
f=real(fft(y));
f=f.^2;
f=f/max(f);
%plot(f,'b'); hold on;
hold on
% freq2=1;
% y2=(sin (2*freq2*pi*t));
% f2=real(fft(y2));
% f2=f2.^2;
% f2=f2/max(f2);
% plot(f2,'r')
% set(gca,'XLim',[0 2000])

y2=zeros (size(y));
y2(20:30)=1;
y2(200:230)=1;
y2(500:560)=1;
y2(800:900)=0.5;
plot(y2,'k')
set(gca,'XLim',[0 1000])

y3=y.*y2;
%f3=real(fft(y3));
%f3=f3.^2;
%f3=f3/max(f3);


subplot(4,1,2);
plot(y3);set(gca,'XLim',[0 1000])
hold on

subplot(4,1,3)
h=25
l=10
temp=hilbert2(y3,1000,h,l);
figure(2)
plot(abs(temp))
%hold on;
%temp2=hilbert(y,1000,10,50,1);
%plot(abs(temp2),'b')
set(gca,'XLim',[0 1000])
hold on

subplot(4,1,4)
plot(real(temp))
hold on
set(gca,'XLim',[0 1000])

%% slow sine modulation

figure
subplot(4,1,1);
t=0:0.001:10;
freq1=2;
y1=(sin (2*freq1*pi*t));
freq2=2;
y2=(sin (2*freq2*pi*t));
y=y1+y1;
plot(y)

subplot(4,1,2)
f=real(fft(y,1000));
f=f.^2;
f=f/max(f);
plot(1:1:1000,f,'b'); hold on;

