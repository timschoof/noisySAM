function y = dBlevelsForTwoSoundsGivenSum(t, d)
% 
% 10*log10(10^(x/10)+10^((x-d)/10))=t solve for real x
% 
% where t= total level in dB SPL
% d = difference in levels
% 
% x = log(10^(d + t)/(10^(d/10) + 1)^10)/log(10) and 10^(-d/10)>-1
%
y = log(10^(d + t)/(10^(d/10) + 1)^10)/log(10);