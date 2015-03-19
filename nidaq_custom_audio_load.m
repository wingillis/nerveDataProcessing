function [audio_data, audio_fs] = nidaq_custom_audio_load(input_file)
	load(input_file);
	audio_data = data.voltage;
	audio_fs = data.fs;
	clear('data');
end