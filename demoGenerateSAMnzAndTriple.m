%% GenerateSAMtriple with pulsed maskers
clear
close all
p=NoisySAMParseArgs('L27', 'starting_SNR',0, 'NoiseDuration', 500, 'LongMaskerNoise', 000);
% ,...
%     'ToneDuration', 500, 'WithinPulseISI', 100, 'NoiseDuration', 500, ...
%     'LongMaskerNoise', 00, 'fixed', 'signal');
p.trial = 1;
p.Order=1;
[w, AMnz, modulator] = GenerateSAMtriple(p);
% pwelch(w,[],[],[],p.SampFreq)
t=(0:(length(w)-1))/p.SampFreq;
%figure
plot(t,w)
audiowrite('demoSAMtriple.wav',w,p.SampFreq)

return



%% GenerateSAMtriple with a long masker
clear
close all
p=NoisySAMParseArgs('L27', 'starting_SNR',0, 'propLongMaskerPreTarget', 0.8);
% ,...
%     'ToneDuration', 500, 'WithinPulseISI', 100, 'NoiseDuration', 500, ...
%     'LongMaskerNoise', 00, 'fixed', 'signal');
p.trial = 1;
p.order=2;
[w, AMnz] = GenerateSAMtriple(p);
pwelch(w,[],[],[],p.SampFreq)
% figure
% plot([Nz flatNz])
audiowrite('demoSAMtriple.wav',w,p.SampFreq)

return
%% -------------------------------------------------------------------
%% GenerateSAMnz
clear
close all
p=NoisySAMParseArgs('L27', 'starting_SNR',-100);
% ,...
%     'ToneDuration', 500, 'WithinPulseISI', 100, 'NoiseDuration', 500, ...
%     'LongMaskerNoise', 00, 'fixed', 'signal');
p.trial = 1;
ModulationPresent=1;


[Nz, flatNz] = GenerateSAMnz(ModulationPresent, p);
% pwelch(Nz,[],[],[],p.SampFreq)
% figure
% plot([Nz flatNz])
audiowrite('demoSAM.wav',Nz,p.SampFreq)

return
w=Nz; % for long noise

pwelch(w,[],[],[],p.SampFreq)
figure
plot([w])
plot(Tn)

size(w)
plot(w)
sound(w,p.SampFreq)

%w(:,2)=0;



