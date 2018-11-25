
%% Infrastructure definition for a simple heat system with non-ideal storage
% Equations below are written assuming X=[Xwc;Xel;Xhp;Xflex;Vs;Vr] with:
% - Xwc woodchip boiler output (GJ, positive, length K)
% - Xel el boiler output (GJ, positive, length K)
% - Xhp heat pump output (GJ, positive, length K)
% - Xflex flexible load coverage (GJ, positive, length K)
% - Vs supply pipeline temperature injected at node 1 (°C, positive, length K)
% - Vr return pipeline temperature injected at node 2 (°C, positive, length K)

% Elements at power node 1:
%   - woodchip boiler
%   - heat pump
%
% Elements at power node 2:
%   - el boiler
%   - flex load
%   - fixed load
%
% Pipelines:
%   - from node 1 to node 2 with fixed mass flow

function [B,F]=infrastructure_definition_new_DH()

global K % number of time periods
global N % number of power nodes


% Parameters
d_fixed = 1.5*[15;15;16;16;17;18;19;17;14;12;11;11;11;11;11;11;11;11;12;12;13;15;15;15]; % fixed heat load
e_flex = 1.5*100; % flexible load energy need (GJh)
r_flex = 10; % maximum rate of supply for flexible load (GJh/h)
% alpha_el=3; % el boiler power-to-heat factor (GJ/MWh)
% beta_el=25; % el boiler capacity (GJ)
alpha_el=3; % el boiler power-to-heat factor (GJ/MWh)
beta_el=5; % el boiler capacity (GJ)
% alpha_hp=6; % heat pump power-to-heat factor (GJ/MWh)
% beta_hp=7; % heat pump capacity (GJ)
alpha_hp=5; % heat pump power-to-heat factor (GJ/MWh)
beta_hp=30; % heat pump capacity (GJ)
beta_wc=1.5*25; % woodchip boiler capacity (GJ)
cost_wc=40; % woodchip fuel cost (€/GJ)
vmax=90; % maximum supply temperature (°C)
vmin=30; % minimum return temperature (°C)
alpha_pipe=1.5*1; % energy content of water flowing through nodes (GJ/°C)
vs0=vmin+2*(vmax-vmin)/3;
vr0=vmin+1*(vmax-vmin)/3;

% Costs: woodchip boiler only
F = [zeros(K*N,1);cost_wc*ones(K,1);zeros(5*K,1)];

% Operation constraints
%   heat balance node 1:
%       Xwc + Xhp - alpha_pipe*Vs(k) + alpha_pipe*Vr(k-1) <=0
%     - Xwc - Xhp + alpha_pipe*Vs(k) - alpha_pipe*Vr(k-1) <=0
%   heat balance node 2:
%       d_fixed - Xel + Xflex - alpha_pipe*Vs(k-1) + alpha_pipe*Vr(k) <=0
%     - d_fixed - Xel - Xflex + alpha_pipe*Vs(k-1) - alpha_pipe*Vr(k) <=0
%   el boiler conversion:
%       q + alpha_el*Xel <=0
%     - q - alpha_el*Xel <=0
%   boiler capacities
%     - Xel <= 0
%     - Xwc <= 0
%     - beta_el + Xel <= 0
%     - beta_wc + Xwc <= 0
%   temp limits
%     - vmax + Vs <= 0
%       vmin - Vr <= 0
%       0 - Vs + Vr <= 0
%   temp cycling
%       vr0 - Vr(K) <= 0
%     - vr0 + Vr(K) <= 0
%       vs0 - Vs(K) <= 0
%     - vs0 + Vs(K) <= 0
%   flex load coverage
%       e_flex - sum(Xflex) <=0
%     - e_flex + sum(Xflex) <=0
%     - Xflex <=0
%     - r_flex + Xflex <=0

