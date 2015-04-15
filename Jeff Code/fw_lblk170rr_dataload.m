function [Y,FS,LABELS,PORTS]=fw_dataload(FILE)
%
%
%
	load(FILE,'ephys');
	% Y=ephys.data(:, 4) - ephys.data(:, 6);
	Y=ephys.data(:,4) - (ephys.data(:, 5)+ ephys.data(:,6))./2;

	FS=ephys.fs;
	LABELS=ephys.labels(1);
	PORTS=ephys.ports(1);

end