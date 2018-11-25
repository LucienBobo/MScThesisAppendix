
function [A,F]=costregion_singlenode_piecewise(Quantities,Prices,node)

% 'Quantities' contains the length of each step
% 'Prices' constains the offering price for each step

global K
global N

kQ=permute(repmat(Quantities',1,K),[2,1]);
kQ=kQ(:);
kP=permute(repmat(Prices',1,K),[2,1]);
kP=kP(:);

% For each step 's', a set of K state variables qs \in R^K, bounded by Qs
% X=[q1;q2;...;qS]
S=size(Quantities,2);

% A:
%    0 - q + q1 + q2 ... + qS <= 0     % q >= sum(qs)
%    0 + q - q1 - q2 ... - qS <= 0     % q <= sum(qs)
%    0 + 0 - q1 +  0 ... +  0 <= 0     % q1 >=0
%    0 + 0 +  0 - q2 ... +  0 <= 0     % q2 >=0
%  ...
%    0 + 0 +  0 +  0 ... - qS <= 0     % qs >=0
%  -Q1 + 0 + q1 +  0 ... +  0 <= 0     % q1 <= Q1
%  -Q2 + 0 +  0 + q2 ... +  0 <= 0     % q2 <= Q2
%  ...
%  -QS + 0 +  0 +  0 ... + qS <= 0     % qs <= QS
%
%  and for all nodes not concerned:
%    Q <= 0
%   -Q <= 0

% MODIFIED (as compared to description above) TO INCLUDE NEGATIVE QUANTITIES
A=[ [zeros(K,1),zeros(K,K*(node-1)),-eye(K),zeros(K,K*(N-node)),repmat(eye(K),1,S)];...
    [zeros(K,1),zeros(K,K*(node-1)),eye(K),zeros(K,K*(N-node)),-repmat(eye(K),1,S)];...
    [min(kQ,zeros(K*S,1)),zeros(K*S,K*N),-eye(K*S)];...
    [-max(kQ,zeros(K*S,1)),zeros(K*S,K*N),eye(K*S)];...
    [zeros(K*(node-1),1),eye(K*(node-1)),zeros(K*(node-1),K),zeros(K*(node-1),K*(N-node)),zeros(K*(node-1),K*S)];...
    [zeros(K*(node-1),1),-eye(K*(node-1)),zeros(K*(node-1),K),zeros(K*(node-1),K*(N-node)),zeros(K*(node-1),K*S)];...
    [zeros(K*(N-node),1),zeros(K*(N-node),K*(node-1)),zeros(K*(N-node),K),eye(K*(N-node)),zeros(K*(N-node),K*S)];...
    [zeros(K*(N-node),1),zeros(K*(N-node),K*(node-1)),zeros(K*(N-node),K),-eye(K*(N-node)),zeros(K*(N-node),K*S)];...
  ];

% Cost is associated with each piecewise power segment (it is important
% that the cost function is non-decreasing, otherwise this won't work)
F=[zeros(K*N,1);kP];

end