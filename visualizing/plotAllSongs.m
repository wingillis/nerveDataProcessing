f = figure();
for i=1:size(agg_audio.data, 2)
	specgram(agg_audio.data(:,i))
	title(sprintf('%d', i));
	pause(0.3)
end

close(f)