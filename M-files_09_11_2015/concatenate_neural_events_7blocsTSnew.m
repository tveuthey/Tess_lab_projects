%function [new]=concatenate_neural_events_2blocs(Block_1,Block_2)
clear all;
Block_1 = 'data_block_DemoTank2_Block-312.mat';
Block_2='data_block_DemoTank2_Block-313.mat';
Block_3='data_block_DemoTank2_Block-315.mat';
Block_4='data_block_DemoTank2_Block-316.mat';
Block_5='data_block_DemoTank2_Block-317.mat';
Block_6='data_block_DemoTank2_Block-318.mat';
Block_7='data_block_DemoTank2_Block-320.mat';

close all;
Blocka=num2str(Block_1);
Blockb=num2str(Block_2);
Blockc=num2str(Block_3);
Blockd=num2str(Block_4);
Blocke=num2str(Block_5);
Blockf=num2str(Block_6);
Blockg=num2str(Block_7);


cd('D:\Users\zeiss\Documents\T70data\')
a=load(Blocka);
b=load(Blockb);
c=load(Blockc);
d=load(Blockd);
e=load(Blocke);
f=load(Blockf); 
g=load(Blockg); 

% getting data out of two struct arrays
%data_x=x.data;
% N_x=x.N;
% TimeStamps_x=x.TimeStamps;
% Waves_x=x.Waves;
% Fs_lfp_x=x.Fs_lfp;
% wave_x=x.wave;
% data_x=x.data;

%data_y=y.data;
% N_y=y.N;
% TimeStamps_y=y.TimeStamps;
% Waves_y=y.Waves;
% Fs_lfp_y=y.Fs_lfp;
% wave_y=y.wave;

new(1).Fs_lfp=x.Fs_lfp;
[r c]=size(x.N);
time_add=length(x.data)/x.Fs_lfp;
time_add2=(length(y.data)/x.Fs_lfp)+time_add;

for j=1:c
    for i=1:r
        %if isnan(a.TimeStamps{i,j})    isempty (b(1).TimeStamps{i,j})==1 %&& isempty (z1(1).TimeStamps{i,j})==1&& isempty (z2(1).TimeStamps{i,j})==1
        %  if isnan(y.TimeStamps{i,j})
        new.TimeStamps{i,j}=[NaN];
        new.Waves{i,j}=[NaN];
        new.N{i,j}=[NaN];
        % else
        new.TimeStamps{i,j}=[y.TimeStamps{i,j}+time_add];
        new.Waves{i,j}=[y.Waves{i,j}];
        new.N{i,j}=[NaN];
        %end
        
        %else
            if isnan(y.TimeStamps{i,j})
                new.TimeStamps{i,j}=[x.TimeStamps{i,j}];
                new.Waves{i,j}=[y.Waves{i,j}];
                new.N{i,j}=[NaN];
            else
                
                new.TimeStamps{i,j}=[x(1).TimeStamps{i,j} y.TimeStamps{i,j}+time_add ];%z.TimeStamps{i,j}+time_add2];% z1.TimeStamps{i,j}+time_add3 z2.TimeStamps{i,j}+time_add4];
                new.Waves{i,j}=[x(1).Waves{i,j} y.Waves{i,j}];
                new.N{i,j}=[x(1).N{i,j}+y.N{i,j}];%+z.N{i,j}];%+z1.N{i,j}+z2.N{i,j}];
            end
    end
end
%
%     for i=1:32
%         new.data(i,:)=[x(1).data(i,:) y.data(i,:) ];
%         new.SpkData(i,:)=[x.SpkData(i,:) y.SpkData(i,:) ];  
%     end
%   new.data = [x.data; y.data];
% new.SpkData=[x.SpkData;y.SpkData];  
% 
% new(1).wave=[x(1).wave(1,:) y.wave(1,:) ];

%data=new.data;
% Fs_lfp=new.Fs_lfp;
Waves=new.Waves;
% N=new.N;
% TimeStamps=new.TimeStamps;
% wave=new.wave;
% SpkData = new.SpkData;
%subplot(2,1,1);plot(wave)
%subplot(2,1,2);plot(data(1,:))


fname = strcat('data_block_T12_CatW',Blockx,Blocky);
cd ('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T39')
%save (fname, 'Waves','Fs_lfp' ,'wave', 'TimeStamps', 'N', 'data', 'SpkData')
save (fname, 'Waves','-v7.3')




