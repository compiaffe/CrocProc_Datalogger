clear all
clc
load wave-at-600-1000.mat
windowSize1 = 30;
windowSize2 = 25;
windowSize3 = 20;
windowSize4 = 15;
%%wave recognition
wavewindow = 70;
waveheight = 100;

%%fft transform parameters
Fs = 50;
L = length(YData);% Length of Signal
%%

%open wave-at-600-1000.fig %open your fig file, data is the name I gave to my file
%D=get(gca,'Children'); %get the handle of the line object
%XData=get(D,'XData'); %get the x data
%YData=get(D,'YData'); %get the y data
%Data=[XData' YData']; %join the x and y data on one array nx2
%Data=[XData;YData]; %join the x and y data on one array 2xn
figure(1);
subplot(5,1,1);
plot(YData);
axis([0 numel(YData) 97900 99000]);
title('Pressure, raw and with running average');
xlabel('Time [# Datapoints]  - Raw');ylabel('Pressure [Pa]');

subplot(5,1,2);
t1 = filter(ones(1,windowSize1)/windowSize1,1,YData);
plot(t1);
axis([0 numel(YData) 97900 99000]);
xlabel('Time [# Datapoints] - average with windowsize 30');ylabel('[Pa]');

subplot(5,1,3);
t2 = filter(ones(1,windowSize2)/windowSize2,1,YData);
plot(t2);
axis([0 numel(YData) 97900 99000]);
xlabel('Time [# Datapoints] - average with windowsize 25');ylabel('[Pa]');


subplot(5,1,4);
t3 = filter(ones(1,windowSize3)/windowSize3,1,YData);
plot(t3);
axis([0 numel(YData) 97900 99000]);
xlabel('Time [# Datapoints] - average with windowsize 20');ylabel('[Pa]');


subplot(5,1,5);
t4 = filter(ones(1,windowSize4)/windowSize4,1,YData);
plot(t4);
axis([0 numel(YData) 97900 99000]);
xlabel('Time [# Datapoints] - average with windowsize 15');ylabel('[Pa]');


%% plot the FFT
figure(2);

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(YData,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

%% find the wave

filtered = filter(ones(1,windowSize1)/windowSize1,1,YData);
wave = zeros(2000);
for x = 1:(2000-wavewindow)
    if (filtered(x)-filtered(x+wavewindow) >=waveheight)
        fprintf('Wave at YData = %d\n',x);
        wave(x)=max(t1)-500;
    else
        wave(x) = max(t1)-1000;
    end
end
hold on
figure(1);
subplot(5,1,2);
hold on
p = plot(wave);
set(p,'Color','red');
hold off

