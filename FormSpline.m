function interpolSpline = FormSpline(x, y, solution)
	n = length(x);
	segments = x(2 : end) - x(1 : end - 1);
	deltas = (y(2 : end) - y(1 : end - 1)) ./ segments(1 : end);

	interpolSpline = [solution / 2, zeros(n, 1), y];
	interpolSpline(:, 2) = [deltas(1) - 0.125 * segments(1) * (3 * solution(1) + solution(2));...
	 deltas(1 : end) + 0.125 * segments(1 : end) .* (solution(1 : end - 1) + 3 * solution(2 : end))];
end;
