function [Output]=compare_Xgrams(TimeStamps,sleep_ind_pre,Fs_lfp)
Fs_SPK=24413;
close all;

for pr = [1,9,17,25,33,41,49,57];
    for sc = 2:3
        for sc2 = 2:3
            for i = pr:pr+6
                for j = pr+1:pr+7
                    TS1 = TimeStamps{i,sc};
                    TS2 = TimeStamps{j,sc2};
                    if (~isnan(TS1(1)) & ~isnan(TS2(1)))
                        l1=size(sleep_ind_pre,1);
                        clear TS10_s1 TS10_s2 TS1_s1 TS1_s2
                        TS2_s1=[];
                        TS1_s1=[];
                        for n=1:size(sleep_ind_pre,1)
                            %     clear TS10_s1
                            sws1=round([(sleep_ind_pre(n,1):sleep_ind_pre(n,2))/Fs_lfp]);
                            
                            s_ts=find(TS2>sws1(1));
                            e_ts=find(TS2<sws1(end));
                            ts=intersect(s_ts,e_ts);
                            TS2_s1=[TS2_s1 TS2(ts)];
                            
                            s_ts1=find(TS1>sws1(1));
                            e_ts1=find(TS1<sws1(end));
                            ts1=intersect(s_ts1,e_ts1);
                            TS1_s1=[TS1_s1 TS1(ts1)];
                        end
                        if(isempty(TS1_s1))
                            break;
                        end
                                                
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

Output=[length(TS1_s1) length(TS10_s1)];