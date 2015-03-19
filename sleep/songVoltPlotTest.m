rs = input('where is extracted data located? ', 's');
load(strcat(rs, '_MANUALCLUST/extracted_data.mat'));

figure();
sh(1) = subplot(2,1,1);
title('Song');
sh(2) = subplot(2,1,2);
title('Voltage traces');
axis tight;
hold on
for i=1:length(agg_data.filename)
	%load(agg_data.filename{i}, 'ephys', 'audio');
	subplot(2,1,1);
	specgram(agg_audio.data(:,i));
	subplot(2,1,2);
	

	plot(bandpassFiltData(double(agg_data.data(:,i)), [300 3e3]/agg_data.fs, 5));
	clear ephys audio
	pause(1); % give a chance to look a the data to make sure it is right
end

hold off

