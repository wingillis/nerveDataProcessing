function [Y,FS,LABELS,PORTS]=fw_dataload(FILE)
%
%
%
	load(FILE,'ephys');
	Y=ephys.data(:, 6);
	FS=ephys.fs;
	LABELS=ephys.labels(1);
	PORTS=ephys.ports(1);

end