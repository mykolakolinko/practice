function [matrix, splineX] = CreateMatrix(x, y)
	n = length(x);
	segments = x(2 : end) - x(1 : end - 1);
	splineX = x(2 : end) - segments / 2;
	deltas = (y(2 : end) - y(1 : end - 1)) ./ segments(1 : end);
	matrix = [diag(segments(1 : end - 1)), zeros(n - 2, 2)] + [zeros(n - 2, 2), diag(segments(2 : end))] +...
	 3 * [zeros(n - 2, 1), diag(segments(1: end - 1)) + diag(segments(2 : end)), zeros(n - 2, 1)];
	matrix = [-1, 1, zeros(1, n - 2); matrix; zeros(1, n - 2), 1, -1];
	rSide = [0; 8 * (deltas(2 : end)  - deltas(1 : end - 1)); 0];
	matrix = [matrix, rSide];
	
	matrix(2, :) -= matrix(1, :) * matrix(2, 1);
	matrix(end - 1, :) -= matrix(end, :) * matrix(end - 1, end - 1);
end;
