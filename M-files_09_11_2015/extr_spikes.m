clear all;
chs = [1,2,3,4,5,6,7,8];
ch_c = 0;
c_mun=0;
c_sun=0;
for ch = chs
    clear s* m* u*
    %matfile = strcat ('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\TT12D1Ch ',num2str(ch),'.mat');
    matfile = ['E:\T29_SS\Day2\T39D1B1Tet' num2str(ch) '.mat'];
    load (matfile,'spikes');
    unidx=spikes.labels;
    suc=1;
    muc=1;
    su=[];
    mu=[];
    
    for i = 1:size(unidx,1)
        if unidx(i,2)==2
            su(suc)=unidx(i,1);
            suc=suc+1;
        elseif unidx(i,2)==3
            mu(muc)=unidx(i,1);
            muc=muc+1;
        end
    end
    
    if ~isempty(su)
        for i = 1:length(su)
            c_sun=c_sun+1;
            tsind=get_spike_indices(spikes,su(i));
            all_singleunits(c_sun).ts=spikes.spiketimes(tsind);
            all_singleunits(c_sun).wf=reshape(spikes.waveforms(tsind,:,:),[length(tsind) 26*4]);
            all_singleunits(c_sun).ch = ch;
        end
    end
    
    if ~isempty(mu)
        for i = 1:length(mu)
            c_mun=c_mun+1;
            tsind2=get_spike_indices(spikes,mu(i))
            all_multiunits(c_mun).ts=spikes.spiketimes(tsind2);
            
            all_multiunits(c_mun).ch = ch;
        end
    end
    clear spikes;
end
save D2B1.mat all_singleunits

%%
clear all;
chs = [1,2,3,4,5,6,7,8];
ch_c = 0;
c_mun=0;
c_sun=0;
for ch = chs
    clear s* m* u*
    %matfile = strcat ('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\TT12D1Ch ',num2str(ch),'.mat');
    matfile = ['E:\T29_SS\Day2\T39D1B2Tet' num2str(ch) '.mat'];
    load (matfile,'spikes');
    unidx=spikes.labels;
    suc=1;
    muc=1;
    su=[];
    mu=[];
    
    for i = 1:size(unidx,1)
        if unidx(i,2)==2
            su(suc)=unidx(i,1);
            suc=suc+1;
        elseif unidx(i,2)==3
            mu(muc)=unidx(i,1);
            muc=muc+1;
        end
    end
    
    if ~isempty(su)
        for i = 1:length(su)
            c_sun=c_sun+1;
            tsind=get_spike_indices(spikes,su(i));
            all_singleunits(c_sun).ts=spikes.spiketimes(tsind);
            all_singleunits(c_sun).wf=reshape(spikes.waveforms(tsind,:,:),[length(tsind) 26*4]);
            all_singleunits(c_sun).ch = ch;
        end
    end
    
    if ~isempty(mu)
        for i = 1:length(mu)
            c_mun=c_mun+1;
            tsind2=get_spike_indices(spikes,mu(i))
            all_multiunits(c_mun).ts=spikes.spiketimes(tsind2);
            
            all_multiunits(c_mun).ch = ch;
        end
    end
    clear spikes;
end
save D2B2.mat all_singleunits