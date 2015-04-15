function [Y,FS,LABELS,PORTS] = fw_lw1rhp1_dataload(FILE)
%
%
%
	load(FILE,'ephys');
	Y=ephys.data(:, 1) - ephys.data(:,3);
	FS=ephys.fs;
	LABELS=ephys.labels(1);
	PORTS=ephys.ports(1);

end
