function [ a1, ax, ay, w ] = est_tps( ctr_pts, target_value )
%EST_TPS Summary of this function goes here
%   This function estimates the value of the TPS function parameters values
Xs = ctr_pts(:,1);
Ys = ctr_pts(:,2);
[rows, ~] = size(Xs);
X1 = repmat(Xs, 1, rows);
X2 = repmat(Xs', rows, 1);
diff_x = X1-X2;

[rowsy, ~] = size(Ys);
Y1 = repmat(Ys, 1, rowsy);
Y2 = repmat(Ys', rowsy, 1);
diff_y = Y1-Y2;

r_square = diff_x.^2 + diff_y.^2;

K = (r_square).*log(r_square);
K(isnan(K)) = 0;
K = -K;

P = [ctr_pts ones(size(ctr_pts, 1), 1)];

lambda = 10.^-12; %Almost the same as having lambda as 0
size_eye = size(ctr_pts, 1)+ 3;
solution = ([K P; transpose(P) zeros(3)] + lambda*eye( size_eye))\[target_value; 0; 0; 0];
a1 = solution(end);
ax = solution(end - 2);
ay = solution(end - 1);
w = solution(1:end-3);
end

