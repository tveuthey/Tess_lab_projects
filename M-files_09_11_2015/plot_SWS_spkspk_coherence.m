function plot_SWS_spkspk_coherence(TimeStamps1,TimeStamps2,time_pre,time_post,units,units2,units3, sc, bin, Fs_lfp, taper, win,dir)
figure
close all; 

params.Fs=Fs_lfp/bin;
params.fpass=[0 20];
params.tapers=[taper(1) taper(2)];
params.trialave=1;
params.pad=0;
params.err=[2 0.05];
count=0;

for i=1:length(units)+length(units2)+length(units3)
    if i <= length(units)
        unit1=units(i);
        ts1pre=TimeStamps1{unit1,2}*Fs_lfp;
        ts1post=TimeStamps2{unit1,2}*Fs_lfp;
        unit2 = unit1+.1;
    elseif i<=length(units)+length(units2)
        unit1=units2(i-length(units));
        ts1pre=TimeStamps1{unit1,3}*Fs_lfp;
        ts1post=TimeStamps2{unit1,3}*Fs_lfp;
        unit2 = unit1+.2;
    elseif i<=length(units)+length(units2)+length(units3)
        unit1=units3(i-(length(units)+length(units2)));
        
        ts1pre=TimeStamps1{unit1,4}*Fs_lfp;
        ts1post=TimeStamps2{unit1,4}*Fs_lfp;
        unit2 = unit1+.3;
    end
    
    dN_pre1 = [];
    dN_post1=[];
    
    for j = 1:length(time_pre)
        ts1atmp = ts1pre(ts1pre>time_pre(j,1) & ts1pre<time_pre(j,2));
        ts1atmp2=(ts1atmp-time_pre(j,1))/Fs_lfp;
        [dN_tmp1,~]=binspikes(ts1atmp2,1017,[0 (time_pre(j,2)-time_pre(j,1))/1017]);
        dN_pre1 = [dN_pre1; dN_tmp1];
    end
    
    for j = 1:length(time_post)
        ts1atmp = ts1post(ts1post>time_post(j,1) & ts1post<time_post(j,2));
        ts1atmp2=(ts1atmp-time_post(j,1))/Fs_lfp;
        [dN_tmp1,~]=binspikes(ts1atmp2,1017,[0 (time_post(j,2)-time_post(j,1))/1017]);
        dN_post1 = [dN_post1; dN_tmp1];
    end
    
    if length(dN_pre1)>length(dN_post1)
        dN_pre1=dN_pre1(1:length(dN_post1));
    else
        dN_post1=dN_post1(1:length(dN_pre1));
    end
    
    ts1pre = find(dN_pre1);
    ts1post=find(dN_post1);
    count=count+1;
    Spre(count).spikes= ts1pre;
    Spost(count).spikes= ts1post;
    unit_all(count)=(unit2);
end

