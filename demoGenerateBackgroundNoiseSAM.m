% function Nz = GenerateBackgroundNoise(p)
clear
close all
p=NoisySAMParseArgs('L01', 'BackNzLevel', .01, ...
    'NoiseDuration', 400, 'LongMaskerNoise', 000);
p.trial = 1;

Nz = GenerateBackgroundNoiseSAM(p);
pwelch(Nz,[],[],512,p.SampFreq);
t=(0:(length(Nz)-1))/p.SampFreq;
figure, plot(t,Nz)
audiowrite('BackNz.wav', 0.5*Nz/(max(abs(Nz))), p.SampFreq);
return

p.addParameter('BackNzLevel',0, @isnumeric); % in absolute rms
p.addParameter('BackNzLoPass',0, @isnumeric);
p.addParameter('BackNzHiPass',50, @isnumeric);