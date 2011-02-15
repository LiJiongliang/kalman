%SETVALUEOFASSIGNMENT Sets the value of a variable assignment in a factor.
%
%   F = SETVALUEOFASSIGNMENT(F, A, v) sets the value of a variable assignment,
%   A, in factor F to v. The order of the variables in A are assumed to be the
%   same as the order in F.var.
%
%   F = SETVALUEOFASSIGNMENT(F, A, v, VO) sets the value of a variable
%   assignment, A, in factor F to v. The order of the variables in A are given
%   by the vector VO.
%
%   See also GETVALUEOFASSIGNMENT

% CS228 Probabilistic Models in AI (Winter 2007)
% Copyright (C) 2007, Stanford University

function F = SetValueOfAssignment(F, A, v, VO);

if (nargin == 3),
    indx = AssignmentToIndex(A, F.dim);
else
    map = zeros(length(F.var), 1);
    for i = 1:length(F.var),
        map(i) = find(VO == F.var(i));
    end;
    indx = AssignmentToIndex(A(map), F.dim);
end;

F.val(indx) = v;
