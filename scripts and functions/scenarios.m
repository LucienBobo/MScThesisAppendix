
%% Generating year-ahead spot price scenarios

disp('Generating price scenarios...');

% 100 different realisations of wind and load parameters
wind_shift=[0,6,12,18]; % wind time offset
wind_amp=[0.5,0.75,1,1.25,1.5]; % wind amplitude change
load_amp=[0.7,0.9,1,1.1,1.3]; % load amplitude change

% Initialising known bids
[A_dh_f,F_dh_f]=infrastructure_definition_new_DH();
cap_trans=5;
[A_trans_f,F_trans_f]=infrastructure_definition_singlelineTSO(cap_trans);
node_hydro=1;
Q_hydro=10*ones(K,1);
node_indus=2;
Q_indus=-1*[5*ones(7,1);7;9;11*ones(8,1);9;7;5*ones(5,1)];
ws=0; wa=1; la=1;
spot_bids;

% Obtaining spot prices for different realisations of wind and load profiles
[price_scens_long,n_scens_long]=run_multiple_spots(wind_shift,wind_amp,load_amp,offers_s,Q_wind,Q_lse);
disp('Price scenarios generated.');
