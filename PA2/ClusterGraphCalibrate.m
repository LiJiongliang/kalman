% CLUSTERGRAPHCALIBRATE Loopy belief propagation for cluster graph calibration.
%   P = CLUSTERGRAPHCALIBRATE(G, F) calibrates a given cluster graph, G,
%   and set of of factors, F. The function returns the final potentials for
%   each cluster. 
%   The cluster graph data structure has the following fields:
%       .names  Cell array containing the names of each variable [M]
%       .dim    Vector containing dimensionality of each variable [M]
%       .nodes  Cell array of variables in each clique [N]
%       .edges  Adjacency graph for clique tree [N-by-N]
%
%   See also FACTORPRODUCT, FACTORMARGINALIZATION

% CS228 Probabilistic Models in AI (Winter 2007)
% Copyright (C) 2007, Stanford University

function [P MESSAGES] = ClusterGraphCalibrate(G, F);

% number of cliques
N = length(G.nodes);

% compute assignment of factors to cliques
alpha = zeros(length(F), 1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
% Assign each factor to a clique
% alpha(i) should contain the index of the clique that factor i
% belongs to
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:length(F),
    for j = 1:length(G.nodes),
        if (all(ismember(F(i).var, G.nodes{j}))),
            alpha(i) = j;
        end;
    end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (any(alpha == 0)),
    warning('cluster graph does not have family preserving property');
end;

% initialize cliques potentials and MESSAGES
P = repmat(struct('var', [], 'dim', [], 'val', []), N, 1);
for i = 1:N,
    P(i).var = G.nodes{i};
    P(i).dim = G.dim(P(i).var);
    P(i).val = ones(1,prod(P(i).dim));
end;

MESSAGES = repmat(struct('var', [], 'dim', [], 'val', []), N, N);
[edgeFromIndx, edgeToIndx] = find(G.edges ~= 0);

for m = 1:length(edgeFromIndx),
    i = edgeFromIndx(m);
    j = edgeToIndx(m);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE
    % Set the initial message values
    % MESSAGES(i,j) should be set to the initial value for the
    % message from cluster i to cluster j
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    MESSAGES(i,j).var = intersect(G.nodes{i},G.nodes{j});
    MESSAGES(i,j).dim = G.dim(MESSAGES(i,j).var);
    MESSAGES(i,j).val = ones(1,prod(MESSAGES(i,j).dim));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
% Populate P with the initial potentials for each clique
% P(i) should contain the initial potential for clique i
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:length(F)
    P(alpha(i)) = FactorProduct(P(alpha(i)), F(i));
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%
% QUESTION 5.2
%%%%%%%%%

X1 = [];
X2 = [];
X3 = [];

maxX = 0;
maxY = 0;

%%%%%%%%%

% perform loopy belief propagation
tic;
iteration = 1;
m = 0;
lastMESSAGES = MESSAGES;
while (1),
    iteration = iteration + 1;

    %%% CHANGE THIS CRITERION LATER IN QUESTION 2 %%%
    % Select a message to pass
    i = edgeFromIndx(m+1);
    j = edgeToIndx(m+1);
    m = mod(m+1, length(edgeFromIndx));
    
    %%%%%%%%%%%
    % Question 5.2b
    % Approach: always pass the message with the highest residual
    %%%%%%%%%%%
    
%    if (maxX ~= 0 && maxY ~= 0),
%        i = maxX;
%        j = maxY;
%    end;
    
    %%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE
    % Select a message to pass, \delta_ij.
    % Compute the message from clique i to clique j and put it
    % in MESSAGES(i,j)
    % Finally, normalize the message to prevent overflow.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    delta_ij = P(i);
    
    for k = 1:length(P),
        if (G.edges(k,i) == 0), continue; end;
        if (j == k), continue; end;
        delta_ij = FactorProduct(delta_ij,MESSAGES(k,i));
    end;
    
    varsToElim = setdiff(P(i).var,P(j).var);
    MESSAGES(i,j) = FactorMarginalization(delta_ij,varsToElim);
    
    
%    if (i==29 && j==1),
%        X1 = [X1 MessageDelta(MESSAGES(i,j), lastMESSAGES(i,j))];
%    elseif (i==35 && j==6),
%        X2 = [X2 MessageDelta(MESSAGES(i,j), lastMESSAGES(i,j))];
%    elseif (i==27 && j==54),
%        X3 = [X3 MessageDelta(MESSAGES(i,j), lastMESSAGES(i,j))];
%    end;
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%
%    maxDelta = -5;
%    maxX = 0;
%    maxY = 0;
%    for x = 1:size(MESSAGES,1),
%        for y = 1:size(MESSAGES,2),
%            delta = MessageDelta(MESSAGES(x,y),lastMESSAGES(x,y));
%            maxDelta = max(maxDelta, delta);
%            if (maxDelta == delta),
%                maxX = x;
%                maxY = y;
%            end;
%        end;
%    end;

    %%%
    
    % Check for convergence every m iterations
    if mod(m, length(edgeFromIndx)) == 0
        disp(['LBP Messages Passed: ', int2str(iteration), '...']);
        if (CheckConvergence(MESSAGES, lastMESSAGES))
            break;
        end
        lastMESSAGES = MESSAGES;
    end
end;
toc;
disp(['Total number of messages passed: ', num2str(iteration)]);


%%%%%%%%%
% QUESTION 5.2
%%%%%%%%%

%subplot(131);
%plot(X1);

%subplot(132);
%plot(X2);

%subplot(133);
%plot(X3);

%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
% Compute final potentials and place them in P
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for j = 1:size(MESSAGES, 1),
    for i = 1:size(MESSAGES, 2),
        if (G.edges(i, j) == 0), continue; end;
        P(j) = FactorProduct(P(j), MESSAGES(i,j));
    end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get the max difference between the marginal entries of 2 messages -------
function delta = MessageDelta(Mes1, Mes2)
delta = max(abs(Mes1.val - Mes2.val));
return;

% CheckConvergence --------------------------------------------------
function converged = CheckConvergence(mNew, mOld);

converged = 1;
for i = 1:size(mNew, 1),
    for j = 1:size(mNew, 2),
        if (any(abs(mNew(i,j).val - mOld(i,j).val) > 1.0e-6)),
            converged = 0;
            return;
        end;
    end;
end;

return;
