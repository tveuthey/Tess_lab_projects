function [Output]=plotrastershistBMIneurons(TimeStamps, chan_no,data,wave,Fs_lfp,Waves,N,sc,bin_size,space)

close all;
clear c1 c2 c3 chan_inc chan_dec chan_unchanged not eval c_empt
c1=[0];
c2=[0];
c3=[0];
chan_inc=[];
chan_dec=[];
chan_unchanged=[];
not_eval=[];
c_empt=[];
length_to_analyze=length(data);
block=1:length_to_analyze;

% averaging LFPs after normalizing
% data2=data(:,block);
% for k=1:size(data,1)
%     lfp_norm(k,:)=(data(k,:)-mean(data(k,:)))/std(data(k,:));
% end
% lfp_avg2=mean(lfp_norm,1);
% lfp_avg=(lfp_avg2-mean(lfp_avg2))/std(lfp_avg2);

%creating pre, during and post intervals
temp3=wave(1,block)>2;
figure;
plot(temp3)
hold on
start1=find(diff(temp3)>0.5);
start2=find(diff(temp3)<-0.5);
[start]=[start1 start2];
figure(100)
% plot(start,[1],'rx');hold off

% averaging LFPs for pre, dur & post after normalizing

% LFP_pre=data(:,1:start1);
% LFP_dur=data(:,start1:start2);
% LFP_post=data(:,start2:length(data));
% 
% for k=1:size(data,1)
%     LFP_pre_norm(k,:)=(LFP_pre(k,:)-mean(LFP_pre(k,:)))/std(LFP_pre(k,:));
%     LFP_dur_norm(k,:)=(LFP_dur(k,:)-mean(LFP_dur(k,:)))/std(LFP_dur(k,:));
%     LFP_post_norm(k,:)=(LFP_post(k,:)-mean(LFP_post(k,:)))/std(LFP_post(k,:));
% end
% 
% LFP_pre_mean=mean(LFP_pre_norm,1);
% LFP_pre_mean_norm=(LFP_pre_mean-mean(LFP_pre_mean))/std(LFP_pre_mean);
% LFP_dur_mean=mean(LFP_dur_norm,1);
% LFP_dur_mean_norm=(LFP_dur_mean-mean(LFP_dur_mean))/std(LFP_dur_mean);
% LFP_post_mean=mean(LFP_post_norm,1);
% LFP_post_mean_norm=(LFP_post_mean-mean(LFP_post_mean))/std(LFP_post_mean);

trange_tot=1/Fs_lfp: length(data)/Fs_lfp;   %round((1:length(data2))/Fs_lfp);
% trange_pre=1/Fs_lfp: start1/Fs_lfp;%round((1:start1)/Fs_lfp);
% trange_dur=start1/Fs_lfp: start2/Fs_lfp; %round((start1:start2)/Fs_lfp);
% trange_post=start2/Fs_lfp: length(data)/Fs_lfp;%round((start2:length(data2))/Fs_lfp);
% GAP_THRESH=2; %threshold value for gap in spike times

%getting single units
% if length(sc)>1
sort_codes=length(sc);

for k=1:length(sc);
    
    for i=length(chan_no)
        % for i=1:32
        clear trials tstamps tstamps_tot tstamps_pre tstamps_dur tstamps_post spont gaps trial_ind bin_rate max_bin_rate Yax_lim
        clear waves binned dNpre tpre dNdur tdur dNpost tpost dNpost2 dNpre2
        % spikes =[1:2:10, 15:1.6:30, 35:0.3:50, 53:0.1:60, 80:1:90];
        if isempty(N{chan_no(i),sc(k)})==1
            disp(i)
            disp('channel is empty')
            c_empt=[c_empt i];
        else
            if N{chan_no(i),sc(k)}<=100
                disp(i)
                disp('Less spikes - not analyzed')
                not_eval=[not_eval i];
                
            else
                if k==1
                    figure(i)
                else
                    if k==2
                        figure(i+32)
                    else
                        if k==3
                            figure(i+64)
                        else
                            if k==4
                                figure(i+96)
                            end
                        end
                    end
                end
                tstamps=TimeStamps{chan_no(i),sc(k)};
                
                tstamps_tot=tstamps(1:space:end);
