function [reachtime retracttime totaltime] = time_to_pellet(Block)
reachtime = Block.grasptime - Block.reachtime;
for i = 1:size(Block.kinem,3)
    if sum(~isnan(Block.kinem(:,1,i)))>1
        tmp = find(Block.kinem(:,1,i)>Block.ret_marker);
        d=diff(tmp);
        totaltime(i)=max(d)*(1000/30);
        if totaltime(i)==1000/30;
            totaltime(i)=NaN;
        end
        tmp2 = tmp(tmp>Block.grasp(i));
        if ~isempty(tmp2)
            retracttime(i) = (tmp2(1)-Block.grasp(i))*(1000/30)
        else
            retracttime(i)=NaN;
        end
    end
end
%totaltime2 = reachtime + retracttime;
end
