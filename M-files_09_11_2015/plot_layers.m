function [Cells_Inc Cells_Dec]=plot_layers(Inc_Cells,Dec_Cells, Depth)
close all;
% Output1=num2str(Output_Results);
% Output=load(Output1);
Cell_Inc=[Inc_Cells];
i1=find(Cell_Inc<=32);
i2=find(Cell_Inc>32 & Cell_Inc<=64);
i3=find(Cell_Inc>64 & Cell_Inc<=96);
i4=find(Cell_Inc>96 & Cell_Inc<=128);
Cell_Inc1=[Cell_Inc(i1)];
Cell_Inc2=[Cell_Inc(i2)-32] ;
Cell_Inc3=[Cell_Inc(i3)-64] ;
Cell_Inc4=[Cell_Inc(i4)-96];

Cell_Dec=Dec_Cells;
d1=find(Cell_Dec<=32);
d2=find(Cell_Dec>32 & Cell_Dec<=64);
d3=find(Cell_Dec>64 & Cell_Dec<=96);
d4=find(Cell_Dec>96 & Cell_Dec<=128);
Cell_Dec1=[Cell_Dec(d1)];
Cell_Dec2=[Cell_Dec(d2)-32];
Cell_Dec3=[Cell_Dec(d3)-64];
Cell_Dec4=[Cell_Dec(d4)-96];


shank1=[1 8 2 3 6 4 5 7];
shank2=[9 16 10 15 11 14 12 13];
shank3=[17 24 18 23 19 22 20 21];
shank4=[25 32 26 31 27 30 28 29];

D=Depth-Depth;
y=[D D+2 D+4 D+6 D+8 D+10 D+12 D+14];

for j=1:8
    for i=1:length(Cell_Inc1)
        if ismember(Cell_Inc1(i),shank1(j))==1
            k=scatter(1,y(j),35,'g>','filled'); hold on
        else
            if ismember(Cell_Inc1(i),shank2(j))==1
                k=scatter(2,y(j),35,'g>','filled'); hold on
            else
                if ismember(Cell_Inc1(i),shank3(j))==1
                    k=scatter(3,y(j),35,'g>','filled'); hold on
                else
                    if ismember(Cell_Inc1(i),shank4(j))==1
                        k=scatter(4,y(j),35,'g>','filled'); hold on
                    else
                    end
                end
            end
        end
    end
    for i=1:length(Cell_Inc2)
        if ismember(Cell_Inc2(i),shank1(j))==1
            k=scatter(1.1,y(j),35,'g>','filled'); hold on
        else
            if ismember(Cell_Inc2(i),shank2(j))==1
                k=scatter(2.1,y(j),35,'g>','filled'); hold on
            else
                if ismember(Cell_Inc2(i),shank3(j))==1
                    k=scatter(3.1,y(j),35,'g>','filled'); hold on
                else
                    if ismember(Cell_Inc2(i),shank4(j))==1
                        k=scatter(4.1,y(j),35,'g>','filled'); hold on
                    else
                    end
                end
            end
        end
    end
    for i=1:length(Cell_Inc3)
        if ismember(Cell_Inc3(i),shank1(j))==1
            k=scatter(1.2,y(j),35,'g>','filled'); hold on
        else
            if ismember(Cell_Inc3(i),shank2(j))==1
                k=scatter(2.2,y(j),35,'g>','filled'); hold on
            else
                if ismember(Cell_Inc3(i),shank3(j))==1
                    k=scatter(3.2,y(j),35,'g>','filled'); hold on
                else
                    if ismember(Cell_Inc3(i),shank4(j))==1
                        k=scatter(4.2,y(j),35,'g>','filled'); hold on
                    else
                    end
                end
            end
        end
    end
    for i=1:length(Cell_Inc4)
        if ismember(Cell_Inc4(i),shank1(j))==1
            k=scatter(1.3,y(j),35,'g>','filled'); hold on
        else
            if ismember(Cell_Inc4(i),shank2(j))==1
                k=scatter(2.3,y(j),35,'g>','filled'); hold on
            else
                if ismember(Cell_Inc4(i),shank3(j))==1
                    k=scatter(3.3,y(j),35,'g>','filled'); hold on
                else
                    if ismember(Cell_Inc4(i),shank4(j))==1
                        k=scatter(4.3,y(j),35,'g>','filled'); hold on
                    else
                    end
                end
            end
        end
    end
