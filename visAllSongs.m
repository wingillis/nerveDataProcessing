f = figure(1);
for i=1:size(agg_audio.data, 2)
	specgram(agg_audio.data(:,i));
	pause(0.5);
	%delay(1);
end
