function [interpolSpline, splinef] = CreateSpline(x, func)
	if strcmp(class(func), 'function_handle')
		y = arrayfun(func, x);
	elseif length(func) == length(x)
		y = func;
	else
		error('Unknown format of input argument func.');
	end;
	if isrow(x)
		x = x';
	end;
	if isrow(y)
		y = y';
	end;
	[matrix, splineX] = CreateMatrix(x, y);
	solution = Solve(matrix);
	interpolSpline = FormSpline(x, y, solution);
	splinef = @(derivative, t)(EvaluateSpline(x, splineX, interpolSpline, derivative, t));
end;

function result = EvaluateSpline(x, splineX, interpolSpline, derivative, t)
	[row, segmentValue] = SelectRow(x, splineX, interpolSpline, t);
	Coeff = EvaluateCoeff(length(row), derivative);
	powers = segmentValue .^ (length(row) - derivative - 1 : -1 : 0);
	result = sum(row(1 : length(powers)) .* powers .* Coeff(1 : length(powers)));
end;

function Coeff = EvaluateCoeff(rowLength, derivative)
	if derivative == 0
		Coeff = ones(1, rowLength);
		return;
	end;
	Coeff = prod((ones(derivative, 1) * (rowLength - 1 : -1 : 0)) - ((0 : derivative - 1)' * ones(1, rowLength)), 1);
end;

function [row, segmentValue] = SelectRow(x, splineX, interpolSpline, t)
	i = max([0; find((t - splineX) >= 0)]) + 1;
	row = interpolSpline(i, :);
	segmentValue = t - x(i);
end;
