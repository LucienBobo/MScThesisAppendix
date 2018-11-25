
%% TSO feasible region for a no-loss single-line system

function [A,F]=infrastructure_definition_singlelineTSO(Cap)

global K % number of periods

% Cap is line capacity (MW)

F=zeros(K*2,1);
% A:
%   P_node1 + P_node2 <= 0 for all times
%   -P_node1 - P_node2 <= 0 for all times
%   -Cap - P_node1 <= 0 for all times
%   -Cap + P_node1 <= 0 for all times
A=[ [zeros(K,1),eye(K),eye(K)];...
    [zeros(K,1),-eye(K),-eye(K)];...
    [-Cap*ones(K,1),-eye(K),zeros(K)];...
    [-Cap*ones(K,1),eye(K),zeros(K)];...
  ];
    

end
