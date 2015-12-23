function [new]=concatenate_neural_events_7blocsTS(Block_1,Block_2, Block_3, Block_4,Block_5,Block_6,Block_7)

close all;
Blockx=num2str(Block_1);
Blocky=num2str(Block_2);
Blockz=num2str(Block_3);
Blockz1=num2str(Block_4);
Blockz2=num2str(Block_5);
%Blockz3=num2str(Block_6);
%Blockz4=num2str(Block_7);


cd('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T39')
x=load(Blockx);
y=load(Blocky);
z=load(Blockz);
z1=load(Blockz1);
z2=load(Blockz2);
%z3=load(Blockz3);
%z4=load(Blockz4);

% getting data out of two struct arrays
% SpkData_x=x.SpkData;
% TimeStamps_x=x.TimeStamps;
% Waves_x=x.Waves;
Fs_lfp_x=1017.2526245;
% 
% SpkData_y=y.SpkData;
% TimeStamps_y=y.TimeStamps;
% Waves_y=y.Waves;

new.Fs_lfp=Fs_lfp_x;
[r c]=size(x.N);

 time_add=1772979/Fs_lfp_x;
 time_add2=(1945719/Fs_lfp_x)+time_add;
 time_add3=(2271809/Fs_lfp_x)+time_add2;
 time_add4=(4017920/Fs_lfp_x)+time_add3;
%time_add5=(4362452/Fs_lfp_x)+time_add4;
%time_add6=(length(z3.data)/Fs_lfp_x)+time_add5;



% time_add=length(x.data)/Fs_lfp_x;
% time_add2=(length(y.data)/Fs_lfp_x)+time_add;
% time_add3=(length(z.data)/Fs_lfp_x)+time_add2;
% time_add4=(length(z1.data)/Fs_lfp_x)+time_add3;
% time_add5=(length(z2.data)/Fs_lfp_x)+time_add4;
% time_add6=(length(z3.data)/Fs_lfp_x)+time_add5;

for j=2:c
    for i=1:r
        if (isnan(x.TimeStamps{i,j}(1)) || isnan (y.TimeStamps{i,j}(1)) || isnan (z.TimeStamps{i,j}(1)) || isnan (z1.TimeStamps{i,j}(1)) || isnan (z2.TimeStamps{i,j}(1)))% || isnan (z3.TimeStamps{i,j}(1)))
            new(1).TimeStamps{i,j}=[NaN];
            new(1).Waves{i,j}=[NaN];
        else
            new(1).TimeStamps{i,j}=[x.TimeStamps{i,j} y.TimeStamps{i,j}+time_add z.TimeStamps{i,j}+time_add2 z1.TimeStamps{i,j}+time_add3 z2.TimeStamps{i,j}+time_add4];% z3.TimeStamps{i,j}+time_add5 z4.TimeStamps{i,j}+time_add6];
            new(1).Waves{i,j}=[x.Waves{i,j} y.Waves{i,j} z.Waves{i,j} z1.Waves{i,j} z2.Waves{i,j}];% z3.Waves{i,j} z4.Waves{i,j}];  
        end
    end
end

for j=1
    for i=1:32
        new.SpkData(i,:)=[x(1).SpkData(:,i); y.SpkData(:,i); z.SpkData(:,i); z1.SpkData(:,i); z2.SpkData(:,i)];% z3.SpkData(i,:)];% z4.SpkData(i,:)];
        new.SpkData(i,:)=[x(1).SpkData(:,i); y.SpkData(:,i); z.SpkData(:,i); z1.SpkData(:,i); z2.SpkData(:,i)];% z3.SpkData(i,:)];% z4.SpkData(i,:)];
    end
end
SpkData=new.SpkData';
 Fs_lfp=new.Fs_lfp;
 TimeStamps=new.TimeStamps;
 Waves = new.Waves;

fname = 'C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T39\data_block_T39_Cat_D3_allblocksTSonly.mat';
save (fname, 'Fs_lfp','Waves','TimeStamps', 'SpkData','-v7.3')
%save (fname, 'SpkData','-v7.3','-append')

