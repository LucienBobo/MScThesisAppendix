
function [A,F]=costregion_singlenode_proportionalprofile_riskhedging(Q,lambda,alpha,beta,node)

% lambda represents price scenarios S*K with S number of scenarios

global K
global N

% One state variable, k \in [0,1], defines the profile amplitude
% X=[k];

% A:
% - for node 'node':
%    0 - q + kQ <= 0
%    0 + q - kQ <= 0
%    0 + 0 - k <= 0
%   -1 + 0 + k <= 0
% for all other nodes:
%   -q <= 0
%    q <= 0
    
A=[ [zeros(K,1),zeros(K,K*(node-1)),-eye(K),zeros(K,K*(N-node)),Q];...
    [zeros(K,1),zeros(K,K*(node-1)),eye(K),zeros(K,K*(N-node)),-Q];...
    [0,zeros(1,K*N),-1];...
    [-1,zeros(1,K*N),1];...
    [zeros(K*(node-1),1),eye(K*(node-1)),zeros(K*(node-1),K),zeros(K*(node-1),K*(N-node)),zeros(K*(node-1),1)];...
    [zeros(K*(node-1),1),-eye(K*(node-1)),zeros(K*(node-1),K),zeros(K*(node-1),K*(N-node)),zeros(K*(node-1),1)];...
    [zeros(K*(N-node),1),zeros(K*(N-node),K*(node-1)),zeros(K*(N-node),K),eye(K*(N-node)),zeros(K*(N-node),1)];...
    [zeros(K*(N-node),1),zeros(K*(N-node),K*(node-1)),zeros(K*(N-node),K),-eye(K*(N-node)),zeros(K*(N-node),1)];...
  ];


% Expected risk-neutral spot market income (>0 if lambda>0 and P>0)
Exp_neutral=sum(lambda*Q)/size(lambda,1);

sorted=sort(lambda*Q);
n_worst=max(1,round((1-alpha)*size(lambda,1)));
Exp_worst=sum(sorted(1:n_worst))/n_worst;

% Expected risk-averse spot market income (-WTP for a full-hedge futures for period k)
Exp_averse=(1-beta)*Exp_neutral+beta*Exp_worst;

% Cost is proportional to amplitude factor k (k=1 > 100% cost)
F=[zeros(K*N,1);Exp_averse];



end