%                 tpre1=find(tstamps>trange_pre(1));
%                 tpre2=find(tstamps>trange_pre(end));
%                 tstamps_pre=tstamps(tpre1:tpre2-1);
                
%                 tdur1=find(tstamps>trange_dur(1));
%                 tdur2=find(tstamps>trange_dur(end));
%                 tstamps_dur=tstamps(tdur1:tdur2-1);
%                 
%                 tpost1=find(tstamps>trange_post(1));
%                 tpost2=find(tstamps>trange_post(end));
%                 tstamps_post=tstamps(tpost1);
%                 
                rastertics_tot{i}=[tstamps_tot];
%                 rastertics_pre{i}=[tstamps_pre];
%                 rastertics_dur{i}=[tstamps_dur];
%                 rastertics_post{i}=[tstamps_post];
                
                bin_vector = [trange_tot(1):bin_size:trange_tot(end)];
                
                waves=Waves{chan_no(i),sc(k)};
                
                if ~isempty (tstamps)
                    if length(tstamps) == 1
                        binned = histc(tstamps,bin_vector);
                    else
                        binned = histc(tstamps,bin_vector)';
                    end
                end
                
                bin_rate =[binned];
                max_bin_rate=max(smooth(bin_rate));
                Yax_lim=round(max_bin_rate/2);
                
%                 [dNpre,tpre]=binspikes(tstamps_tot,0.1,[0 start1/Fs_lfp]);
%                 [dNdur,tdur]=binspikes(tstamps_tot,0.1,[start1/Fs_lfp start2/Fs_lfp]);
%                 [dNpost,tpost]=binspikes(tstamps_tot,0.1,[start2/Fs_lfp (length(data)/Fs_lfp)]);
%                 if length(tpre) < length(tpost)
%                     dNpost2=dNpost(1:length(tpre));
%                     [H,P] = ttest(dNpre,dNpost2);
%                     subplot(4,4,[4 8])
%                     te=['p value'  num2str(P)];
%                     scatter(tpre,dNpre); hold on; scatter(tpost,dNpost,'r^'); title(te);
%                     
%                 else
%                     dNpre2=dNpre(1:length(tpost));
%                     [H,P] = ttest(dNpre2,dNpost);
%                     subplot(4,4,[4 8])
%                     te=['p value'  num2str(P)];
%                     scatter(tpre,dNpre); hold on; scatter(tpost,dNpost,'r^'); title(te);
%                 end
%                 
%                 if P<0.05
%                     if mean(dNpre)<mean(dNpost)
%                         c1=[c1]+1; % cells that increased firing
%                         per_inc=((mean(dNpost)-mean(dNpre))/mean(dNpost))*100;
%                         if k==1
%                             chan_inc=[chan_inc; i];
%                         else
%                             if k==2
%                                 chan_inc=[chan_inc; i+32];
%                             else
%                                 if k==3
%                                     chan_inc=[chan_inc; i+64];
%                                 else
%                                     if k==4
%                                         chan_inc=[chan_inc; i+96];
%                                     end
%                                 end
%                             end
%                         end
%                         
%                         
%                     else
%                         c2=[c2]+1;   % cells that decreased firing
%                         per_dec=((mean(dNpre)-mean(dNpost))/mean(dNpre))*100;
%                         if k==1
%                             chan_dec=[chan_dec; i];
%                         else
%                             if k==2
%                                 chan_dec=[chan_dec; i+32];
%                                 
%                             else
%                                 if k==3
%                                     chan_dec=[chan_dec; i+64];
%                                     
%                                 else
%                                     if k==4
%                                         chan_dec=[chan_dec; i+96];
%                                         
%                                     end
%                                 end
%                             end
%                         end
%                     end
                    
                    
%                     
%                 else
%                     c3=[c3]+1  ;     % cells that didn't have significant increase
%                     if k==1
%                         chan_unchanged=[chan_unchanged; i];
%                     else
%                         if k==2
%                             chan_unchanged=[chan_unchanged; i+32];
%                             
%                         else
%                             if k==3
%                                 chan_unchanged=[chan_unchanged; i+64];
%                                 
%                             else
%                                 if k==4
%                                     chan_unchanged=[chan_unchanged; i+96];
%                                     
%                                 end
%                             end
%                         end
%                     end
%                 end
                
                
                
                subplot(4,1,1);
                plot((+1)*temp3,'k', 'LineWidth',3); XLim([0 length(temp3)]); YLim([-0.2 1.2]);%title('DC','FontSize',16,'FontWeight','BOLD')
                %         plot((-1)*temp3,'k', 'LineWidth',3); XLim([0 length(temp3)]); YLim([-1.2 0.2]);title('Cathodal tDCS Stimulation','FontSize',16,'FontWeight','BOLD')
