function [Output]=plot_graphs(dir1, indir1,unrel1)
close all


m_d=mean(dir1);
m_i=mean(indir1)-4;
m_u=mean(unrel1);

s_d=std(dir1)/sqrt(length(dir1));
s_i=std(indir1)/sqrt(length(indir1));
s_u=std(unrel1)/sqrt(length(unrel1));

m=[m_d m_i m_u];
s=[s_d s_i s_u]


bar(m); hold on
errorbar(m,s)
Output=[m]