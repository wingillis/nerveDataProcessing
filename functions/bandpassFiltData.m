function filteredData = bandpassFiltData(data, lowhigh, order)
	% lowhigh
	% 	vector containing the low and high frequency cutoffs, divided
	%	by half the sampling frequency



	[b,a] = ellip(order, .2, 60, lowhigh, 'bandpass');

	filteredData = filtfilt(b,a, double(data));

end