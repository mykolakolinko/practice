function [] = main(func, points, plotPoints, leftCondition)
	if ~exist('func')
		func = @(t)(sin(t^2));
	end;
	if ~exist('points')
		points = sqrt(0 : 0.2 : 1) * 5;
	end;
	if ~exist('plotPoints')
		plotPoints = 0 : 0.01 : 5;
	end;
	if ~exist('leftCondition')
		leftCondition = 0;
	end;

	interpolationSpline = CreateSpline(points, func, leftCondition);
	splineVal = @(t)(EvaluateSpline(points, interpolationSpline, 0, t));
	splineDerivative = @(t)(EvaluateSpline(points, interpolationSpline, 1, t));
	splineSecondDerivative = @(t)(EvaluateSpline(points, interpolationSpline, 2, t));

	figure('units','normalized','outerposition',[0 0 1 1], 'paperorientation', 'landscape');
	plot(plotPoints, arrayfun(func, plotPoints), 'k-.', plotPoints, arrayfun(splineVal, plotPoints), 'k', points, arrayfun(func, points), 'kx');
	legend('interpolated function', 'interpolation spline', 'pivot points', 'location', 'southoutside');
	title(sprintf('Maximal deviation: %e', max(abs(arrayfun(func, plotPoints) - arrayfun(splineVal, plotPoints)))));
	grid minor;
	print -dpdf ./result.pdf;
	figure('units','normalized','outerposition',[0 0 1 1], 'paperorientation', 'landscape');
	plot(plotPoints, arrayfun(splineDerivative, plotPoints), 'k--', plotPoints, arrayfun(splineSecondDerivative, plotPoints), 'k');
	legend('spline first derivative', 'spline second derivative', 'location', 'southoutside');
	grid minor;
	print -dpdf -append ./result.pdf;
end;

function result = EvaluateSpline(points, interpolationSpline, derivative, t)
	[row, relativeValue] = SelectRow(points, interpolationSpline, t);
	if row == 0
		result = 0;
		return;
	end;
	coefficients = EvaluateCoefficients(length(row), derivative);
	powers = relativeValue .^ (length(row) - derivative - 1 : -1 : 0);
	result = sum(row(1 : length(powers)) .* powers .* coefficients(1 : length(powers)));
end;

function coefficients = EvaluateCoefficients(rowLength, derivative)
	if derivative == 0
		coefficients = ones(1, rowLength);
		return;
	end;
	coefficients = prod((ones(derivative, 1) * (rowLength - 1 : -1 : 0)) - ((0 : derivative - 1)' * ones(1, rowLength)), 1);
end;

function [row, relativeValue] = SelectRow(points, interpolationSpline, t)
	if t < points(1)
		row = 1;
		relativeValue = 0;
		return;
	end;
	if t >= points(end)
		row = interpolationSpline(end, :);
		relativeValue = t - points(end - 1);
		return;
	end;

	points = t - points;
	interpolationSpline = interpolationSpline(points >= 0, :);
	row = interpolationSpline(end, :);
	points = points(points >= 0);
	relativeValue = points(end);
end;