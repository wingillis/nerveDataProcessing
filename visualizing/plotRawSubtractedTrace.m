function plotRawSubtractedTrace(ephys_data, audio_data, time, fs, code)
	% ephys data should be a 2-d matrix of results
	% 
	% given the raw ephys data and audio data, this
	% function plots different figures based on the code
	% given
	% supply the interval of plotting yourself, as this function
	% is not aware of your intended indices
	% code = 1
	%	plot just the raw ephys data
	% code = 2
	% 	plot notch filtered data
	% code = 3
	% 	plot bandpass filtered data
	% code = 4
	% 	plot both raw traces unsubtracted


	subt = ephys_data(:,1) - ephys_data(:,2);

	if (code>0)
		% plots fully filtered data
		fig1 = figure();
		subplot(2,1,1);
		specgram(audio_data);
		title('Song')

		filt_subt = bandpassFiltData(subt, [300 3e3]/(fs/2), 4);

		subplot(2,1,2);

		plot(time, filt_subt);
		title('Bandpass filtered trace (300Hz-3kHz)');
		ylabel('Voltage (µV)');

		axis tight;
	end

	if (code>1)
		% plots just the raw data, subtracted
		fig3 = figure();
		subplot(2,1,1);
		% plot the spectrogram of the song
		specgram(audio_data);
		title('Song');

		subplot(2,1,2);

		plot(time, subt);
		title('Raw trace (two channels subtracted)')
		ylabel('Voltage (µV)');
		xlabel('Time (s)');

		axis tight;

	end

	if (code>2)
		% in 
		fig2 = figure();

		subplot(2,1,1);

		specgram(audio_data);
		title('Song')

		subplot(2,1,2);

		notch_subt = notchFiltNoise(subt, 60, fs);

		plot(time, notch_subt);
		title('Notch filtered (60Hz) raw trace');
		ylabel('Voltage (µV)');
		xlabel('Time (s)');

		axis tight;
	end

	if (code>3)
		% plots just raw data
		fig4 = figure();
		subplot(3,1,1);
		% plot the spectrogram of the song
		specgram(audio_data);
		title('Song');

		sh(1) = subplot(3,1,2);
		plot(time, ephys_data(:,1));
		title('Raw voltage trace (channel 1)');
		ylabel('Voltage (µV)');
		xlabel('Time (s)');
		sh(2) = subplot(3,1,3);
		plot(time, ephys_data(:,2));
		title('Raw voltage trace (channel 2)');
		ylabel('Voltage (µV)');
		xlabel('Time (s)');
		linkaxes(sh, 'x');
		axis tight;


	end
end

