function plotAndSaveDataSmall(matches, songData, filteredSleep, sleep, time, fileAssoc)
	
	templateLength = length(songData);
	for i=1:length(matches) 
		index = matches(i) - templateLength + 1;

		f = figure();
		sh(1) = subplot(3,1,1);
		title('Squared and smoothed song trace');
		plot(time(index:matches(i)), songData);

		sh(2) = subplot(3,1,2);
		title('Potential match');
		plot(time(index:matches(i)), sleep(index:matches(i)));

		sh(3) = subplot(3,1,3);
		title('The filtered sleep data');
		plot(time(index:matches(i)), filteredSleep(index:matches(i)), 'k', time(matches(i)), filteredSleep(matches(i)), 'g*');

		st = sprintf('fig%d_%s', i, fileAssoc);

		savefig(f, strcat('figs/small/fig/', st));
		saveas(f, strcat('figs/small/png/', st, '.png'));
	end

end