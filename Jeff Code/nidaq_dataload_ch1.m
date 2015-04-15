function [Y,FS]=fw_dataload(FILE)
%
%
%
	load(FILE,'data');
	% Y=ephys.data(:, 4) - ephys.data(:, 6);
	Y=data.voltage(:,1);

	FS=data.fs;

end