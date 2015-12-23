
for i = 1:length(peth)
    if ~isempty(peth(i).fit)
    pethdiff = peth(i).fitlate.mean-peth(i).fitearly.mean;
    bl = mean(pethdiff(1:20));
    pmd2(i) = max(pethdiff(40:90))/bl;
    nmd2(i) = min(pethdiff(40:90))/bl;
   
    pmd(i) = max(pethdiff(40:90));
    nmd(i) = min(pethdiff(40:90));
   
    end
end

 pmd=pmd';
 nmd=nmd';
 
  pmd2=pmd2';
 nmd2=nmd2';
 