function solution = Solve(matrix)
	[rows, cols] = size(matrix);
	core = matrix(:, 1 : rows);
	trig = diag(ones(1, rows)) + diag(ones(1, rows - 1), 1) + diag(ones(1, rows - 1), -1);
	if max(abs(core - core .* trig)) < 1e-10
		rSide = matrix(:, rows + 1 : end);
		gam = delt = zeros(rows + 1, cols - rows);
		for i = rows : -1 : 2
			gam(i, :) = -matrix(i, i - 1) ./ (matrix(i, i) + gam(i + 1, :) * matrix(i, i + 1));
			delt(i, :) = (rSide(i, :) - matrix(i, i + 1) .* delt(i + 1, :)) ./ (matrix(i, i) + gam(i + 1, :) * matrix(i, i + 1));
		end;
		solution = zeros(rows, cols - rows);
		solution(1, :) = (rSide(1, :) - matrix(1, 2) * delt(2, :)) ./ (matrix(1, 1) + gam(2, :) * matrix(1, 2));
		for i = 2 : rows
			solution(i, :) = gam(i, :) .* solution(i - 1, :) + delt(i, :); 
		end;
	else
		error('wrong matrix');
	end;
end;
