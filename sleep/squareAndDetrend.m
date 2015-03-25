function dataResult=squareAndDetrend(data, windowLength)
	
	s = size(data);
	if (s(1)>1 && s(2)>1)
		% find the average of the song data first
		meanTemp = mean(data, 2);
		% square the average
		temp = meanTemp.^2;
		% smooth the average
		temp = smoothData(temp, windowLength);
		
		meanOfAll = mean(temp);
		dataResult = temp - meanOfAll;
	else
		% square the data
		temp = data.^2;

		% smooth the data
		temp = smoothData(temp, windowLength);
		meanOfAll = mean(temp);
		% subtract the mean
		dataResult = temp - meanOfAll;
	end
end