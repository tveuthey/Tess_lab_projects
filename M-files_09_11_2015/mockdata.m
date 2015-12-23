clear


t=0:0.001:600;
freq1=20;
y=(sin(2*freq1*pi*t));
plot(t(1:2500),y(1:2500))
% f=real(fft(y));
% f=f.^2;
% f=f/max(f);
% plot(f,'b'); hold on;
strobe=zeros (size(y));
%plot(strobe(1:2.5),'r')
% strobe(20:30)=1;
% (200:230)=1;
% y2(500:560)=1;
% y2(800:900)=0.5;
for i=1:30
strobe=zeros (size(y));
strobe(20000*i:((20000*i)+100))=1;
strobe1{i}=strobe((20000*i)-19999:20000*i);

multiplier=zeros(size(y));
multiplier(((20000*i)-400):((20000*i)-50))=1;
multiplier1{i}=multiplier((20000*i)-19999:20000*i);

% multiplier2=zeros(size(y));
% multiplier2([(20000*i)+(10*i)]:[(20000*i)+(20*i)])=1*i/15;
% multiplier4{i}=multiplier2([(20000*i)-19999]:[(20000*i)+(20*i)]);

% strobe(x)=1
% strobe(x)=[strobe]
end
maxLength=max(cellfun(@(x)numel(x),strobe1));
strobe=cell2mat(cellfun(@(x)cat(2,x,NaN(1,maxLength-length(x))),strobe1,'UniformOutput',false));
strobe=strobe(:,(isfinite(strobe(1,:))));
Reach=t(find(strobe==1));
Reach=Reach*1000;


maxLength=max(cellfun(@(x)numel(x),multiplier1));
multiplier=cell2mat(cellfun(@(x)cat(2,x,NaN(1,maxLength-length(x))),multiplier1,'UniformOutput',false));
multiplier=multiplier(:,(isfinite(multiplier(1,:))));
%plot(t,y); hold on; plot(strobe)
y=y(1:600000);
t=t(1:600000);
Fs_lfp=1000;
Fs_wave=1000;
data=y.*multiplier;
Reach=Reach(1:29);
Reward=Reach-500;

TimeStamps{1,1}=t(find(data>0));






