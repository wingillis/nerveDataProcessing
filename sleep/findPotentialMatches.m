function [indices, maxAmplitude]=findPotentialMatches(filteredData, template, templatePercentage)
	
	n = 1:length(filteredData);
	% normalizing factor
	u = template.'*template;

end