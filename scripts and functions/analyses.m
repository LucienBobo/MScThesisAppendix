

%% Display the spot market economic dispatch and prices

figure('units','normalized','outerposition',[0 0 1 1])

Q_disp=Q_s;
Q_stairs=[Q_disp;Q_disp];
x_stairs=zeros(2*K,1);
for k=1:K
    Q_stairs(2*k-1,:,:)=Q_disp(k,:,:);
    Q_stairs(2*k,:,:)=Q_disp(k,:,:);
    x_stairs(2*k-1)=k-0.5;
    x_stairs(2*k)=k+0.5;
end

subplot(2,2,1);
leg=area(x_stairs,[max(0,Q_stairs(:,1,2)) Q_stairs(:,1,3) zeros(2*K,1) zeros(2*K,1) zeros(2*K,1) zeros(2*K,1) zeros(2*K,1)]); hold on;
area(x_stairs,[min(0,Q_stairs(:,1,2)) zeros(2*K,1) zeros(2*K,1) zeros(2*K,1) zeros(2*K,1) Q_stairs(:,1,7) Q_stairs(:,1,1)]); hold on;
xlim([0.5,K+0.5]);
set(gca,'XTick',[1,6,12,18,24]);
ylim([-20;20]);
legend(leg([1,2,6,7]),{'TSO','Baseload supply','LSE','DH Utility'});
hold off;
xlabel('Time period');
ylabel('Power injection or withdrawal (MWh/h)');
title('Economic dispatch at node 1');

subplot(2,2,2);
leg=area(x_stairs,[max(0,Q_stairs(:,2,2)) zeros(2*K,1) zeros(2*K,1) Q_stairs(:,2,5) Q_stairs(:,2,6) zeros(2*K,1) zeros(2*K,1)]); hold on;
area(x_stairs,[min(0,Q_stairs(:,2,2)) zeros(2*K,1) Q_stairs(:,2,4) zeros(2*K,1) zeros(2*K,1) zeros(2*K,1) Q_stairs(:,2,1)]); hold on;
xlim([0.5,K+0.5]);
set(gca,'XTick',[1,6,12,18,24]);
ylim([-20;20]);
legend(leg([1,3,4,5,7]),{'TSO','Industry','Gas-fired','Wind','DH Utility'});
hold off;
xlabel('Time period');
ylabel('Power injection or withdrawal (MWh/h)');
title('Economic dispatch at node 2');

subplot(2,2,3);
stairs(0.5:1:K+0.5,[L_s(:,1);L_s(end,1)],'-');
xlim([0.5,K+0.5]);
set(gca,'XTick',[1,6,12,18,24]);
ylim([-20,200]);
ylabel('Spot market price (€/MWh)');
xlabel('Time period');
title('Spot prices at node 1');


subplot(2,2,4);
stairs(0.5:1:K+0.5,[L_s(:,2);L_s(end,2)],'-');
xlim([0.5,K+0.5]);
set(gca,'XTick',[1,6,12,18,24]);
ylim([-20,200]);
ylabel('Spot market price (€/MWh)');
xlabel('Time period');
title('Spot prices at node 2');


%% Displaying the derivatives auction market equilibrium

figure(1);
figure('units','normalized','outerposition',[0 0 1 1])

Q_disp=-Q_f;
Q_stairs=[Q_disp;Q_disp];
x_stairs=zeros(2*K,1);
for k=1:K
    Q_stairs(2*k-1,:,:)=Q_disp(k,:,:);
    Q_stairs(2*k,:,:)=Q_disp(k,:,:);
    x_stairs(2*k-1)=k-0.5;
    x_stairs(2*k)=k+0.5;
end


subplot(2,2,1);
leg=area(x_stairs,[min(0,Q_stairs(:,1,2)) Q_stairs(:,1,3) zeros(2*K,1) zeros(2*K,1) zeros(2*K,1) zeros(2*K,1) zeros(2*K,1)]); hold on;
area(x_stairs,[max(0,Q_stairs(:,1,2)) zeros(2*K,1) zeros(2*K,1) zeros(2*K,1) zeros(2*K,1) zeros(2*K,1) Q_stairs(:,1,1)]); hold on;
xlim([0.5,K+0.5]);
set(gca,'XTick',[1,6,12,18,24]);
ylim([-20;20]);
legend(leg([1,2,7]),{'TSO','Baseload power plant','DH Utility'});
hold off;
xlabel('Time period');
ylabel('Contract quantites (MWh/h)');
title('Forwards allocation for node 1');

subplot(2,2,2);
leg=area(x_stairs,[min(0,Q_stairs(:,2,2)) zeros(2*K,1) zeros(2*K,1) zeros(2*K,1) zeros(2*K,1) zeros(2*K,1) zeros(2*K,1)]); hold on;
area(x_stairs,[max(0,Q_stairs(:,2,2)) zeros(2*K,1) Q_stairs(:,2,4) zeros(2*K,1) zeros(2*K,1) zeros(2*K,1) Q_stairs(:,2,1)]); hold on;
xlim([0.5,K+0.5]);
set(gca,'XTick',[1,6,12,18,24]);
ylim([-20;20]);
legend(leg([1,3,7]),{'TSO','Industrial load','DH Utility'});
hold off;
xlabel('Time period');
ylabel('Contract quantities (MWh/h)');
title('Forwards allocation for node 2');

