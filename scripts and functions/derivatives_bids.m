%% Derivatives auction bids

offers_f=cell(3,0);

% DH utility
[A_dh_f,F_dh_f]=infrastructure_definition_new_DH();
offers_f(:,end+1)={'DH utility';A_dh_f;F_dh_f};

% Transmission system operator
cap_trans=5;
[A_trans_f,F_trans_f]=infrastructure_definition_singlelineTSO(cap_trans);
offers_f(:,end+1)={'TSO';A_trans_f;F_trans_f};

% Run-of-river hydro
node_hydro=1;
Q_hydro=10*ones(K,1);
alpha=0.95; beta=0.45;
[A_hydro_f,F_hydro_f]=costregion_singlenode_proportionalprofile_riskhedging(Q_hydro,price_scens_long(:,:,node_hydro),alpha,beta,node_hydro);
F_hydro_f=1*F_hydro_f; % >1 if actor is being strategic
offers_f(:,end+1)={'Run-of-river hydro';A_hydro_f;F_hydro_f};

% Industrial load
node_indus=2;
Q_indus=-1*[5*ones(7,1);7;9;11*ones(8,1);9;7;5*ones(5,1)];
% alpha=0.95; beta=1;
% [A_indus_f,F_indus_f]=costregion_singlenode_pricequantities_riskhedging(Q_indus,price_scens_long(:,:,node),alpha,beta,node);
[A_indus_f,F_indus_f]=costregion_singlenode_proportionalprofile_riskhedging(Q_indus,price_scens_long(:,:,node_indus),alpha,beta,node_indus);
F_indus_f=1*F_indus_f; % <1 if actor is being strategic
offers_f(:,end+1)={'Industrial load';A_indus_f;F_indus_f};
