function [windowed_data] = window_data(data, window_length, smoothing_window)
	stop_for_loop = round(length(data)/window_length);
	windowed_data = zeros(window_length, stop_for_loop);
	for i=1:stop_for_loop
		indices = (1:window_length) + (window_length * (i-1));
		if(indices(end)>length(data))
			% segment = data(indices(1):end);
		else
			segment = data(indices);
		end
		processed_data = squareAndDetrend(segment, smoothing_window);
		windowed_data(:,i) = processed_data;

	end

end