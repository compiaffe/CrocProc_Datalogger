%clear all
%close all
%clc
load wave-at-600-1000.mat
load hd_butter-v1.mat

windowSize1 = 30;
windowSize2 = 13;
windowSize3 = 20;
windowSize4 = 15;
%%wave recognition
wavewindow = 70;
waveheight = 100;
waveheight_derivative = 1.2;

%%fft transform parameters
Fs = 50;
L = length(YData);% Length of Signal
%%

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
t2 = zeros(1,(length(t1)-1));
for x = 2:length(t1);
    t2(x) = (t1(x)-t1(x-1));
end
plot(t2);
axis([0 numel(t2) -3.5 3.5]);
xlabel('Time [# Datapoints] - derivative over 2 samples');ylabel('[Pa]');

subplot(5,1,4);
t3 = filter(ones(1,windowSize2)/windowSize2,1,t2);
plot(t3);
axis([0 numel(YData) -3.5 3.5]);
xlabel('Time [# Datapoints] - average of derivative with ws 50');ylabel('[Pa]');


subplot(5,1,5);

wts = [1/24;repmat(1/12,11,1);1/24];
t4 = conv(t2,wts,'valid');
plot(t4);
axis([0 numel(t1) -3.5 3.5]);
xlabel('Time [# Datapoints] - 13-term moving average on derivative');ylabel('[Pa]');


%% plot the FFT
%figure(2);

%%NFFT = 2^nextpow2(L); % Next power of 2 from length of y
%Y = fft(YData,NFFT)/L;
%f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
%plot(f,2*abs(Y(1:NFFT/2+1)))
%title('Single-Sided Amplitude Spectrum of y(t)')
%xlabel('Frequency (Hz)')
%ylabel('|Y(f)|')

%% find the wave - derivative style...

wave = zeros(2000);
for x = 1:(2000-wavewindow)
    if (t1(x)-t1(x+wavewindow) >=waveheight)
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

%% find the wave from ydata-->average-->derivative-->average
wave = zeros(numel(t3));
for x = 1:(numel(t3))
    if (t3(x) >= waveheight_derivative) || ((t3(x) <= (waveheight_derivative*-1)))
        %fprintf('Wave at YData = %d\n',x);
        wave(x)=1;
    else
        wave(x) = 0;
    end
    
end
hold on
figure(1);
subplot(5,1,4);
hold on
p = plot(wave);
set(p,'Color','red');
hold off

%% .../trend13-term

wave = zeros(numel(t4));
for x = 1:(numel(t4))
    if (t4(x) >= waveheight_derivative) || ((t4(x) <= (waveheight_derivative*-1)))
        %fprintf('Wave at YData = %d\n',x);
        wave(x)=1;
    else
        wave(x) = 0;
    end
    
end
hold on
figure(1);
subplot(5,1,5);
hold on
p = plot(wave);
set(p,'Color','red');
hold off