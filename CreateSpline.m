function [interpolationSpline] = CreateSpline(points, func)
	if strcmp(class(func), 'function_handle')
		values = arrayfun(func, points);
	elseif length(func) == length(points)
		values = func;
	else
		error('Unknown format of input argument func.');
	end;
	if isrow(values)
		values = values';
	end;
	matrix = CreateSEMatrix(points, values);
	solution = SolveSE(matrix);
	interpolationSpline = FormSpline(points, values, solution);
end;