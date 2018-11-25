
close all
clc;
clear;
addpath(genpath('scripts and functions'));

%% Global parameters

global K % number of time steps
global N % number of nodes
K=24;
N=2;

%% Derivatives market clearing

scenarios;  % Generates spot price scenarios
derivatives_bids;

disp('Clearing futures auction...');
[Q_f,X_f,L_f,SW_f]=clearing(offers_f);
% with M the number of participants:
%   - Q_f is a matrix KxNxM
%   - X_f is a cell array 1xM
%   - L_f is a vector KxN


%% Spot realisation A

ws=0; % wind time offset
wa=1; % wind amplitude change
la=1; % load amplitude change

disp('Clearing spot market...');
[Q_s,X_s,L_s,SW_s]=clearing(offers_s);
% with S the number of participants:
%   - Q_s is a matrix KxNxS
%   - X_s is a cell array 1xS
%   - L_s is a vector KxN

analyses;

%% Spot realisation B

ws=8; % wind time offset
wa=1.3; % wind amplitude change
la=0.8; % load amplitude change
spot_auction;

disp('Clearing spot market...');
[Q_s,X_s,L_s,SW_s]=clearing(offers_s);
% with S the number of participants:
%   - Q_s is a matrix KxNxS
%   - X_s is a cell array 1xS
%   - L_s is a vector KxN

analyses;