% Here with non-ideal storage so that storage is used only when useful
B=[ [[alpha_pipe*vr0;zeros(K-1,1)], zeros(K,K*N), eye(K), zeros(K), eye(K), zeros(K), -alpha_pipe*eye(K), alpha_pipe*[zeros(1,K);[eye(K-1),zeros(K-1,1)]]];...        % Heat balance node 1
    [-[alpha_pipe*vr0;zeros(K-1,1)], zeros(K,K*N), -eye(K), zeros(K), -eye(K), zeros(K), alpha_pipe*eye(K), -alpha_pipe*[zeros(1,K);[eye(K-1),zeros(K-1,1)]]];...     % Heat balance node 1
    [d_fixed-[alpha_pipe*vs0;zeros(K-1,1)], zeros(K,K*(N+1)), -eye(K), zeros(K), eye(K), -alpha_pipe*[zeros(1,K);[eye(K-1),zeros(K-1,1)]], alpha_pipe*eye(K)];...         % Heat balance node 2
    [-d_fixed+[alpha_pipe*vs0;zeros(K-1,1)], zeros(K,K*(N+1)), eye(K), zeros(K), -eye(K), alpha_pipe*[zeros(1,K);[eye(K-1),zeros(K-1,1)]], -alpha_pipe*eye(K)];...        % Heat balance node 2
    [zeros(K,1), zeros(K), alpha_el*eye(K), zeros(K), eye(K), zeros(K,4*K)];...     % El boiler power-to-heat
    [zeros(K,1), zeros(K), -alpha_el*eye(K), zeros(K), -eye(K), zeros(K,4*K)];...   % El boiler power-to-heat
%     [zeros(K,1), zeros(K), alpha_el*eye(K), zeros(K), zeros(K), zeros(K,4*K)];...     % No injection at node 2
%     [zeros(K,1), zeros(K), -alpha_el*eye(K), zeros(K), -zeros(K), zeros(K,4*K)];...   % No injection at node 2
    [zeros(K,1), alpha_hp*eye(K), zeros(K,3*K), eye(K), zeros(K,3*K)];...     % Heat pump power-to-heat
    [zeros(K,1), -alpha_hp*eye(K), zeros(K,3*K), -eye(K), zeros(K,3*K)];...   % Heat pump power-to-heat
%     [zeros(K,1), alpha_hp*eye(K), zeros(K,3*K), zeros(K), zeros(K,3*K)];...     % No injection at node 1
%     [zeros(K,1), -alpha_hp*eye(K), zeros(K,3*K), -zeros(K), zeros(K,3*K)];...   % No injection at node 1
    [-beta_wc*ones(K,1), zeros(K,N*K), eye(K), zeros(K,5*K)];...   % Woodchip boiler max capacity
    [zeros(K,1), zeros(K,N*K), -eye(K), zeros(K,5*K)];...          % Woodchip boiler nonnegative output
    [-beta_el*ones(K,1), zeros(K,N*K), zeros(K), eye(K), zeros(K,4*K)];...   % El boiler max capacity
    [zeros(K,1), zeros(K,N*K), zeros(K), -eye(K), zeros(K,4*K)];...          % El boiler nonnegative output
    [-beta_hp*ones(K,1), zeros(K,N*K), zeros(K,2*K), eye(K), zeros(K,3*K)];...   % Heat pump max capacity
    [zeros(K,1), zeros(K,N*K), zeros(K,2*K), -eye(K), zeros(K,3*K)];...          % Heat pump nonnegative output
    [-vmax*ones(K,1), zeros(K,K*(N+4)), eye(K), zeros(K)];...   % Supply temp lim
    [vmin*ones(K,1), zeros(K,K*(N+5)), -eye(K)];...              % Return temp lim
    [zeros(K,1), zeros(K,K*(N+4)), -eye(K), eye(K)];...         % Supply temp > return temp
    [vr0, zeros(1,K*(N+5)), zeros(1,K-1), -1];...               % Return temp cycling
    [-vr0, zeros(1,K*(N+5)), zeros(1,K-1), 1];...               % Return temp cycling
    [vs0, zeros(1,K*(N+4)), zeros(1,K-1), -1, zeros(1,K)];...   % Supply temp cycling
    [-vs0, zeros(1,K*(N+4)), zeros(1,K-1), 1, zeros(1,K)];...   % Supply temp cycling
    [e_flex, zeros(1,K*(N+3)), -ones(1,K), zeros(1,2*K)];...           % Flex load energy
    [-e_flex, zeros(1,K*(N+3)), ones(1,K), zeros(1,2*K)];...           % Flex load energy
    [zeros(K,1), zeros(K,K*(N+3)), -eye(K), zeros(K,2*K)];...          % Flex load rating
    [-r_flex*ones(K,1), zeros(K,K*(N+3)), eye(K), zeros(K,2*K)];...    % Flex load rating
];

end
