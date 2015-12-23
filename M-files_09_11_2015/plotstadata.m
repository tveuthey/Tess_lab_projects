function Output=plotstadata(mat_indiv1,mat_indiv2)
subplot(1,2,1)


for i=1:size(mat_indiv1,1)
%     c=randperm(size(mat_indiv1,1));
    plot(mat_indiv1(i,:)'+i*5,'g'); hold on
    
end
xlim([0 1016])
ylim([0 i*2])
line([508 508], ylim)
axis off
subplot(1,2,2)
for i=1:size(mat_indiv2,1)
%     c=randperm(size(mat_indiv2,1));
    plot(mat_indiv2(i,:)'+i*5, 'r'); hold on
    
end
xlim([0 1016])
ylim([0 i*2])
line([508 508], ylim)
axis off
set(gcf,'Color',[0 0 0])
Output=size(mat_indiv2);