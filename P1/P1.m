%3
%3.1
[hdr, data] = edfread("EEG_ECG_EMG.edf")

%3.2
fs = hdr.samples(1,1); %500Hz

%3.3
samples_min = 60 * fs;
ECG = data(33,:);
ECG_60s = data(33,1:samples_min);

%3.4
t= 1/fs : 1/fs : 60; %começo:passo:fim
plot(t, ECG_60s)
figure

%3.5
[p,f]= pwelch(ECG_60s,8192,1024,[],fs); %p - potência; f - frequência
plot(f, p);
figure

%3.6 - remover a média
ECG_mean_60s = mean(ECG_60s)
ECG_centered_60s = ECG_60s - ECG_mean_60s
plot(t, ECG_centered_60s)
figure
[p2,f2]= pwelch(ECG_centered_60s,8192,1024,[],fs);
plot(f2, p2);
figure

%3.7
%freq_mean = mean(f2)
%freq_cardiaca = freq_mean * 60 %batimentos por minuto

f2_max = f2(p2 == max(p2));
freq_cardiaca = 60*f2_max;

%3.8
plot(t,ECG_60s)
[yR, xR] = findpeaks(ECG_60s, fs, "MinPeakHeight", 0.2); %altura minima de 0.2
[yS,xS] = findpeaks(-ECG_60s, fs, "MinPeakHeight", 0.1, "MinPeakWidth", 0.13);
[yQ,xQ] = findpeaks(-ECG_60s, fs, "MinPeakHeight", 0.1,"MinPeakWidth", 0.01, "MaxPeakWidth", 0.05);
plot(t, ECG_60s)
hold on
plot(xR,yR, "^g")
plot(xS, -yS, "or")
plot(xQ, -yQ, "^b")
hold off