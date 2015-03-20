function plotAndSaveDataCumulative(matches, songData, filteredSleep, sleep, time)
	
	templateLength = length(songData);
	f = figure();
	sh(1) = subplot(3,1,1);
	title('Squared and smoothed song trace');
	plot(time(1:templateLength), songData);
	hold on
	sh(2) = subplot(3,1,2);
	title('Matches');
	plot(time, sleep, 'k');

	sh(3) = subplot(3,1,3);
	title('The filtered sleep data');
	plot(time, filteredSleep, 'k', time(matches), filteredSleep(matches, 'g*');

	for i=1:length(matches) 
		index = matches(i) - templateLength + 1;
		subplot(3,1,2);
		plot(time(index:matches(i)), sleep(index:matches(i)), 'g');

	end

	st = sprintf('cumulative_fig_%s', fileAssoc);

	savefig(f, strcat('figs/cumulative/fig/', st));
	saveas(f, strcat('figs/cumulative/png/', st, '.png'));

end