clear ts* dN*
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%spk-field coherence analysis
for i = 1:size(Spre,2)-1
    sp1pre = Spre(i).spikes;
    sp1post = Spost(i).spikes;
    for j = i+1:size(Spre,2)
        sp2pre = Spre(j).spikes;
        sp2post = Spost(j).spikes;
        
        if ((numel(sp1pre)>25) && numel(sp2pre)>25 && numel(sp1post)>25 && numel(sp2post)>25)
            
            if numel(sp1post)>numel(sp1pre)
                temp_ind=randperm(length(sp1post));
                sp1post=sort(sp1post(temp_ind(1:length(sp1pre))));
                %ts1_pre=ts1_pre;
            else
                temp_ind=randperm(length(sp1pre));
                sp1pre=sort(sp1pre(temp_ind(1:length(sp1post))));
            end
            
            if numel(sp2post)>numel(sp2pre)
                temp_ind=randperm(length(sp2post));
                sp2post=sort(sp2post(temp_ind(1:length(sp2pre))));
            else
                temp_ind=randperm(length(sp2pre));
                sp2pre=sort(sp2pre(temp_ind(1:length(sp2post))));
             end
            
            end_pre = max([sp1pre(end),sp2pre(end)]);
            end_post = max([sp1post(end),sp2post(end)]);
            
            segave =1;
            spkdata_pre1.times = (sp1pre/Fs_lfp);
            spkdata_post1.times = (sp1post/Fs_lfp);       
            spkdata_pre2.times = (sp2pre/Fs_lfp);
            spkdata_post2.times = (sp2post/Fs_lfp);
            [C_pre,phi_pre,~,S1_pre,S2_pre,f_pre,zerosp_pre,confC_pre,phistd_pre,Cerr_pre]=coherencysegpt(spkdata_pre1,spkdata_pre2,win,params,segave);
            [C_post,phi_post,~,S1_post,S2_post,f_post,zerosp_post,confC_post,phistd_post,Cerr_post]=coherencysegpt(spkdata_post1,spkdata_post2,win,params,segave);
          
            h = figure;cshadedErrorBar(f_pre(:),smooth(C_pre(:),20),cat(2,smooth(Cerr_pre(1,:),20),smooth(Cerr_pre(2,:),20))','b',1);
            hold on;
            cshadedErrorBar(f_post(:),smooth(C_post(:),20),cat(2,smooth(Cerr_post(1,:),20),smooth(Cerr_post(2,:),20)),'r',1);
            % shadedErrorBar(f_post_SP,smooth(C_post_SP,20),cat(2,smooth(Cerr_post_SP(1,:),20),smooth(Cerr_post_SP(2,:),20)),'g',1);
            axis auto;
            box off
            unc(i,j-1)=str2num(strcat(int2str(unit_all(i)),int2str(unit_all(j))));
            
            
            [x1 ind1]=find(f_pre<=1);
            [x2 ind2]=find(f_pre<4);
            [x3 ind3]=find(f_pre<10);
            [x4 ind4]=find(f_pre<15);
            
            c1 = mean(C_pre((ind1(end)+1):(ind2(end)-1)));
            sws_premax(i,j)=max(C_pre((ind1(end)+1):(ind2(end)-1)));
            sws_premean(i,j)=c1;
            c2 = mean(C_pre((ind3(end)+1):(ind4(end)-1)));
            
            spindle_premax(i,j)= max(C_pre((ind3(end)+1):(ind4(end)-1)));
            spindle_premean(i,j)=c2;
            phi_pre_sws(i,j)=mean(phi_pre((ind1(end)+1):(ind2(end)-1)));
            phi_pre_spindle(i,j)=mean(phi_pre((ind3(end)+1):(ind4(end)-1)));
            
            
%             [x1 ind1]=find(f_post=<1);
%             [x2 ind2]=find(f_post<4);
%             [x3 ind3]=find(f_post<10);
%             [x4 ind4]=find(f_post<15);
            
            c3=mean(C_post((ind1(end)+1):(ind2(end)-1)));
            sws_postmax(i,j)= max(C_post((ind1(end)+1):(ind2(end)-1)));
            sws_postmean(i,j)=c3;
            
            c4=mean(C_post((ind3(end)+1):(ind4(end)-1)));
            spindle_postmax(i,j)= max(C_post((ind3(end)+1):(ind4(end)-1)));
            spindle_postmean(i,j)=c4;
            phi_post_sws(i,j)=mean(phi_post((ind1(end)+1):(ind2(end)-1)));
            phi_post_spindle(i,j)=mean(phi_post((ind3(end)+1):(ind4(end)-1)));
            
            
            PChange_sws(i,j)=((c3-c1)/c1)*100;
            PChange_sws(j,i)=((c3-c1)/c1)*100;
            Change_sws(i,j)=c3-c1;
            Change_sws(j,i)=c3-c1;
            
            Change_spindle(i,j)=((c4-c2)/c2)*100;
            phi_change_sws(i,j)     = phi_post_sws(i,j)-phi_pre_sws(i,j);
            phi_change_spindle(i,j) = phi_post_spindle(i,j)-phi_pre_spindle(i,j);
            C_pre_all(i,j,:)=C_pre;
            C_post_all(i,j,:)=C_post;
            C_change(i,j,:)=C_post-C_pre;
            
            filename = strcat(dir,'SpkSpkCoh_Ch', int2str(unit_all(i)),'_Ch', int2str(unit_all(j)),'pt.tiff');
            saveas(gcf,filename);
            close all;
        end
    end
    
end
savefile = strcat(dir,'bin',num2str(bin),'SSCpt.mat');
save (savefile, 'PChange_sws','unit_all','unc','Change_sws', 'Change_spindle', 'sws_premax', 'sws_postmax', 'sws_premean', 'sws_postmean', 'spindle_premax', 'spindle_postmax', 'spindle_premean', 'spindle_postmean', 'phi_pre_sws', 'phi_pre_spindle', 'phi_post_sws', 'phi_post_spindle', 'C_pre_all','C_post_all', 'C_change');
%close all;

