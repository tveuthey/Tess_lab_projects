trials_NO=length(Reach);
block_len=4000;
before_zero=2000;
t=[(before_zero/Fs_lfp):(block_len-before_zero/Fs_lfp)];
for n=2:trials_NO-1
    figure
    %file
    subplot(3,1,1);
%     temp=lever1(Reward(n)-before_zero:Reward(n)+block_len-before_zero);
%     plot(temp);
%     hold on
%     temp=lever2(Reward(n)-before_zero:Reward(n)+block_len-before_zero);
%     plot(temp,'r')
        temp=strobe(Reach(n)-before_zero:Reach(n)+block_len-before_zero);
    plot(temp,'c')
        a=axis;
    line([before_zero before_zero],a(3:4),'Color','g')
    hold off
    subplot(3,1,2)
    e_i=round([Reach(n)-before_zero:Reach(n)+block_len-before_zero]);
    plot(data(7,e_i));
%     hold on;
%    
%      %   plot(data_REF(1,e_i),'r');
%     hold off;
   t=[Reach(n)-before_zero:Reach(n)+block_len-before_zero]/Fs_lfp;
    tstamps=TimeStamps{7,2};
    t2=find(tstamps>t(1));
    t3=find(tstamps>t(end));
    if ~isempty(t2) && ~isempty(t3)
        range2=[t2(1):t3(1)]%/Fs_lfp
        subplot(3,1,3)
        hist(tstamps(range2),30)
    end
    
    %pause
end