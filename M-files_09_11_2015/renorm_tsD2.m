clear all
blocks=([0,3322216,4380506])/1017.2526245;
BlockName = {'Sleep1','TaskB1'};
for i = 1:8
filename = 'D2B1.mat';
load (filename);

for j = 1:length(blocks)-1
        t(1)=sum(blocks(1:j));
        t(2)=sum(blocks(1:j+1));
    for i = 1:length(units)
        tsnew(i).ts = units(i).ts(units(i).ts>t(1) & units(i).ts<t(2));
%         subplot(211); plot(tsnew(i).ts);
%         tsnew(i).ts = tsnew(i).ts - t(1);
%         subplot(212); plot(tsnew(i).ts);
%         pause;
        %plot(tsnew(i).ts); pause;
    end
    eval(['TSB' BlockName{j} '=tsnew']);
end
save Day2_TS.mat TSB*