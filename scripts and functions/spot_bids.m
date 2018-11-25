
%% Spot market bids

b_max=1000; % maximum bidding price in spot market
b_min=-100; % minimum bidding price in spot market

offers_s=cell(3,0);

% DH utility
A_dh_s=A_dh_f;
F_dh_s=F_dh_f;
offers_s(:,end+1)={'DH utility';A_dh_s;F_dh_s};

% Transmission system operator
A_trans_s=A_trans_f;
F_trans_s=F_trans_f;
offers_s(:,end+1)={'TSO';A_trans_s;F_trans_s};

% % Run-of-river hydro
[A_hydro_s,F_hydro_s]=costregion_singlenode_pricequantities(Q_hydro,0,node_hydro);
offers_s(:,end+1)={'Run-of-river hydro';A_hydro_s;F_hydro_s};
% [A_hydro_s,F_hydro_s]=costregion_singlenode_pricequantities(Q_hydro,-100,node_hydro);
% offers_s(:,end+1)={'Nuclear power plant';A_hydro_s;F_hydro_s};


% Industrial load
[A_indus_s,F_indus_s]=costregion_singlenode_pricequantities(Q_indus,1000,node_indus);
offers_s(:,end+1)={'Industrial load';A_indus_s;F_indus_s};

% Gas-fired power plant
node_gas=2; %1
[A_gas_s,F_gas_s]=costregion_singlenode_piecewise([3,3,3,3,3],[35,70,105,140,175],node_gas);
offers_s(:,end+1)={'Gas-fired power plant';A_gas_s;F_gas_s};

% Wind power producer
node_wind=2;
% Q_wind=23.4*[0.8255739;0.8739145;0.8400767;0.7590398;0.7141503;0.6986626;0.6404142;0.7387226;0.8216063;0.760697;0.567672;0.4563597;0.4342797;0.3415726;0.1828348;0.1108266;0.118112;0.2302329;0.2000635;0.2561656;0.3096326;0.3868677;0.582164;0.6003];
Q_wind=20*[0.8255739;0.8739145;0.8400767;0.7590398;0.7141503;0.6986626;0.6404142;0.7387226;0.8216063;0.760697;0.567672;0.4563597;0.4342797;0.3415726;0.1828348;0.1108266;0.118112;0.2302329;0.2000635;0.2561656;0.3096326;0.3868677;0.582164;0.6003];
Q_wind=wa*Q_wind(mod((1:K)+ws-1,24)+1);
[A_wind_s,F_wind_s]=costregion_singlenode_pricequantities(Q_wind,0,node_wind);
offers_s(:,end+1)={'Wind power';A_wind_s;F_wind_s};

% Load-serving entity
node_lse=1; %2
Q_lse=-5*ones(K,1)-10*[0.3126;0.2718;0.2578;0.2561;0.2581;0.2791;0.3587;0.4746;0.4602;0.3972;0.4050;0.3995;0.3860;0.3753;0.3739;0.3968;0.4884;0.6586;0.7844;0.7622;0.7051;0.6434;0.5277;0.4129];
Q_lse=la*Q_lse;
[A_lse_s,F_lse_s]=costregion_singlenode_pricequantities(Q_lse,1000,node_lse);
offers_s(:,end+1)={'LSE';A_lse_s;F_lse_s};

