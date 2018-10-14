function slope = linear_regression_slope(x,y)
X = [ones(length(x),1) x];
b = X\y;
slope = b(2);