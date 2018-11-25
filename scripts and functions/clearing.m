
function [Q,X,L,SW]=clearing(offers,varargin)

global K
global N

M=size(offers,2);
q=cell(1,M);
x=cell(1,M);
A=cell(1,M);
F=cell(1,M);
for m=1:M
    A(m)=offers(2,m);
    F(m)=offers(3,m);
    L=size(A{m},2)-K*N-1;
    q(m)={sdpvar(K*N,1)};
    x(m)={sdpvar(L,1)};
end


Objective=0;
Balance=zeros(K*N,1);
Constraints=[];
for m=1:M
    Objective=Objective+F{m}'*[q{m};x{m}];
    Balance=Balance+q{m};
    Constraints=[Constraints;A{m}*[1;q{m};x{m}]<=0];
end
Constraints=[Constraints;(Balance==0):'Balance'];

ops=sdpsettings('solver','LINPROG','verbose',0,'showprogress',0);
sol=optimize(Constraints,Objective,ops);

if isempty(varargin)
    if sol.problem==0
        disp('Clearing succesful.');
    else
        disp('Clearing failed!');
    end
end

Q=zeros(K,N,M);
X=cell(1,M);
for m=1:M
    for n=1:N
        Q(:,n,m)=value(q{m}(K*(n-1)+1:K*n));
    end
    X(m)={value(x{m})};
end
Lcol=-dual(Constraints('Balance'));
L=zeros(K,N);
for n=1:N
    L(:,n)=Lcol(K*(n-1)+1:K*n);
end

SW=-value(Objective);

end