% function y = sam(x, rate, modphase, index, SampFreq)

fc = 70; % carrier frequency
SampFreq=1000;
duration=1; % 1 second
t=((0:duration*SampFreq-1)/SampFreq)';
x= sin(2*pi*fc*t);
rate=4;
modphase=-pi/2;

m=0.5;
y = sam(x, rate, modphase, m, SampFreq);
modulator = sam(ones(size(x)), rate, modphase, m, SampFreq);

plot([y, modulator])
yLimits=max(y)+.1;
ylim([-yLimits yLimits])
hold on % hold ahhhhhhhhn. Put your hands, aahn that plough, hold on!
xxAxis = [0 length(x)-1];
plot(xxAxis, [1 1]*(1+m))
plot(xxAxis, [1 1]*(1-m))
if m<1
    title(sprintf('m= %3.2f = %3.1f dB : peak/valley = %4.2f = %3.1f dB', ...
        m, 20*log10(m), (1+m)/(1-m), 20*log10((1+m)/(1-m))));
end
hold off % hold awwwwwfff ...

return

stepSize=0.01;
fprintf('m (linear) m (dB) peak-valley (dB)\n');
for m=(stepSize:stepSize:1-stepSize)
    fprintf('%5.02f     %3.1f     %3.1f\n',m,20*log10(m), 20*log10((1+m)/(1-m)));
end

return

m=(stepSize:stepSize:1-stepSize);
mdB = 10*log10(m);
pkVall = 20*log10((1+m)./(1-m));
pkVallLin = ((1+m)./(1-m));
plot(m,pkVall)
xlabel('m (linear)')
ylabel('peak/valley (dB)')
grid on
figure
plot(mdB,pkVall)
xlabel('m (dB)')
ylabel('peak/valley (dB)')
grid on
figure
plot(m,pkVallLin)
xlabel('m (linear)')
ylabel('peak/valley (linear)')
grid on




