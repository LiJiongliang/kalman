% CS228 PA3 Winter 2011
% File: DrawGraph.m
% Copyright (C) 2011, Stanford University
% contact: Huayan Wang, huayanw@cs.stanford.edu

function DrawGraph(A)

% draw nodes

positions = [0 0; 0 1; -1.5 0.5; -3 -0.5; 1.5 0.5; 3 -0.5; -2 -2; -2.5 -3; 2 -2; 2.5 -3];
N = length(positions);

scatter(positions(:,1), positions(:,2), 200, 'blue', 'filled');

% draw edges
for i=1:N
    for j=i+1:N
        if A(i,j)>0 || A(j,i) > 0
            line([positions(i,1); positions(j,1)], ...
                [positions(i,2); positions(j,2)], 'Color', 'b', 'LineWidth', 3);
        end
    end
end

axis off

textsize = 18;

text(positions(1,1), positions(1,2), 'torso',...
	'VerticalAlignment','bottom',...
	'HorizontalAlignment','center',...
	'FontSize',textsize)
text(positions(2,1), positions(2,2), 'head',...
	'VerticalAlignment','bottom',...
	'HorizontalAlignment','center',...
	'FontSize',textsize)
text(positions(3,1), positions(3,2), 'L-arm',...
	'VerticalAlignment','bottom',...
	'HorizontalAlignment','center',...
	'FontSize',textsize)
text(positions(4,1), positions(4,2), 'L-forearm',...
	'VerticalAlignment','bottom',...
	'HorizontalAlignment','center',...
	'FontSize',textsize)
text(positions(5,1), positions(5,2), 'R-arm',...
	'VerticalAlignment','bottom',...
	'HorizontalAlignment','center',...
	'FontSize',textsize)
text(positions(6,1), positions(6,2), 'R-forearm',...
	'VerticalAlignment','bottom',...
	'HorizontalAlignment','center',...
	'FontSize',textsize)
text(positions(7,1), positions(7,2), 'L-thigh',...
	'VerticalAlignment','bottom',...
	'HorizontalAlignment','center',...
	'FontSize',textsize)
text(positions(8,1), positions(8,2), 'L-leg',...
	'VerticalAlignment','bottom',...
	'HorizontalAlignment','center',...
	'FontSize',textsize)
text(positions(9,1), positions(9,2), 'R-thigh',...
	'VerticalAlignment','bottom',...
	'HorizontalAlignment','center',...
	'FontSize',textsize)
text(positions(10,1), positions(10,2), 'R-leg',...
	'VerticalAlignment','bottom',...
	'HorizontalAlignment','center',...
	'FontSize',textsize)

