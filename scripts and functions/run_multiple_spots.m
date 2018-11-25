
function [price_scens_short,n_scens_short]=run_multiple_spots(wind_shift,wind_amp,load_amp,offers_origin,Q_wind_origin,Q_lse_origin);

global N
global K

ns1=length(wind_shift);
ns2=length(wind_amp);
ns3=length(load_amp);
n_scens_short=ns1*ns2*ns3;

offers=offers_origin;

price_scens_short=zeros(K,N,n_scens_short);

scen=1;

% Q_wind_origin=20*[0.8255739;0.8739145;0.8400767;0.7590398;0.7141503;0.6986626;0.6404142;0.7387226;0.8216063;0.760697;0.567672;0.4563597;0.4342797;0.3415726;0.1828348;0.1108266;0.118112;0.2302329;0.2000635;0.2561656;0.3096326;0.3868677;0.582164;0.6003];
node_wind=2;

% Q_lse_origin=-10*[0.3126;0.2718;0.2578;0.2561;0.2581;0.2791;0.3587;0.4746;0.4602;0.3972;0.4050;0.3995;0.3860;0.3753;0.3739;0.3968;0.4884;0.6586;0.7844;0.7622;0.7051;0.6434;0.5277;0.4129];
node_lse=1;


% figure;

for ws=wind_shift
    for wa=wind_amp
        for la=load_amp
        
            Q_wind=wa*Q_wind_origin(mod((1:K)+ws-1,24)+1);
            [A_wind_s,F_wind_s]=costregion_singlenode_pricequantities(Q_wind,0,node_wind);
            offers(:,6)={'Wind power';A_wind_s;F_wind_s};

            Q_lse=la*Q_lse_origin;
            [A_lse_s,F_lse_s]=costregion_singlenode_pricequantities(Q_lse,1000,node_lse);
            offers(:,7)={'LSE';A_lse_s;F_lse_s};

            % additional argument to avoid console output
            [~,~,L,~]=clearing(offers,false);

            price_scens_short(:,:,scen)=L;
            scen=scen+1;

%             figure(1);
%             plot(L);
%             ylim([-20,200]);

%             plot(L); hold on
            
        end
    end
end

price_scens_short=permute(price_scens_short,[3,1,2]);

end