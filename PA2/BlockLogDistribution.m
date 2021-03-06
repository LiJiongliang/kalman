%BLOCKLOGDISTRIBUTION
%
%   LogBS = BlockLogDistribution(V, G, F, A) returns the log of a
%   block-sampling array (which contains the log-unnormalized-probabilities of
%   selecting each label for the block), given variables V to block-sample in
%   network G with factors F and current assignment A.  Note that the variables
%   in V must all have the same dimensionality.
%
%   Each entry in LogBS is the log-probability that that value is selected.
%   LogBS is the P(V | X_{-v} = A_{-v}, all X_i in V have the same value), where
%   X_{-v} is the set of variables not in V and A_{-v} is the corresponding
%   assignment to these variables consistent with A.  In the case that |V| = 1,
%   this reduces to Gibbs Sampling.  NOTE that exp(LogBS) is not normalized to
%   sum to one.
function LogBS = BlockLogDistribution(V, G, F, A)
if length(unique(G.dim(V))) ~= 1
    disp('WARNING: trying to block sample invalid variable set');
    return;
end

% d is the dimensionality of all the variables we are extracting
d = G.dim(V(1));

LogBS = zeros(1, d);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
% Compute LogBS by multiplying (adding in log-space) in the correct values from
% each factor that includes some variable in V.  To make this fast, you
% should make use of G.var2factors and the functions intersect, repmat, and
% GetValuesOfAssignments.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Loop over factors to determine the probability that
% each one is sampled in the possible ways

% get a list of the factors of interest
factors = F(unique([G.var2factors{V}]));

for i = 1:length(factors),
    factor = factors(i);
    
    % determine which sampling vars this factor contains
    [sampling_vars,sampling_indices] = intersect(factor.var,V);
    
    % build up assignments of interest
    assignments = repmat(A(factor.var), d, 1);
    assignments(:,sampling_indices) = repmat((1:d)',1,length(sampling_indices));

    % find distribution given that evidence
    probs = GetValuesOfAssignments(factor, assignments);

    % update LogBS
    LogBS = LogBS + log(probs);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Re-normalize to prevent underflow when you move back to probability space
LogBS = LogBS - min(LogBS);



