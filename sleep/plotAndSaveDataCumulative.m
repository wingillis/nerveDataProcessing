function plotAndSaveDataCumulative(matches, songData, filteredSleep, sleep, time, fileAssoc)
	if(length(matches)>0)
		templateLength = length(songData);
		f = figure();
		sh(1) = subplot(3,1,1);
		plot(time(1:templateLength), songData);
		title('Squared and smoothed song trace');
		axis tight;
		hold on
		sh(2) = subplot(3,1,2);

		plot(time, sleep, 'k');
		title('Matches');
		axis tight;

		sh(3) = subplot(3,1,3);
		
		plot(time, filteredSleep, 'k', time(matches), filteredSleep(matches), 'go');
		title('The template filtered sleep data');

		for i=1:length(matches) 
			index = matches(i) - templateLength + 1;

			if(index>0)

				subplot(3,1,2);
				hold on;
				plot(time(index:matches(i)), sleep(index:matches(i)), 'g');
			end

		end

		linkaxes(sh(2:3), 'x');

		st = sprintf('cumulative_fig_%s', fileAssoc);

		savefig(f, strcat('figs/cumulative/fig/', st, '.fig'));
		saveas(f, strcat('figs/cumulative/png/', st, '.png'), 'png');

		% pause(2);

		close(f);
	end

end