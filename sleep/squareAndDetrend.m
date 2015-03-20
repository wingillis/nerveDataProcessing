function dataResult=squareAndDetrend(data)
	% find the mean of the squared data
	s = size(data);
	temp = data(:,:).^2;
	if (s(1)>1 && s(2)>1)
		% this is intended to average the song data together
		meanTemp = mean(temp');
		meanOfAll = mean(meanTemp);
		dataResult = meanTemp - meanOfAll;
	else
		meanOfAll = mean(temp);
		% subtract the mean
		dataResult = temp - meanOfAll;
	end
end