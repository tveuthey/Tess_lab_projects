
igure
 
FILTER_ORDER=4;
 
END_SMOOTHING=100;
 

srate = Fs_lfp;
 
nyq_sample=srate/2;
 
f_lo=300;
 
f_hi=100;
 
[b,a]=butter(FILTER_ORDER,f_hi/nyq_sample,
'high'); 



lfp_chan=[1 3 5 7 2 4 6 8];
 
time_before=1000;
 
time_after=6000;
 
  
lfp_chan=4; 


for
 n=1:length(Reach) 
subplot(2,1,1);
 
plot(wave(1,(Reach(n)-time_before):(Reach(n)+time_after)))
 


subplot(2,1,2); 

temp=data(lfp_chan,round(((Reach(n)-time_before):(Reach(n)+time_after))/2));
 
data_filt1=abs(filter(b,a,temp));
 
data_filt1=smooth(data_filt1,END_SMOOTHING);
 
plot(data_filt1)
 
pause


 end