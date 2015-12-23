%%

T12presws = 
T12postsws = 
T12prespindle =
T12postspindle =

T25presws = 
T25postsws = 
T25prespindle =
T25postspindle =

T28presws = 
T28postsws = 
T28prespindle =
T28postspindle =

T34presws = 
T34postsws = 
T34prespindle =
T34postspindle =

T39presws = 
T39postsws = 
T39prespindle =
T39postspindle =
%%
figure
subplot(2,2,1)
circ_plot(phi_pre_sws_med(:)-phi_post_sws_med(:),'pretty','bo',true,'linewidth',2,'color','r')

subplot(2,2,3)
circ_plot(phi_pre_spindle_med(:)-phi_post_spindle_med(:),'pretty','bo',true,'linewidth',2,'color','r')


figure
subplot(2,2,1)
circ_plot(phi_pre_sws_med(:),'pretty','bo',true,'linewidth',2,'color','r')

subplot(2,2,3)
circ_plot(phi_pre_sws_med(:),'hist',[],20,true,true,'linewidth',2,'color','r')

subplot(2,2,2)
circ_plot(phi_post_sws_med(:),'pretty','bo',true,'linewidth',2,'color','r')

subplot(2,2,4)
circ_plot(phi_post_sws_med(:),'hist',[],20,true,true,'linewidth',2,'color','r')

%%
figure(2)
subplot(2,2,1)
circ_plot(phi_pre_spindle_med','pretty','bo',true,'linewidth',2,'color','r')

subplot(2,2,3)
circ_plot(phi_pre_spindle_med','hist',[],20,true,true,'linewidth',2,'color','r')

subplot(2,2,2)
circ_plot(phi_post_spindle_med','pretty','bo',true,'linewidth',2,'color','r')

subplot(2,2,4)
circ_plot(phi_post_spindle_med','hist',[],20,true,true,'linewidth',2,'color','r')

 
%% part 4: inferential statistics

fprintf('Inferential Statistics\n\nTests for Uniformity\n')

% Rayleigh test
p_sws_pre = circ_rtest(phi_pre_sws_med);
p_sws_post = circ_rtest(phi_post_sws_med);

p_spindle_pre = circ_rtest(phi_pre_spindle_med);
p_spindle_post = circ_rtest(phi_post_spindle_med);

%p_beta = circ_rtest(beta_rad);
fprintf('Rayleigh Test, \t\t P = %.2f \t%.2f\n',[p_sws_pre p_sws_post])
fprintf('Rayleigh Test, \t\t P = %.2f \t%.2f\n',[p_spindle_pre p_spindle_post])

% Omnibus test
p_sws_pre = circ_otest(phi_pre_sws_med);
p_sws_post = circ_otest(phi_post_sws_med);

p_spindle_pre = circ_otest(phi_pre_spindle_med);
p_spindle_post = circ_otest(phi_post_spindle_med);

%p_beta = circ_otest(beta_rad);

%fprintf('Omnibus Test, \t\t P = %.2f \t%.2f\n',[p_alpha p_beta])

% Rao's spacing test
p_alpha = circ_raotest(alpha_rad);
p_beta = circ_raotest(beta_rad);
fprintf('Rao Spacing Test, \t P = %.2f \t%.2f\n',[p_alpha p_beta])

% V test
p_alpha = circ_vtest(alpha_rad,circ_ang2rad(0));
p_beta = circ_vtest(beta_rad,circ_ang2rad(0));
fprintf('V Test (r = 0), \t P = %.2f \t%.2f\n',[p_alpha p_beta])


fprintf('\nTests concerning Mean and Median angle\n')

% 95 percent confidence intervals for mean direction
t_alpha = circ_confmean(alpha_rad,0.05);
t_beta = circ_confmean(beta_rad,0.05);

fprintf('Mean, up 95 perc. CI:\t\t\t%.2f \t%.2f\n', circ_rad2ang([alpha_bar+t_alpha beta_bar+t_beta]))
fprintf('Mean, low 95 perc. CI:\t\t\t%.2f \t%.2f\n', circ_rad2ang([2*pi+alpha_bar-t_alpha beta_bar-t_beta]))

h1 = circ_mtest(alpha_rad,0);
h2 = circ_mtest(alpha_rad,circ_ang2rad(90));

fprintf('Mean Test (alpha), mean = 0 deg:\t\t%d\n',h1)
fprintf('Mean Test (alpha), mean = 90 deg:\t\t%d\n',h2)


h1 = circ_medtest(alpha_rad,circ_ang2rad(25));
h2 = circ_medtest(alpha_rad,circ_ang2rad(105));

fprintf('Median Test (alpha), median = 25 deg:\t%.2f\n',h1)
fprintf('Median Test (alpha), median = 105 deg:\t%.2f\n',h2)

h1 = circ_symtest(alpha_rad);
h2 = circ_symtest(beta_rad);

fprintf('Symmetry around median (alpha/beta):\t\t\t%.2f\t %.2f\n',h1,h2)
%% part 4: association
fprintf('Measures of Association\n\nCircular-Circular Association\n')

figure
subplot(121)
plot(alpha_rad,beta_rad,'ok')
formatSubplot(gca,'xl','\alpha_i','yl','\beta_i', 'ax','square','box','off', 'lim',[0 2*pi 0 2*pi ])

subplot(122)
plot(1:20,alpha_rad,'or',1:20,beta_rad,'ok')
formatSubplot(gca,'xl','x','yl','\alpha_i (red) / \beta_i (black)', 'ax','square','box','off', 'lim',[0 21 0 2*pi ])


% compute circular - circular correlation of alpha and beta
[c p] = circ_corrcc(alpha_rad,beta_rad);
fprintf('Circ-circ corr coeff/pval:\t%.2f\t %.3f\n',c,p)


% cmpute circular - linear correlation of alpha/beta with 1:20
[ca pa] = circ_corrcl(alpha_rad,1:20);
[cb pb] = circ_corrcl(beta_rad,1:20);

fprintf('Circ-lin corr coeff:\t\t%.2f\t %.2f\n',ca,cb)
fprintf('Circ-lin corr pval:\t\t\t%.3f\t %.3f\n',pa,pb)


%% part 5: multi-sample tests
% the dataset we use here consists of three samples from von mises
% distributions with common parameter kappa = 10 and means equal to pi,
% pi+.25 and pi+.5.

load data

fprintf('\nMulti-Sample tests\n')

fprintf('\nTEST 1: ONE FACTOR ANOVA, theta1 vs theta2\n')
p = circ_wwtest(theta1,theta2);

fprintf('\nTEST 2: ONE FACTOR ANOVA, theta1 vs theta2 vs theta3\n')
p = circ_wwtest(theta,idx);


p = circ_cmtest(theta1,theta2);
fprintf('TEST 3: NON PARAMETRIC ONE FACTOR ANOVA, theta1 vs. theta2\nP = %.4f\n\n',p)

fprintf('\nTEST 4: TWO FACTOR ANOVA, theta1 vs theta2\n')

idp = idx(1:60);    % factor 1: two original groups
idq = idp(randperm(length(idp))); % factor 2: random assignment to groups

p = circ_hktest([theta1; theta2], idp,idq,true);