%                 ylabel('current (mA)','FontSize',14,'FontWeight','BOLD');
                set(gca,'XTick',[0 length(temp3)],'XTickLabel',{'',''},'FontSize',14,'FontWeight','BOLD')
                set(gca,'YTick',[0 1],'YTickLabel',{'0','1'},'FontSize',14,'FontWeight','BOLD')
                
                subplot(4,1,2); plot(trange_tot(1):bin_size:trange_tot(end),smooth(bin_rate)+i,'r','LineWidth',3);XLim([0 (length(data)/Fs_lfp)]);YLim([1 max_bin_rate+1.5]);%set(gca,'XTick',[0 f2 f2*2 f2*3 ]);set(gca,'XTickLabel',{'-2','-1','Reach ON','1'},'FontSize',14,'FontWeight','BOLD');set(gca,'YTick',[0 0.5 1 ]);set(gca,'YTickLabel',{'0','','1'},'FontSize',14,'FontWeight','BOLD');set(ax4, 'XGrid', 'on');set(ax4, 'YGrid', 'on');
                set(gca,'FontSize',14,'FontWeight','BOLD');hold on;
                
                subplot(4,1,3); plot([rastertics_tot{i};rastertics_tot{i}],[0 1]+i,'c','Linewidth',1); XLim([0 (length(data)/Fs_lfp)]); hold on %hold on; plot([(temp3)/Fs_lfp],1,'r'); hold off;
                %title('Unit 1 Raster and Firing Rate ','FontSize',16,'FontWeight','BOLD')
                %set(gca,'XTickLabel',{'','','','','','','',''},'FontSize',14,'FontWeight','BOLD')
                xlabel('time (sec)','FontSize',14,'FontWeight','BOLD'); hold on
                %     subplot(3,4,[9 10 11 12]); plot(trange(1):10:trange(end),smooth(bin_rate),'r','LineWidth',3);XLim([0 (length(data)/Fs_lfp)]);YLim([1 max(bin_rate)+2]);%set(gca,'XTick',[0 f2 f2*2 f2*3 ]);set(gca,'XTickLabel',{'-2','-1','Reach ON','1'},'FontSize',14,'FontWeight','BOLD');set(gca,'YTick',[0 0.5 1 ]);set(gca,'YTickLabel',{'0','','1'},'FontSize',14,'FontWeight','BOLD');set(ax4, 'XGrid', 'on');set(ax4, 'YGrid', 'on');
                %     set(gca,'FontSize',14,'FontWeight','BOLD')
                % for i=1:length(chan_no)
