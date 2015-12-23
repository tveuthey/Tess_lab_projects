clear hold_xy1 hold_xy m_x reach_on reach_on2
win_prior=15;
drop_frame=26;
% newtime=linspace(1,1220,1220);
for val_trial=1:length(trials_markers2)
    
%     hold_xy1=hold_paths{val_trial+1};
% 
%     hold_xy(:,1)=smooth(hold_xy1(:,1),6,  'loess'   );
%     hold_xy(:,2)=smooth(hold_xy1(:,2),6 , 'loess'   );
       
    %find start of reach (min)
    %             win_prior=15;
    %[m_x reach_on]=min (-hold_xy(drop_frame-win_prior:drop_frame,1))
                  reach_on2(:,val_trial)=Reach(val_trial)-(((drop_frame-hold_starts{val_trial})/30)*Fs_wave);
   
end 
    
%     disp(-hold_xy(drop_frame-win_prior:drop_frame))
%     
%     disp(m_x)
% %     reach_on=drop_frame-(win_prior-reach_on)-1;
%     disp(-hold_xy(reach_on))
%     subplot(6,1,5);
%     title(drop_frame)
%     plot(-hold_xy(:,1),'r','LineWidth',2)
%     ylim([min(-hold_xy(:,1)) max(-hold_xy(:,1))]);
%     axis off;hold on
%     a=axis;line([drop_frame drop_frame],a(3:4),'LineStyle',':');
%     
%     line([reach_on reach_on],a(3:4),'LineStyle',':','Color','c','LineWidth',3);
%     line([0 36],[m_x m_x])
%     
%     subplot(6,1,6);
%     plot(hold_xy(:,2),'k','LineWidth',2)
%     a=axis;line([drop_frame drop_frame],a(3:4),'LineStyle',':');
%     
%     hold on; axis off;
%     % a=axis;line([25 25],a(3:4));
%     %             set(fh.sens_ax2_p,'Xdata',1:length(hold_xy),...
%     %                 'Ydata',-hold_xy(:,1))
%     %             set(fh.sens_ax3_p,'Xdata',1:length(hold_xy(:,2)),...
%     %                 'Ydata',hold_xy(:,2))
%     %         else
%     %             set(fh.sens_ax2_p,'Xdata',1,'Ydata',1)
%     %             set(fh.sens_ax3_p,'Xdata',1,'Ydata',1)
% end