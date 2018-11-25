
function [A,F]=costregion_singlenode_pricequantities(Q,cost_wtp,node)

% cost_wtp is the variable cost (Q>0) or wtp (Q<0) in €/MW

global K
global N

% No state variables

% A - consider that min(Q)=max(Q)=0 for all other nodes that 'node'
%     min(Q,0) - q = 0  % q >= min(Q,0)
%    -max(Q,0) + q = 0  % q <= max(Q,0)
A=[ [zeros(K*(node-1),1),eye(K*(node-1)),zeros(K*(node-1),K),zeros(K*(node-1),K*(N-node))];...
    [zeros(K*(node-1),1),-eye(K*(node-1)),zeros(K*(node-1),K),zeros(K*(node-1),K*(N-node))];...
    [min(Q,0),zeros(K,K*(node-1)),-eye(K),zeros(K,K*(N-node))];...
    [-max(Q,0),zeros(K,K*(node-1)),eye(K),zeros(K,K*(N-node))];...
    [zeros(K*(N-node),1),zeros(K*(N-node),K*(node-1)),zeros(K*(N-node),K),eye(K*(N-node))];...
    [zeros(K*(N-node),1),zeros(K*(N-node),K*(node-1)),zeros(K*(N-node),K),-eye(K*(N-node))];...
  ];

F=zeros(K*N,1);
for k=1:K
    F(K*(node-1)+k)=cost_wtp;
end

end
