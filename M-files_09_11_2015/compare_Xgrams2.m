function [Output]=compare_Xgrams2(TimeStamps,Fs_lfp)
Fs_SPK=24413;

for pr = [1,9,17,25,33,41,49,57];
close all;
    for sc = 2:3
        for sc2 = 2:3
            for i = pr:pr+6
                for j = i+1:pr+7
                    close all;
                    TS1_s1 = TimeStamps{i,sc};
                    TS2_s1 = TimeStamps{j,sc2};
                    if (length(TS1_s1)>100 & length(TS2_s1>100))
                                                
                        [tsOffsets_pre, ts1idx_pre, ts2idx_pre] = crosscorrelogram(TS1_s1, TS2_s1,[-0.1 0.1])
                        
                        figure(i)
                        hist(tsOffsets_pre, 35)
                        h = findobj(gca,'Type','patch');
                        set(h,'FaceColor','c','EdgeColor','b')
                        a1=axis;
                        set(gca,'XTick',[-0.025  0  0.025]);%'XTickLabel',{'-0.025','0','0.025'}
                        set(gca,'FontSize',14,'FontWeight','BOLD');
                        
                        t=[num2str(i) ' XCorr to ' num2str(j)];
                        title(t,'FontSize',14,'FontWeight','BOLD')
                        set(gcf, 'Position', get(0,'Screensize'));
                        filename= ['C:\Users\dhaks_000\Documents\MATLAB\Dhakshin\Mat_files\raw_data\Reach\T28\Day1_Xcorr\Chs' num2str(i) num2str(j) 'SC' num2str(sc) num2str(sc2) 'SWSXgram.tiff'];
                        if(~exist(fileparts(filename)))
                            mkdir(fileparts(filename));
                        end
                        saveas(gcf,filename);
                        
                    end
                end
            end
        end
    end
end

