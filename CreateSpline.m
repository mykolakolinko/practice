function [interpolationSpline] = CreateSpline(points, func, degree, fault = 1, ConditionType = 0, SECreationMethod = 0, SESolvingMethod = 0)
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
	matrix = CreateSEMatrix(points, func, degree, SECreationMethod);
	solution = SolveSE(matrix, SESolvingMethod);
	interpolationSpline = FormSpline(points, func, degree, fault, matrix, SECreationMethod, ConditionType);
end;