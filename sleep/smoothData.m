function smoothedData=smoothData(data, windowLength)
	
	b = ones(windowLength, 1)./windowLength;
	a = 1;
	% smoothed result
	smoothedData = filter(b,a, data);
	
end