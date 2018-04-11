function x = dBSPLsum(levels)
%
% sum together the dB SPL levels assuming the sounds are uncorrelated

levels = 10 .^ (levels/10);
x = 10*log10(sum(levels));
