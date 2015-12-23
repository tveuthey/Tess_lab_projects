clear pmd nmd
for i = 1:length(peth)
    if ~isempty(peth(i).fit)
    bl = mean(peth(i).fit.mean(1:20));
    pmd(i) = max(peth(i).fit.mean(60:90))/bl;
    nmd(i) = min(peth(i).fit.mean(60:90))/bl;
    end
end

pmd=pmd';
nmd=nmd';

%%
% trptrp = 
% trntrn =
% trptrn = 
% trtu = 
% tutu =
clear all
load('C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T34\TaskD1Block2\peth_reachtrialsonly_centeredtograsp.mat');
tmptrp=trp;
tu=find(tmptrp==0);
trp=find(trp~=0);
trn=find(trn~=0);
load('E:\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T34\D3Sleep1spD3Sleep2sp\SSC.mat');
trp=unit_all;
 trp(trp>61)=[];
 trn(trn>61)=[];
 tu(tu>61)=[];
%%
count=0;
for i = 1:35
    for j = 2:36
    count=count+1;
    trptrpsws(count,1)=PChange_sws((i),(j));
    end
end

PC_spindle = ((spindle_postmean-spindle_premean)./spindle_premean)*100;

count=0;
for i = 1:35
    for j = 2:36
    count=count+1;
    trptrpsp(count,1)=PC_spindle((i),(j));
    end
end

%%
count=0;
for i = 1:length(trn)-1
    for j = i+1:length(trn)

    count=count+1;
    trntrnsws(count,1)=PChange_sws(trn(i),trn(j));
    end
end

count=0;
for i = 1:length(trp)-1
    for j = i+1:length(trp)
    count=count+1;
    trptrpsws(count,1)=PChange_sws(trp(i),trp(j));
    end
end

count=0;
for i = 1:length(tu)-1
    for j = i+1:length(tu)
    count=count+1;
    tutusws(count,1)=PChange_sws(tu(i),tu(j));
    end
end

count=0;
for i = 1:length(trp)
    for j = 1:length(tu)
    count=count+1;
    x = min(trp(i),tu(j));
    y = max(trp(i),tu(j));
    trptusws(count,1)=PChange_sws(x,y);
    end
end

count=0;
for i = 1:length(trp)
    for j = 1:length(trn)
    count=count+1;
    x = min(trp(i),trn(j));
    y = max(trp(i),trn(j));
    trptrnsws(count,1)=PChange_sws(x,y);
    end
end

count=0;
for i = 1:length(trn)
    for j = 1:length(tu)
    count=count+1;
    x = min(trn(i),tu(j));
    y = max(trn(i),tu(j));
    trntusws(count,1)=PChange_sws(x,y);
    end
end

trptrpsws(trptrpsws==0)=[];
trptrpsp(isnan(trptrpsp))=[];

%length(trptrp)+length(trptu)+length(tutu)+length(trntrn)+length(trptrn) +length(trntu)

%%
PC_spindle = ((spindle_postmean-spindle_premean)./spindle_premean)*100;

count=0;
for i = 1:length(trn)-1
    for j = i+1:length(trn)
    count=count+1;
    trntrnsp(count,1)=PC_spindle(trn(i),trn(j));
    end
end

count=0;
for i = 1:length(trp)-1
    for j = i+1:length(trp)
    count=count+1;
    trptrpsp(count,1)=PC_spindle(trp(i),trp(j));
    end
end

count=0;
for i = 1:length(tu)-1
    for j = i+1:length(tu)
    count=count+1;
    tutusp(count,1)=PC_spindle(tu(i),tu(j));
    end
end

count=0;
for i = 1:length(trp)
    for j = 1:length(tu)
    count=count+1;
    x = min(trp(i),tu(j));
    y = max(trp(i),tu(j));
    trptusp(count,1)=PC_spindle(x,y);
    end
end

count=0;
for i = 1:length(trp)
    for j = 1:length(trn)
    count=count+1;
    x = min(trp(i),trn(j));
    y = max(trp(i),trn(j));
    trptrnsp(count,1)=PC_spindle(x,y);
    end
end

count=0;
for i = 1:length(trn)
    for j = 1:length(tu)
    count=count+1;
    x = min(trn(i),tu(j));
    y = max(trn(i),tu(j));
    trntusp(count,1)=PC_spindle(trn(i),tu(j));
    end
end

trptrpsws(trptrpsws==0)=[];
trptrpsp(isnan(trptrpsp))=[];

trntrnsws(trntrnsws==0)=[];
trntrnsp(isnan(trntrnsp))=[];

tutusws(tutusws==0)=[];
tutusp(isnan(tutusp))=[];

trptrnsws(trptrnsws==0)=[];
trptrnsp(isnan(trptrnsp))=[];

trptusws(trptusws==0)=[];
trptusp(isnan(trptusp))=[];

trptrnsws(trptrnsws==0)=[];
trptrnsp(isnan(trptrnsp))=[];


save Spkspk.mat
%length(trptrp)+length(trptu)+length(tutu)+length(trntrn)+length(trptrn) +length(trntu)