end
for j=1:8
    for i=1:length(Cell_Dec1)
        if ismember(Cell_Dec1(i),shank1(j))==1
            h=scatter(1,y(j),25,'r*'); hold on
        else
            if ismember(Cell_Dec1(i),shank2(j))==1
                h=scatter(2,y(j),25,'r*'); hold on
            else
                if ismember(Cell_Dec1(i),shank3(j))==1
                    h=scatter(3,y(j),25,'r*'); hold on
                else
                    if ismember(Cell_Dec1(i),shank4(j))==1
                        h=scatter(4,y(j),25,'r*'); hold on
                    else
                    end
                end
            end
        end
    end
    for i=1:length(Cell_Dec2)
        if ismember(Cell_Dec2(i),shank1(j))==1
            h=scatter(1.1,y(j),25,'r*'); hold on
        else
            if ismember(Cell_Dec2(i),shank2(j))==1
                h=scatter(2.1,y(j),25,'r*'); hold on
            else
                if ismember(Cell_Dec2(i),shank3(j))==1
                    h=scatter(3.1,y(j),25,'r*'); hold on
                else
                    if ismember(Cell_Dec2(i),shank4(j))==1
                        h=scatter(4.1,y(j),25,'r*'); hold on
                    else
                    end
                end
            end
        end
    end
    for i=1:length(Cell_Dec3)
        if ismember(Cell_Dec3(i),shank1(j))==1
            h=scatter(1.2,y(j),25,'r*'); hold on
        else
            if ismember(Cell_Dec3(i),shank2(j))==1
                h=scatter(2.2,y(j),25,'r*'); hold on
            else
                if ismember(Cell_Dec3(i),shank3(j))==1
                    h=scatter(3.2,y(j),25,'r*'); hold on
                else
                    if ismember(Cell_Dec3(i),shank4(j))==1
                        h=scatter(4.2,y(j),25,'r*'); hold on
                    else
                    end
                end
            end
        end
    end
    for i=1:length(Cell_Dec4)
        if ismember(Cell_Dec4(i),shank1(j))==1
            h=scatter(1.3,y(j),25,'r*'); hold on
        else
            if ismember(Cell_Dec4(i),shank2(j))==1
                h=scatter(2.3,y(j),25,'r*'); hold on
            else
                if ismember(Cell_Dec4(i),shank3(j))==1
                    h=scatter(3.3,y(j),25,'r*'); hold on
                else
                    if ismember(Cell_Dec4(i),shank4(j))==1
                        h=scatter(4.3,y(j),25,'r*'); hold on
                    else
                    end
                end
            end
        end
    end
end
axis([0.5 4.5 -0.5 14.5]);set(gca,'YTick',[0 14], 'XTick',[1 2 3 4])
D2=Depth-200;set(gca,'YTickLabel',[num2str(Depth);num2str(D2)])%;num2str(Depth-400);num2str(Depth-600)])%;num2str(Depth-800);num2str(Depth-1000);num2str(Depth-1200)])
set(gca, 'XTickLabel','Shank_1|Shank_2|Shank_3|Shank_4')
ylabel('Deep Layers ===> Superficial Layers (um)')
set(gca,'XGrid','on')
legend([k,h],'Inc','Dec', 'Location','NorthEastOutside')

title('T1/+50PMK' )
cd('C:\Users\Ganguly Lab\Documents\MATLAB\Tanuj/Mat_files/Result_figs/New (Acute_Neuromod_I)/Layermap')

filename=['T1_LayerMap.tiff'];%C:\Users\Ganguly Lab\Documents\MATLAB\Tanuj\Mat_files\Result_figs\New (Acute_Neuromod_I)\S33
saveas(gcf,filename);
cd('C:\Users\Ganguly Lab\Documents\MATLAB\Tanuj\Mat_files\data_pull\New (Acute_Neuromod_I)')






Cells_Inc=[Cell_Inc1 Cell_Inc2 Cell_Inc3 Cell_Inc4];
Cells_Dec=[Cell_Dec1 Cell_Dec2 Cell_Dec3 Cell_Dec4];