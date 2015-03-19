% plot graphs for the dataset continuously in 2.5 second intervals

files = dir('*.mat');
[b,a] = ellip(3, .2, 60, [200 2e3]/(20e3/2), 'bandpass');
mkdir('figures');

for i=1:length(files)
	load(files(i).name);
	disp(files(i).name);
	if (~exist('ephys', 'var'))
		ephys.data(:,1) = amp.data(1,:);
		ephys.data(:,2) = amp.data(2,:);
		ephys.fs = params.amplifier_sample_rate;
		ephys.t = amp.t;
		audio.t = adc.t;
		audio.data(:,1) = adc.data(1,:);
	end
	fileLength = length(ephys.data(:,1));
	plotLength = 1:2.5*ephys.fs;
	numPlots = int64(fileLength/(2.5*ephys.fs));
	newT = linspace(0,fileLength/ephys.fs, fileLength);

	filtCh(:,1) = ephys.data(:,1) - ephys.data(:,2);
	filtCh(:,2) = filtfilt(b,a, filtCh(:,1));


	%filtCh(:,3) = abs(filtCh(:,1)) - abs(filtCh(:,2));
	%filtCh(:,3) = smooth(filtCh(:,2), 10000);

	for j=1:numPlots
		s = sprintf('Plotting plot %d', j);
		disp(s)
		newIndex = ((j-1)*2.5*ephys.fs)+1:j*2.5*ephys.fs;
		f = figure();
		sh(1) = subplot(2,1,1);
		if (newIndex(end) > fileLength)
			%temp = length(filtCh(newIndex(1):end, 4));
			plot(newT(newIndex(1):end), filtCh(newIndex(1):end,2));
		else
			plot(newT(newIndex), filtCh(newIndex,2));
		end
		title('ch1 subtracted from abs value of ch2');
		axis tight;

		sh(2) = subplot(2,1,2);
		if(newIndex(end)> fileLength)
			plot(newT(newIndex(1):end), filtCh(newIndex(1):end, 1), 'g');
			hold on;
            line([newT(newIndex(1)) newT(newIndex(end))], [0 0], 'Color', 'r');
            hold off;
		else
			plot(newT(newIndex), filtCh(newIndex,1), 'g');
			hold on;
            line([newT(newIndex(1)) newT(newIndex(end))], [0 0], 'Color', 'r');
            hold off;
		end
		title('Raw Subtraction');
		xlabel('Time (s)');
		ylabel('Voltage (uV)');
		linkaxes(sh, 'x');

		% sh(1) = subplot(3,1,3);
		% if (newIndex(end) > fileLength)
		% 	specgram(audio.data(newIndex(1):end));
		% else
		% 	specgram(audio.data(newIndex));
		% end
		
		%set(gcf, 'Units', 'Inches', 'Position', [0, 0, 22, 14], 'PaperUnits', 'Inches', 'PaperSize', [22, 14]);
		saveas(f, strcat('figures/', 'diff_', files(i).name(1:end-4), '-', num2str(j)), 'png');
        %savefig(f, strcat('figures/',files(i).name(1:end-4), '-', num2str(j)));
        close(f);

    end

    clear filtCh

end
