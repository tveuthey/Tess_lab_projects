%%

close all; clear all; clc;
%{'Block-15','Block-16','Block-17','Block-25','Block-26','Block-27','Block-28','Block-31','Block-32'...
Blocks = [339]
%Blocks = [49,54,55,56,57,58,59,60,61,63,64];
%Block_Names = {'Block-767','Block-768'}
% ','Block-6','Block-7','Block-8'}
%Block_Names = {'Block-15','Block-16','Block-17','Block-25','Block-26','Block-27','Block-28','Block-31','Block-32'};

for i = 1:length(Blocks)
    clearvars -except i Blocks;
    close all;
    clc;   
    len_chs = 16;
    TankName='DEMOTANK2';
    Block_Name=strcat('Block-',num2str(Blocks(i)));
    SortID='TankSort';
    filename='data_spikes_lfps_wav_';
    
    cd 'C:\TDT\OpenEx\Tanks\DemoTank2\';
    %data = TDT2mat(TankName, Block_Name);
    %Activate Tank DLL
    TTX = actxcontrol('TTank.X');
    servername = 'Local';
    clientname = 'Me';
    if TTX.ConnectServer(servername, clientname)~=1
        disp 'Server Error';
    end
    if TTX.OpenTank (TankName, 'R')~=1;
        disp 'Tank Error';
    end
    if TTX.SelectBlock(Block_Name)~=1;
        disp 'Block Error';
    end
    
    disp('Tank and Block Selected -----------------------------------')
    %

    %Read All Spikes
    eventnumber=10000000;
%
    for chan_no=1:16
        TTX.SetUseSortName(SortID);
        for i = 1
            TTX.ResetFilters
            TTX.SetGlobalV('WavesMemLimit',1024^3);
          %  TTX.SetFilterWithDescEx(['SORT=' num2str(i)]);
            N{chan_no,i+1} = TTX.ReadEventsV(eventnumber, 'eTet', chan_no, 0, 0.0, 0.0, 'FILTERED');
            disp([chan_no])
            disp([])
            if N{chan_no,i+1}>0
            TimeStamps{chan_no,i+1}=TTX.ParseEvInfoV(0, N{chan_no,i+1}, 6);
            Waves{chan_no,i+1}=TTX.ParseEvV(0, N{chan_no,i+1});
            Sorts{chan_no,i+1}=TTX.ParseEvInfoV(0, N{chan_no,i+1}, 5);
            Fs_eNeu=TTX.ParseEvInfoV(0, 0, 9);
            end
        end
    end
 
    TTX.ParseEvInfoV(0, 0, 1)   % determines channel sample freq% get the IO data from lafayetter
    TTX.SetGlobalV('Channel',10) %determine size of channnel data
    temp3=TTX.ReadWavesV('LFPs');
    size(temp3)
     Fs_lfp = TTX.ParseEvInfoV(0, 0, 9)   % determines channel sample freq

%     size_lfp=length(temp3);

    for chan_no = 1:64
        TTX.ResetFilters
        TTX.SetGlobalV('WavesMemLimit',1024^3);
        TTX.SetGlobalV('Channel',chan_no);
        tmpspkdata=TTX.ReadWavesV('pTet');
        tmpspkdata(tmpspkdata>600)=mean(tmpspkdata);
        tmpspkdata(tmpspkdata<-600)=mean(tmpspkdata);
        SpkData(:,chan_no)=tmpspkdata;
    end
        
    dec_factor=1;
    Fs_lfp=Fs_lfp/dec_factor;
    for chan_no=1:32
        disp(chan_no)
        TTX.SetGlobalV('Channel',chan_no);
        temp=TTX.ReadWavesV('LFPs');
        temp=double(temp);
        data(chan_no,:)=temp;
        disp ([chan_no])
    end
    TTX.ParseEvInfoV(0, 0, 1)   % determines channel sample freq% get the IO data from lafayetter
    TTX.SetGlobalV('Channel',1) %determine size of channnel data
    temp3=TTX.ReadWavesV('Wave');
%     size(temp3)
    Fs_wave = TTX.ParseEvInfoV(0, 0, 9)   % determines channel sample freq
    %size_lfp=TTX.ParseEvInfoV(0, 0, 1)   % determines channel size
    size_lfp=length(temp3);
    dec_factor=1;
    Fs_wave=Fs_wave/dec_factor;
    for chan_no=1
        disp(chan_no)
        %get_chan=chan(chan_no);
        TTX.SetGlobalV('Channel',chan_no);
        temp=TTX.ReadWavesV('Waves');
        temp=double(temp);
        wave(chan_no,:)=decimate(temp,dec_factor);
        disp ([chan_no])
    end
    
    
    TTX.CloseTank
    TTX.ReleaseServer
    close all
    
    %saving raw data
    outdir = 'D:\Users\zeiss\Documents\T74data\';
    if (~exist(outdir))
        mkdir(outdir);
    end
    cd (outdir)
    save (['data_block_' TankName '_' Block_Name],'-v7.3')
end
