
vals = zeros(1,size(spikes.times,2));

for i= 1:size(spikes.times, 2)
	vals(i) = max(dLower(1,spikes.times(i)-13:spikes.times(i)+13));
end

averageSpikeAmplitude = sum(vals)./size(spikes.times,2);
disp(averageSpikeAmplitude);

rmsData = rms(dLower);
snrData = snr(averageSpikeAmplitude, rmsData);
disp(snrData);