%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Plotting Movie of phase/amplitude changes
figure
count=0;
for n = 1:5:size(Mov_pre,3)
    count=count+1;
    temp1=Mov_pre(:,:,n);
    temp2=Mov_post(:,:,n);
    temp3=Mov_diff(:,:,n);
subplot(131);
    surf(temp1)
        set(gca,'CLim',[-.7 .7])  
    set(gca, 'YDir', 'reverse')
    shading interp
%    colorbar
    axis([0 8 0 4 -1 1]);
 %   shading flat 
     axis off
     az=-10;
     el=88;
     view(az,el);
     title('Pre Learning')
     
    subplot(132)
    surf(temp2)    
    set(gca,'CLim',[-.7 .7])  
    set(gca, 'YDir', 'reverse')
    shading interp
 %   colorbar
    axis([0 8 0 4 -1 1]);
%     shading flat 
     axis off
     az=-10;
     el=88;
     view(az,el);
%     midt = strcat('Post Leint2str(n), 'ms');
     title({strcat(int2str(n),'ms'),'Post Learning'})
    subplot(133);
    surf(temp3)    
%    surF(temp2);
    set(gca,'CLim',[-.7 .7])  
    set(gca, 'YDir', 'reverse')
    shading interp
 %   set(gcf, 'renderer', 'zbuffer');
  %   colorbar
    axis([0 8 0 4 -1 .1]);
%    shading flat 
     axis off
     az=-10;
     el=88;
     view(az,el);
     title('Learning Difference')
%      vid = avifile('test.avi');
%      f = getframe(gcf); % <<< Added figure handle in function call
%      vid = addframe(vid,f);
%      vid = close(vid);
M(count)=getframe;
    % pause(0.001) 
end
%movie(M);
%
% figure
% for n = 1:5:size(Mov_post,3)
%     temp=Mov_post(:,:,n);
%     surf(temp)
% %     surF(temp2);
%     set(gca,'CLim',[-.3 .3])    
%     shading interp
%     colorbar
% %     shading flat
%     axis off
%     az=-20;
%     el=88;
%     view(az,el);
%     title(n)
%      pause(0.001) 
% end
% 
% figure
% for n = 1:size(Mov_post,3)
%     temp=Mov_post(:,:,n);
%     surf(temp)
% %     surF(temp2);
%     set(gca,'CLim',[-.3 .3])    
%     shading interp
%     %colorbar
% %     shading flat
%     axis off
%     az=-20;
%     el=88;
%     view(az,el);
%     title(n)
%      pause(0.001) 
% end
%  clear Mov_pre Mov_post Mov_diff

   


