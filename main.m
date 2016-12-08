function [] = main(func, points, plotPoints, leftCondition)
	interpolationSpline = CreateSpline(points, func, leftCondition);
	splineFunc = @(t)(evaluateSpline(points, interpolationSpline, t));
	splineDerFunc = @(t)(evaluateSplineDerivative(points, interpolationSpline, t));
	plot(plotPoints, arrayfun(func, plotPoints), 'k-.', plotPoints, arrayfun(splineFunc, plotPoints), 'k', plotPoints, arrayfun(splineDerFunc, plotPoints), 'k--');
	axis square;
	disp(max(abs(arrayfun(func, plotPoints) - arrayfun(splineFunc, plotPoints))));
end;

function result =  evaluateSpline(points, interpolationSpline, t)
	row = interpolationSpline(t >= points(1 : end - 1) , :)(end, :);
	point = points(t >= points(1 : end - 1))(end);
	result = sum(row .* ((t - point) .^ (length(row) - 1 : -1 : 0)));
end;

function result = evaluateSplineDerivative(points, interpolationSpline, t)
	row = interpolationSpline(t >= points(1 : end - 1) , :)(end, :);
	point = points(t >= points(1 : end - 1))(end);
	result = sum(row(1 : end - 1) .* ((t - point) .^ (length(row) - 2 : -1 : 0)) .* (length(row) - 1 : -1 : 1));
end;