%                 subplot(4,4,[1])
%                 plot(waves,'y');XLim([0 30]);YLim([-0.00015 0.00015]); set(gca,'XTick',[0 30],'FontSize',14,'FontWeight','BOLD');set(gca,'XTickLabel',{'0','1.2'},'FontSize',14,'FontWeight','BOLD'); set(gca,'YTick',[-0.00015 0 0.00015],'FontSize',14,'FontWeight','BOLD');set(gca,'YTickLabel',{'-150','0','150'},'FontSize',14,'FontWeight','BOLD'); xlabel('t(msec)','FontSize',14,'FontWeight','BOLD'); ylabel('microvolt','FontSize',14,'FontWeight','BOLD'); %title('Unit 1','FontSize',14,'FontWeight','BOLD')
%                 subplot(4,4,[5])
%                 bar(histc(diff(tstamps_tot),[0.005:0.001:0.100]),'y','Linewidth',2);set(gca,'XTick',[0 20 40 60 80 100],'FontSize',14,'FontWeight','BOLD');set(gca,'XLim',[0 40.5]);set(gca,'XTickLabel',{'0.00','0.02','0.04','0.06','0.08','0.10'},'FontSize',14,'FontWeight','BOLD');xlabel('Interspike Interval (s)','FontSize',14,'FontWeight','BOLD'); ylabel ('Counts per bin','FontSize',14,'FontWeight','BOLD'); title('R37 Spont Block 249 SC1','FontSize',14,'FontWeight','BOLD')
%                 
%                 for jpre=5:length(tstamps_pre)-1
%                     lfp_time_pre1=round(tstamps_pre(jpre)*Fs_lfp);
%                     lfp_time_pre=lfp_time_pre1-10:lfp_time_pre1+102;
%                     lfp_pre(jpre,:)=LFP_pre_norm(i,round(lfp_time_pre));
%                     lfp_avg_pre(jpre,:)=LFP_pre_mean_norm(lfp_time_pre);
%                 end
%                 
%                 for jdur=5:length(tstamps_dur)-1
%                     lfp_time_dur1=round(tstamps_dur(jdur)*Fs_lfp)-length(LFP_pre_mean);
%                     lfp_time_dur=lfp_time_dur1-10:lfp_time_dur1+102;
%                     lfp_dur(jdur,:)=LFP_dur_norm(i,lfp_time_dur);
%                     lfp_avg_dur(jdur,:)=LFP_dur_mean_norm(lfp_time_dur);
%                 end
%                 
%                 for jpost=5:length(tstamps_post)-1
%                     lfp_time_post1=round(tstamps_post(jpost)*Fs_lfp)-(length(LFP_dur_mean)+length(LFP_pre_mean));
%                     lfp_time_post=lfp_time_post1-10:lfp_time_post1+102;
%                     lfp_post(jpost,:)=LFP_post_norm(i,lfp_time_post);
%                     lfp_avg_post(jpost,:)=LFP_post_mean_norm(lfp_time_post);
%                 end
%                 subplot(4,4,[9 10 13 14])
%                 plot(mean(lfp_pre),'b', 'Linewidth',2);hold on;
%                 plot(mean(lfp_avg_pre),'b', 'Linewidth',4);
%                 plot(mean(lfp_dur),'r', 'Linewidth',2);
%                 plot(mean(lfp_avg_dur),'r', 'Linewidth',4);
%                 plot(mean(lfp_post),'g', 'Linewidth',2);
%                 plot(mean(lfp_avg_post),'g', 'Linewidth',4);%XLim([round(3*Fs_lfp) round(3*Fs_lfp)+102])
%                 title('STA','FontSize',14,'FontWeight','BOLD')
%                 xlabel('time (msec)','FontSize',14,'FontWeight','BOLD')
%                 ylabel('amp','FontSize',14,'FontWeight','BOLD');
%                 legend('pre','pre_avg','dur','dur_avg', 'post','post_avg')
%                 set(gca,'XTick',[0 11 113],'FontSize',12,'FontWeight','BOLD');
%                 set(gca,'XTickLabel',{'-10','SpikeTime', '100'},'FontSize',12,'FontWeight','BOLD');
%                 hold off;
%                 
                
