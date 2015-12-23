function [Output1,Output2]=plot_SWS_coherence4_neuromod_temp_evolve(TimeStamps,data, wave,units, chan_no, sc, bin_size,space, Fs_lfp, taper, win)
figure
close all

l1=length(wave);



segs=round(l1/25000)-10;
display(segs)
t=[];
for i2=1:segs
    time_pre=(1:25000)+(25000*(i2-1));
    disp([time_pre(1) time_pre(end) (time_pre(end)-time_pre(1))])
    bin_vector=round(time_pre(1)/Fs_lfp):bin_size:(round(time_pre(end)/Fs_lfp)-round(time_pre(1)/Fs_lfp));
    
    for i3=1:length(units)
        close
        unit=units(i3);
        
        clear ts_pre ts_post lfp_pre lfp_post
        ts_pre=[];
        %     ts_post=[];
        lfp_pre=[];
        %     lfp_post=[];
        
        if isempty(chan_no)==1
            if unit==1
                chan_no=[3];
            else
                if unit==2
                    chan_no=[4];
                else
                    if unit==3
                        chan_no=[6];
                    else if unit==4
                            chan_no=[6];
                        else if unit==5
                                chan_no=[7];
                            else if unit==6
                                    chan_no=[8];
                                else if unit==7
                                        chan_no=[2];
                                    else if unit==8
                                            chan_no=[15];
                                        else if unit==9
                                                chan_no=[11];
                                            else if unit==10
                                                    chan_no=[12];
                                                else if unit==11
                                                        chan_no=[13];
                                                    else if unit==12
                                                            chan_no=[14];
                                                        else if unit==13
                                                                chan_no=[15];
                                                            else if unit==14
                                                                    chan_no=[16];
                                                                else if unit==15
                                                                        chan_no=[31];
                                                                    else if unit==16
                                                                            chan_no=[9];
                                                                        else if unit==17
                                                                                chan_no=[19];
                                                                            else if unit==18
                                                                                    chan_no=[20];
                                                                                else if unit==19
                                                                                        chan_no=[21];
                                                                                    else if unit==20
                                                                                            chan_no=[22];
                                                                                        else if unit==21
                                                                                                chan_no=[23];
                                                                                            else if unit==22
                                                                                                    chan_no=[24];
                                                                                                else if unit==23
                                                                                                        chan_no=[21];
                                                                                                    else if unit==24
                                                                                                            chan_no=[31];
                                                                                                        else if unit==25
                                                                                                                chan_no=[27];
                                                                                                            else if unit==26
                                                                                                                    chan_no=[28];
                                                                                                                else if unit==27
                                                                                                                        chan_no=[29];
                                                                                                                    else if unit==28
                                                                                                                            chan_no=[30];
                                                                                                                        else if unit==29
                                                                                                                                chan_no=[31];
                                                                                                                            else if unit==30
                                                                                                                                    chan_no=[32];
                                                                                                                                else if unit==31
                                                                                                                                        chan_no=[15];
                                                                                                                                    else if unit==32
                                                                                                                                            chan_no=[25];
                                                                                                                                        end
                                                                                                                                    end
                                                                                                                                end
                                                                                                                            end
                                                                                                                        end
                                                                                                                    end
                                                                                                                end
                                                                                                            end
                                                                                                        end
                                                                                                    end
                                                                                                end
                                                                                            end
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        else
            disp('using' )
            disp(chan_no)
            disp('for')
            disp(unit)
        end
        
        lfp=data(chan_no,:);
        lfp=median(data);
        % lfp=decimate(lfp,2);
        lfp=base_norm(lfp);
        ts=TimeStamps{unit,sc};%*Fs_lfp;
        ts1=ts(1:space:end);
        %   data_sp(1).times=[ts];
        
        
        params.Fs=Fs_lfp;
        params.fpass=[0 20];
        params.tapers=[taper(1) taper(2)];
        params.trialave=1;
        params.pad=1;
        params.err=[2 0.05];
        
        
        
        
        ts1_pres=find(ts1>round(time_pre(1)/Fs_lfp));
        ts1_pree=find(ts1<round(time_pre(end)/Fs_lfp));
        ts1_pre1=intersect(ts1_pres,ts1_pree);
        ts1_pre2=(ts1(ts1_pre1));
        ts1_pre=ts1_pre2-ts1_pre2(1);
        ts1_bin_rate_pre=mean(histc(ts1_pre,bin_vector));
        lfp_pre=[lfp_pre lfp(time_pre)];
        
        
        lfp_pre=lfp_pre';
        disp(length(lfp_pre'))
        %     figure(1);
        %     subplot(2,1,1)
        %     plot(lfp_pre)
        [dN_pre,t_pre]=binspikes(ts1_pre,1017.3,[0 round(length(lfp_pre)/Fs_lfp)]);
        if length(lfp_pre)<length(dN_pre)
            dN_pre=dN_pre(1:length(lfp_pre),:);
        else
            lfp_pre=lfp_pre(1:length(dN_pre),:);
        end
        
        [C_pre,phi_pre,S12_pre,S1_pre,S2_pre,f_pre,zerosp_pre,confC_pre,phistd_pre,Cerr_pre]=coherencysegcpb(lfp_pre,dN_pre,win,params,1);
        ol = 49; % overlap between segments
        len = 50; %500; %length of segment
        l = len - ol;
        nfft = 128; %number of points in fft
        
        foo = C_pre;
        s = len/2 + 1; % The time point at which you are calculating the spectrum
        j = 1; %count
        nw = 5/2; % Time bandwidth prodcut for pmtm
        
        count=1;
        % This while loop performs the actual computation using pmtm
        while s < length(foo) - ol
            seg = foo(s-len/2:s+len/2);
            [Pxx(:,j), f] = pmtm(seg,nw,[],round(Fs_lfp));
            j = j + 1;
            s = s + l; % create a new point every l ms ie. every 100ms
        end
         new_Pxx=mean(Pxx');
        
        C_pre1(i2,:)=new_Pxx;
        C_pre11(i2,:)=C_pre;
        
        temp=isnan(C_pre);
        [a b]=find(temp==1);
        
        c=unique(b);
        d=setdiff(1:size(C_pre,2),c);
        C_pre5=C_pre(:,d);
        C_pre6=mean(C_pre5,2);
        
        
        
    end
end

figure;
subplot(211)
imagesc(C_pre1)
subplot(212)
imagesc(C_pre11)
% subplot(413)

plot_coh_evolve(C_pre11)
Output1=C_pre1;
Output2=C_pre11;








