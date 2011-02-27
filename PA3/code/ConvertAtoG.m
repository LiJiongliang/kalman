% CS228 PA3 Winter 2011
% File: ConvertAtoG.m
% Copyright (C) 2011, Stanford University
% contact: Huayan Wang, huayanw@cs.stanford.edu

function G = ConvertAtoG(A)

G = zeros(10,2);
A = A + A';

G(1,:) = [0 0];
visited = zeros(10,1);
visited(1) = 1;


cnt = 0;
while sum(visited) < 10
    cnt = cnt+1;
    for i=2:10
        for j=1:10
            if A(i,j) == 1 && visited(j)
                visited(i) = 1;
                G(i,1) = 2;
                G(i,2) = j;
                break;
            end
        end
    end
end