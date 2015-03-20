function matches=findPotentialMatches(filteredData, template, templatePercentage)
	
	n = 1:length(filteredData);
	% normalizing factor
	u = template.'*template;

	matches = n(filteredData>templatePercentage*u);

	strin = sprintf('Found %d matches', length(matches));

end