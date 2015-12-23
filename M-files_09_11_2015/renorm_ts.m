clear all
%blocks=([0,3684412,1565157,4601255,4472471,4362452])/1017.2526245;
blocks=([0,1772979,1945719,2271809,4017920,3577963])/1017.2526245;
BlockName = {'Sleep1','TaskB1a','TaskB1b','Sleep2','TaskB2'};
%BlockName = {'Sleep1','TaskB1','TaskB1b','Sleep2','TaskB2'};
load ('E:\T29_SS\Day3\Day3.mat');
units = all_singleunits;
for j = 1:length(blocks)-1
        t(1)=sum(blocks(1:j));
        t(2)=sum(blocks(1:j+1));
    for i = 1:length(units)
        tsnew(i).ts = units(i).ts(units(i).ts>t(1) & units(i).ts<t(2));
        subplot(211); plot(tsnew(i).ts);
        tsnew(i).ts = tsnew(i).ts - t(1);
        subplot(212); plot(tsnew(i).ts);
        pause;
        %plot(tsnew(i).ts); pause;
    end
    eval(['TSB' BlockName{j} '=tsnew']);
end
%%
% blocks=([0,5914077,3923516])/1017.2526245;
% BlockName = {'Sleep2','TaskB2'};
% 
% %BlockName = {'Sleep1','TaskB1','TaskB1b','Sleep2','TaskB2'};
% load ('E:\T29_SS\Day3\Day3.mat');
% units = all_singleunits;
% for j = 1:length(blocks)-1
%         t(1)=sum(blocks(1:j));
%         t(2)=sum(blocks(1:j+1));
%     for i = 1:length(units)
%         tsnew(i).ts = units(i).ts(units(i).ts>t(1) & units(i).ts<t(2));
%         subplot(211); plot(tsnew(i).ts);
%         tsnew(i).ts = tsnew(i).ts - t(1);
%         subplot(212); plot(tsnew(i).ts);
%         pause;
%         %plot(tsnew(i).ts); pause;
%     end
%     eval(['TSB' BlockName{j} '=tsnew']);
% end
% 
%%
save Day3_TS.mat TSB*