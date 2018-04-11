function [y, modulator] = sam(x, rate, modphase, index, SampFreq)
%
% 	
%   x -- input wave
%	rate -- modulation frequency (Hz)
%   modphase -- phase of the modulation
%	index -- modulation index, typically 0-1


% 	modulate an input signal with a sinusoidal modulator
%   June 2002
%   Version 1.5 - ensure input x is a column vector - September 2015
%   Version 2.0 - return modulator along with modulated signal - March 2018

x=x(:); % is a column vector
t=(0:length(x)-1)'/SampFreq;
modulator = (1+index*sin(2*pi*rate*t+modphase));
y = x .* modulator;
% y=y(:);

