function plotAndSaveDataSmall(matches, songData, filteredSleep, sleep, time, fileAssoc)
	
	templateLength = length(songData);
	
	% filter data to only show the matches
	n = 1:length(filteredSleep);
	tt = time(matches);
	ff = filteredSleep(matches);
	[pks, locs] = findpeaks(double(ff));

	% use locs in tt, find time, find index in time, use that index
	% in the sleep data

	
	for i=1:length(locs)
		ind1 = tt(locs(i));
		k = find(time==ind1,1);
		index = k-(templateLength-1):k;

		if(index>0)
			f = figure();
			sh(1) = subplot(3,1,1);
			
			plot(time(index), songData);

			title('Squared and smoothed song trace');
			axis tight;

			sh(2) = subplot(3,1,2);
			
			plot(time(index), sleep(index));
			title('Potential match');

			sh(3) = subplot(3,1,3);
			
			plot(time(index), filteredSleep(index), 'k', time(k), filteredSleep(k), 'g*');
			title('The filtered sleep data');
			linkaxes(sh, 'x');


			st = sprintf('fig%d_%s', i, fileAssoc);

			savefig(f, strcat('figs/small/fig/', st, '.fig'));
			saveas(f, strcat('figs/small/png/', st, '.png'), 'png');

			% pause(2);

			close(f);
		end
	end

end