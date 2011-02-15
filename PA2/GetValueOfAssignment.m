%GETVALUEOFASSIGNMENT Gets the value of a variable assignment in a factor.
%
%   v = GETVALUEOFASSIGNMENT(F, A) returns the value of a variable assignment,
%   A, in factor F. The order of the variables in A are assumed to be the
%   same as the order in F.var.
%
%   v = GETVALUEOFASSIGNMENT(F, A, VO) gets the value of a variable assignment,
%   A, in factor F. The order of the variables in A are given by the vector VO.
%
%   See also SETVALUEOFASSIGNMENT

% CS228 Probabilistic Models in AI (Winter 2007)
% Copyright (C) 2007, Stanford University

function v = GetValueOfAssignment(F, A, VO);

if (nargin == 2),
    indx = AssignmentToIndex(A, F.dim);
else
    map = zeros(length(F.var), 1);
    for i = 1:length(F.var),
        map(i) = find(VO == F.var(i));
    end;
    indx = AssignmentToIndex(A(map), F.dim);
end;

v = F.val(indx);
