%%
function [B1earlypeak,B1latepeak,B2earlypeak]=extractpeaks(pethB1,pethB2)

for i = 1:length(pethB1)
    if ~isempty(pethB1(i).fit)&&~isempty(pethB2(i).fit)   
    bl1 = mean(pethB1(i).fitearly.mean(:));
    bl2 = mean(pethB1(i).fitlate.mean(:));
    bl3 = mean(pethB2(i).fitearly.mean(:));
    sd1 = std(pethB1(i).fitearly.mean(:));
    sd2 = std(pethB1(i).fitlate.mean(:));
    sd3 = std(pethB2(i).fitearly.mean(:));
    
%     B1tmp =  (pethB1(i).fitearly.mean-bl1)/sd1;
%     B2tmp =  (pethB1(i).fitlate.mean-bl2)/sd2;
%     B3tmp =  (pethB2(i).fitearly.mean-bl3)/sd3;
%     
    B1tmp =  zscore(pethB1(i).fitearly.mean);
    B2tmp =  zscore(pethB1(i).fitlate.mean);
    B3tmp =  zscore(pethB2(i).fitearly.mean);
%   
    [~,B1erl]=sort(B1tmp,'descend');
    [~,B1late]=sort(B2tmp,'descend');
    [~,B2erl]=sort(B3tmp,'descend');
plot(B1tmp,'r'); title(num2str(B1erl(1))); hold on;
plot(B2tmp,'b'); title(num2str(B1late(1)));
plot(B3tmp,'g'); title(num2str(B2erl(1)));
pause;
close all;
    B1earlypeak(i,1)=B1erl(1);
    B1latepeak(i,1)=B1late(1);
    B2earlypeak(i,1)=B2erl(1);         
    
    B1earlypeak(i,2)=max(B1tmp(30:end));
    B1latepeak(i,2)=max(B2tmp(30:end));
    B2earlypeak(i,2)=max(B3tmp(30:end));         

    end
end