subplot(2,2,3);
stairs(0.5:1:K+0.5,[L_f(:,1);L_f(end,1)],'-');
xlim([0.5,K+0.5]);
set(gca,'XTick',[1,6,12,18,24]);
ylim([-20,200]);
ylabel('Price (€/MWh)');
xlabel('Time period');
title('Auction-clearing prices for node 1');

subplot(2,2,4);
stairs(0.5:1:K+0.5,[L_f(:,2);L_f(end,2)],'-');
xlim([0.5,K+0.5]);
set(gca,'XTick',[1,6,12,18,24]);
ylim([-20,200]);
ylabel('Price (€/MWh)');
xlabel('Time period');
title('Auction-clearing prices at node 2');


%% Computing the year-ahead economic surplus distributions

beta_real=beta;

displayDistrib=false;

fprintf('\nBaseload power plant:\n');
[expProf_hydro,minProf_hydro,expProf_hydro_f,minProf_hydro_f,minProf_hydro_f_analytical,riskav_hydro,riskav_hydro_f]=compute_yearahead_flexiblevolume(A_hydro_s,F_hydro_s,Q_f(:,:,3),[],L_f,price_scens_long(:,:,:),0,displayDistrib,alpha,beta_real);
fprintf('  Without futures:\n     exp. benefit = %.0f // min. benefit = %.0f // guaranteed benefit = %0.f \n',expProf_hydro,minProf_hydro,0);
fprintf('  With futures:\n     exp. benefit = %.0f // min. benefit = %.0f // guaranteed benefit = %0.f \n',expProf_hydro_f,minProf_hydro_f,minProf_hydro_f_analytical);
fprintf('  Without futures:\n     risk-averse objective = %.0f \n',riskav_hydro);
fprintf('  With futures:\n     risk-averse objective = %.0f \n',riskav_hydro_f);

fprintf('\nIndustrial load:\n');
[expProf_indus,minProf_indus,expProf_indus_f,minProf_indus_f,minProf_indus_f_analytical,riskav_indus,riskav_indus_f]=compute_yearahead_flexiblevolume(A_indus_s,F_indus_s,Q_f(:,:,4),[],L_f,price_scens_long(:,:,:),-sum(Q_indus)*1000,displayDistrib,alpha,beta_real);
fprintf('  Without futures:\n     exp. benefit = %.0f // min. benefit = %.0f // guaranteed benefit = %0.f \n',expProf_indus,minProf_indus,sum(Q_indus)*1000);
fprintf('  With futures:\n     exp. benefit = %.0f // min. benefit = %.0f // guaranteed benefit = %0.f \n',expProf_indus_f,minProf_indus_f,minProf_indus_f_analytical);
fprintf('  Without futures:\n     risk-averse objective = %.0f \n',riskav_indus);
fprintf('  With futures:\n     risk-averse objective = %.0f \n',riskav_indus_f);

[expProf_tso,minProf_tso,expProf_tso_f,minProf_tso_f,minProf_tso_f_analytical,riskav_tso,riskav_tso_f]=compute_yearahead_flexiblevolume(A_trans_s,F_trans_s,Q_f(:,:,2),X_f{2},L_f,price_scens_long(:,:,:),0,displayDistrib,alpha,beta_real);
fprintf('\nTransmission System Operator:\n');
fprintf('  Without futures:\n     exp. income = %.0f // min. income = %.0f // guaranteed income = %0.f \n',expProf_tso,minProf_tso,0);
fprintf('  With futures:\n     exp. income = %.0f // min. income = %.0f // guaranteed income = %0.f \n',expProf_tso_f,minProf_tso_f,minProf_tso_f_analytical);
fprintf('  Without futures:\n     risk-averse objective = %.0f \n',riskav_tso);
fprintf('  With futures:\n     risk-averse objective = %.0f \n',riskav_tso_f);

[expProf_dh,minProf_dh,expProf_dh_f,minProf_dh_f,minProf_dh_f_analytical,riskav_dh,riskav_dh_f]=compute_yearahead_flexiblevolume(A_dh_s,F_dh_s,Q_f(:,:,1),X_f{1},L_f,price_scens_long(:,:,:),0,displayDistrib,alpha,beta_real);
fprintf('\nDH utility:\n');
fprintf('  Without forwards:\n     exp. benefit = %.0f // min. benefit = %.0f // guaranteed benefit = %0.f \n',expProf_dh,minProf_dh,OpportunityCostDH);
fprintf('  With forwards:\n     exp. benefit = %.0f // min. benefit = %.0f // guaranteed benefit = %0.f \n',expProf_dh_f,minProf_dh_f,minProf_dh_f_analytical);
fprintf('  Without forwards:\n     risk-averse objective = %.0f \n',riskav_dh);
fprintf('  With forwards:\n     risk-averse objective = %.0f \n',riskav_dh_f);
