function [] = main(f, x, graphx)
	if !exist('f')
		f = @(t)(sin(t^2));
	end;
	if !exist('x')
		x = ((0 : 0.05 : 1).^(3/5)) * 5;
	end;
	if !exist('graphx')
		graphx = 0 : 0.001 : 5;
	end;

	[interpolSpline, splinef] = CreateSpline(x, f);
	spline0 = @(t)(splinef(0, t));
	spline1 = @(t)(splinef(1, t));
	spline2 = @(t)(splinef(2, t));

	figure('units','normalized','outerposition',[0 0 1 1], 'paperorientation', 'landscape');
	if strcmp(class(f), 'function_handle')
		plot(graphx, arrayfun(f, graphx), 'g', graphx, arrayfun(spline0, graphx), 'r', x, arrayfun(f, x), 'kx');
		legend('interpolated function', 'interpolation spline', 'pivot x', 'location', 'southoutside');
	else
		plot(graphx, arrayfun(spline0, graphx), 'k', x, arrayfun(f, x), 'kx');
		legend('interpolation spline', 'pivot x', 'location', 'southoutside');
	end;
	title(sprintf('Maximal deviation: %e', max(abs(arrayfun(f, x) - arrayfun(spline0, x)))));
	grid minor;
	print -dpdf ./result.pdf;
	figure('units','normalized','outerposition',[0 0 1 1], 'paperorientation', 'landscape');
	plot(graphx, arrayfun(spline1, graphx), 'g', graphx, arrayfun(spline2, graphx), 'k');
	legend('spline first derivative', 'spline second derivative', 'location', 'southoutside');
	grid minor;
	print -dpdf -append ./result.pdf;
end;
