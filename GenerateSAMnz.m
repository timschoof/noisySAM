function [Nz, flatNz, modulator]=GenerateSAMnz(ModulationPresent, p)
%
% ModulationPresent = 0 or 1
%
% Unlike Berniotis, here only the target signals are generated because
% there is no proper masker per se.
% The background noise is generated and added in when constructing the
% triple.

NzSamples=samplify(p.SignalDuration,p.SampFreq);
% generate the noise and tone
f=[p.SAMnoiseBandLimits(1)  p.SAMnoiseBandLimits(1)+1  p.SAMnoiseBandLimits(2)  p.SAMnoiseBandLimits(2)+1];
l=[0   100   100   0];
[Nz, ~]=noise(f,l,p.SampFreq,p.SignalDuration/1000);
Nz=Nz(:); % ensure a column vector
% Shorten the noise to the appropriate length, long or short
Nz = Nz(1:NzSamples);
% function y = sam(x, rate, modphase, index, SampFreq)
if ModulationPresent
    modIndex=10^(p.SNR_dB/20);
    [Nz, modulator] = sam(Nz, p.ModulationRate, p.ModulationPhase, modIndex, p.SampFreq);
else
    modulator=ones(NzSamples,1);
end
% normalise to the appropriate rms
Nz = p.rms2use * Nz/rms(Nz);
% waveform after adjusting for level but without ramps
flatNz = Nz; 
% put rises and falls on the sound pulses,
% function s=taper(wave, rise, fall, p.SampFreq, type)
Nz=taper(Nz, p.RiseFall, p.RiseFall, p.SampFreq);
