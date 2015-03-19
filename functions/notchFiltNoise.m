function filteredData=notchFiltNoise(data, freq, fs)
	wo = freq/(fs/2);
	bw = wo/35; %bandwidth
	[b,a] = iirnotch(wo, bw);
	% fvtool(b,a);
	filteredData = filtfilt(b,a, data);
end