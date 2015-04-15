function scrambled = phase_scramble(data, scramble_amount)
	y = fft(data);
	alpha = abs(y);
	theta = angle(fft(rand(length(data), 1)));
	temp = real(ifft(alpha.*exp(i*theta)));
	for j=1:scramble_amount
		theta = angle(fft(rand(length(data),1)));
		temp = real(ifft(alpha.*exp(i*theta)));
	end

	scrambled = temp;
end