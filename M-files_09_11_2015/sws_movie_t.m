clear
load('C:\Users\Karunesh\Desktop\BMI_sleep\data_block_S34_Cat302_305Sleep.mat');

% 
% t_phrase='PRE'
% % Pre-learning
% ind_s=6.26*10^5;
% ind_e=1.16*10^6;

sws1=[sleep_ind_pre(1):sleep_ind_pre(end)];
sws2=[sleep_ind_post(1):sleep_ind_post(end)];

% %post_learning
% t_phrase='POST'
ind_s=2.04*10^6;
ind_e=2.31*10^6;

ind_s=sws1(1);
ind_e=sws1(end);

FILTER_ORDER=3;
f_lo=20
f_hi=0.3
srate = Fs_lfp; 
nyq_sample=srate/2;
[b2,a2]=butter(FILTER_ORDER,[f_hi f_lo]/nyq_sample);

dec_factor=20;
for n = 1:32
  temp=data(n,ind_s:ind_e);
  temp=decimate(temp,dec_factor);
  temp=filtfilt(b2,a2,temp);
  data2(n,:)=(temp-mean(temp))/std(temp);
  disp(n);
end;


Fs_lfp=Fs_lfp/dec_factor
TS10=TimeStamps{24,2};
TS10_2a=find(TS10>(ind_s/1017.3));
TS10_2b=find(TS10>(ind_e/1017.3));
TS10_2=TS10(TS10_2a(1):TS10_2b(1));
TS10_2=TS10_2-ind_s/1017.3;


%%

array_ind=[];
figure
ylims=3.5;
plotlen=150;

set(gcf,'Position',[ 40   169   894   753]);
for n = (plotlen+1):length(data2)
	subplot('Position',[0.1 0.4 0.8 0.5])    
    temp=data2(:,n);
    temp2=reshape(temp,4,8);
    temp2=[temp2 temp2(:,8)];
    temp2=[temp2' temp2(4,:)'];
    surF(temp2);
    set(gca,'CLim',[-2.5 2.5])    
    %zlim([-4 4]);

    shading interp
    colorbar
%        shading flat
    axis off
    az=-14;
    el=90;
    view(az,el);
    
    subplot('Position',[0.1 0.1 0.8 0.2])
    %plot(data2(1:32,n-plotlen:n+plotlen)','k','LineWidth',1)
    %hold on
    plot(data2(1,n-plotlen:n+plotlen)','r','LineWidth',2)
        hold on

    ylim([-ylims ylims]);
    line([plotlen plotlen],ylim,'Color',[0.2 0.2 0.27],'LineStyle',':')
    axis off
    
   TS10_3a=find(TS10_2>(n-plotlen)/Fs_lfp);
   TS10_3b=find(TS10_2>(n+plotlen)/Fs_lfp);
   TS10_3=TS10_2(TS10_3a(1):TS10_3b(1)-1);
   TS10_3=TS10_3-(n-plotlen)/Fs_lfp;
   plot([TS10_3; TS10_3]*Fs_lfp,[0 1],'k','LineWidth',3);
    hold off
    

     pause(0.005)
 
  end
   
 %% spike trigger spatial average
 
slen=length (TS10_2)
pre_spk=400;
post_spk=400;
lfp_array=zeros(slen,32,pre_spk+post_spk+1);
data3=data(:,ind_s:ind_e);

for n = 1:slen
    t_spk=round(TS10_2(n)*1017.3);
    inds=t_spk+(-pre_spk:post_spk);
    if inds(1) > 0 && inds(end) < length(data3)
        lfp_array(n,:,:)=data3(:,inds);
    end
end
 m_lfp_array=(mean(lfp_array));
m_lfp_array= reshape(m_lfp_array,32,pre_spk+post_spk+1);
     disp('done')

% remove dc offset per channel
for n=1:32
    m_lfp_array(n,:)= m_lfp_array(n,:)-mean( m_lfp_array(n,:));
    m_lfp_array(n,:)=m_lfp_array(n,:)/std(m_lfp_array(n,:));
end
figure;plot(m_lfp_array')

%% show mean movie
figure
plot(m_lfp_array','k')
hold on
plot(m_lfp_array(1,:),'r')

figure
for n = 1:size(m_lfp_array,2)
	%subplot('Position',[0.1 0.4 0.8 0.5])    
    temp=m_lfp_array(:,n);
    %temp(10)=-2;
    temp2=reshape(temp,4,8);
    temp2=[temp2 temp2(:,8)];
    temp2=[temp2' temp2(4,:)'];
    surF(temp2);
    set(gca,'CLim',[-1.5 1.5])    
    shading interp
    colorbar
%     shading flat
    axis off
    az=-20;
    el=88;
    view(az,el);

    title(n)
     pause(0.005)
 
  end
   