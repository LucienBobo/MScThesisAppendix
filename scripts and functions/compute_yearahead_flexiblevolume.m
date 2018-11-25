
function [expProf_nofutures,minProf_nofutures,expProf_withfutures,minProf_withfutures,minProf_withfutures_analytical,riskav_nofutures,riskav_withfutures]=compute_yearahead_flexiblevolume(A_s,F_s,Q_f,X_f,L_f,lambda,OpportunityCost,displayDistrib,alpha,beta)

% A_s is the feasibility region offered at the spot market
% Q_f (KxN) is quantity of futures awarded in auction
% L_f (KxN) is futures auction prices
% lambda (SxKxN) are spot price scenarios

global K
global N

%% Computing profit-maximising dispatch for all spot price scenarios

ns=size(lambda,1);

Q = sdpvar(K*N,ns,'full');
I = size(A_s,2);
L = I-K*N-1;
X = sdpvar(L,ns,'full');

CostSpot = sdpvar(ns,1,'full');
CostOperations = sdpvar(ns,1,'full');
CostPrices = sdpvar(ns,1,'full');

% Expected cost
for s=1:ns
    lambda_s=permute(lambda(s,:,:),[2,3,1]);
    CostOperations(s)=F_s'*[Q(:,s);X(:,s)];
    CostPrices(s)=-lambda_s(:)'*Q(:,s);
    CostSpot(s)=CostOperations(s)+CostPrices(s);
end

Obj=sum(CostSpot)/ns;

% Feasibility in all scenarios
Cons=[];
for s=1:ns
    Cons=[Cons; A_s*[1;Q(:,s);X(:,s)]<=0];
end

ops=sdpsettings('verbose',0);
optimize(Cons,Obj,ops);

%% Computing expected profit for spot market only (risk-neutral)

expProf_nofutures=-value(Obj)-OpportunityCost;
minProf_nofutures=min(-value(CostSpot))-OpportunityCost;

% Risk-averse expected profit
allProfits=-value(CostSpot)-OpportunityCost;
Exp_neutral=sum(allProfits)/ns;
sorted=sort(allProfits);
n_worst=max(1,round((1-alpha)*ns));
Exp_worst=sum(sorted(1:n_worst))/n_worst;
riskav_nofutures=(1-beta)*Exp_neutral+beta*Exp_worst;



%% Computing expected profit incl. futures (risk-neutral)

auction_income=Q_f(:)'*L_f(:);

% convention used: >0 if actor has to pay
futures_settlement=zeros(ns,1);
for s=1:ns
    lambda_s=permute(lambda(s,:,:),[2,3,1]);
    futures_settlement(s)=Q_f(:)'*lambda_s(:);
end

expProf_withfutures=-value(Obj)-sum(futures_settlement)/ns+auction_income-OpportunityCost;
minProf_withfutures=min(-value(CostSpot)-futures_settlement)+auction_income-OpportunityCost;

% This value is positive if:
%  - the actor derives a surplus from the financial auction due to good prices
%  - the actor made the prices increase by bidding at higher costs / lower WTP
%  (basically just as with the other actors)
minProf_withfutures_analytical=auction_income-F_s'*[Q_f(:);X_f]-OpportunityCost;

% Risk-averse expected profit
allProfits=-value(CostSpot)-futures_settlement+auction_income-OpportunityCost;
Exp_neutral=sum(allProfits)/ns;
sorted=sort(allProfits);
n_worst=max(1,round((1-alpha)*ns));
Exp_worst=sum(sorted(1:n_worst))/n_worst;
riskav_withfutures=(1-beta)*Exp_neutral+beta*Exp_worst;


%%

if displayDistrib
    
    vals_with=-value(CostSpot)-futures_settlement+auction_income-OpportunityCost;
    vals_without=-value(CostSpot)-OpportunityCost;
    
    binSize=max(...
        (max([vals_with])-min([vals_with]))/10,...
        (max([vals_without])-min([vals_without]))/10);
%     binSize=max(...
%         (max([vals_with])-min([vals_with]))/30,...
%         (max([vals_without])-min([vals_without]))/30);
    
    up=ceil(max([vals_without;vals_with])/1000)*1000;
    lo=floor(min([vals_without;vals_with])/1000)*1000;
%     lo=0;
    cnt_with=hist(vals_without,lo:binSize:up);
    cnt_without=hist(vals_with,lo:binSize:up);
    height=ceil(max([cnt_with,cnt_without])/20)*20;
    
    figure;
    
    subplot(2,1,1);
    hist(vals_without,lo:binSize:up); hold on
%     plot([0,0],[0,height],'-r');
%     plot([expProf_nofutures,expProf_nofutures],[0,height],'-k');
    xlim([-500+min(0,lo),max(0,up)+500]);
    ylim([0,height]);
%     xlim([-5000,65000]);
%     ylim([0,50]);
%     legend('Profit distribution','Guaranteed minimum','Expected value');
    title('Without acquisition of futures');
    ylabel('Forecast probability (%)');
    set(gca,'YTick',(0:20:height),'YTickLabel',(0:20:height)*100/ns);
    
    
    subplot(2,1,2);
    hist(vals_with,lo:binSize:up); hold on
%     plot([minProf_withfutures_analytical,minProf_withfutures_analytical],[0,height],'-r');
%     plot([expProf_withfutures,expProf_withfutures],[0,height],'-k');
    xlim([-500+min(0,lo),max(0,up)+500]);
    ylim([0,height]);
%     xlim([-5000,65000]);
%     ylim([0,50]);
%     legend('Profit distribution','Guaranteed minimum','Expected value');
    title('With acquisition of futures');
    xlabel('Profit (€)');
    ylabel('Forecast probability (%)');
    set(gca,'YTick',(0:20:height),'YTickLabel',(0:20:height)*100/ns);
end

%% DEBUG: comparing the value of different variables in all price scenarios
% IncomeOperations=-round(value(CostOperations));
% IncomePrices=-round(value(CostPrices));
% IncomeSpot=-round(value(CostSpot));
% FuturesSettlement=-round(futures_settlement);
% NetIncomeDelivery=round(-futures_settlement-value(CostSpot));
% NetIncomeLowBound=-round(F_s'*[Q_f(:);X_f(:)]*ones(ns,1));
% AuctionIncome=round(auction_income*ones(ns,1));
% TotalIncome=NetIncomeDelivery+AuctionIncome;
% HeatOnlyIncome=-8580*ones(ns,1);
% 
% global tabSum
% 
% tabSum=table(IncomeOperations,IncomePrices,IncomeSpot,...
%     FuturesSettlement,NetIncomeDelivery,NetIncomeLowBound,AuctionIncome,...
%     TotalIncome,HeatOnlyIncome);

end