%                 lfp_pre_full=LFP_pre_norm(i,:);
%                 lfp_dur_full=LFP_dur_norm(i,:);
%                 lfp_post_full=LFP_post_norm(i,:);
%                 
%                 NFFTpre = 2^nextpow2(length(lfp_pre_full)); % Next power of 2 from length of y
%                 Ypre = fft(lfp_pre_full,NFFTpre)/length(lfp_pre_full);
%                 f_pre = Fs_lfp/2*linspace(0,1,NFFTpre/2+1);
%                 
%                 NFFTdur = 2^nextpow2(length(lfp_dur_full)); % Next power of 2 from length of y
%                 Ydur = fft(lfp_dur_full,NFFTdur)/length(lfp_dur_full);
%                 f_dur = Fs_lfp/2*linspace(0,1,NFFTdur/2+1);
%                 
%                 NFFTpost = 2^nextpow2(length(lfp_post_full)); % Next power of 2 from length of y
%                 Ypost = fft(lfp_post_full,NFFTpost)/length(lfp_post_full);
%                 f_post = Fs_lfp/2*linspace(0,1,NFFTpost/2+1);
%                 
%                 subplot(4,4,[11 12 15 16])
%                 plot(f_pre,2*abs(Ypre(1:NFFTpre/2+1)),'b', 'Linewidth',2);hold on;
%                 plot(f_dur,2*abs(Ydur(1:NFFTdur/2+1)),'r', 'Linewidth',2);
%                 plot(f_post,2*abs(Ypost(1:NFFTpost/2+1)),'g', 'Linewidth',2);
%                 title('Single-Sided Amplitude Spectrum of y(t)','FontSize',14,'FontWeight','BOLD')
%                 xlabel('Frequency (Hz)','FontSize',14,'FontWeight','BOLD')
%                 ylabel('|Y(f)|','FontSize',14,'FontWeight','BOLD');XLim([0 5])
%                 legend('pre','dur','post')
%                 hold off;
%                 
%                 if k==1
%                     filename=['Mat_files/Result_figs/SigStims/S30/S30 STA_FFT Block 27 Chan' num2str(i) '.tiff'];
%                     saveas(gcf,filename);
%                 else
%                     if k==2
%                         filename=['Mat_files/Result_figs/SigStims/S30/S30 STA_FFT Block 27 Chan' num2str(i+32) '.tiff'];
%                         saveas(gcf,filename);
%                     else
%                         if k==3
%                             filename=['Mat_files/Result_figs/SigStims/S30/S30 STA_FFT Block 27 Chan' num2str(i+64) '.tiff'];
%                             saveas(gcf,filename);
%                         else
%                             if k==4
%                                 filename=['Mat_files/Result_figs/SigStims/S30/S30 STA_FFT Block 27 Chan' num2str(i+96) '.tiff'];
%                                 saveas(gcf,filename);
%                             end
%                         end
%                     end
%                 end
                
            end
        end
    end
    
    
end
Total_Cells= [(length(not_eval)+length(chan_inc)+length(chan_dec)+length(chan_unchanged))-length(c_empt)];
Cells_Modulated= [Total_Cells-(length(chan_inc)+length(chan_dec))];
Cells_Modulated_Percentage=(Cells_Modulated/ Total_Cells)*100;

Cells_Inc=[length(chan_inc)];
Cells_Inc_Percentage=(length(chan_inc)/ Total_Cells)*100;
Cells_Dec=[length(chan_dec)];
Cells_Dec_Percentage=(length(chan_dec)/ Total_Cells)*100;
Cells_Unchanged=[length(chan_unchanged)];
Cells_Unchanged_Percentage=(length(chan_unchanged)/ Total_Cells)*100;

Output.Total_Cells= [length(not_eval) length(c_empt)]
Output.Cells_Modulated=[Cells_Modulated Cells_Modulated_Percentage Cells_Inc Cells_Inc_Percentage  Cells_Dec Cells_Dec_Percentage  Cells_Unchanged Cells_Unchanged_Percentage]
Output.Inc_Cells=[chan_inc]
Output.Dec_Cells=[chan_dec]
Output.Unchanged_Cells=[chan_unchanged]
