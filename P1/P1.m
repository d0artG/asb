%3
%3.1
[hdr, data] = edfread("EEG_ECG_EMG.edf");

%3.2
fs = hdr.samples(1,1); %500Hz

%3.3
samples_min = 60 * fs;
ECG = data(33,:);
ECG_60s = data(33,1:samples_min);

%3.4
t= 1/fs : 1/fs : 60; %começo:passo:fim
plot(t, ECG_60s);
%figure

%3.5
[p,f]= pwelch(ECG_60s,8192,1024,[],fs); %p - potência; f - frequência
plot(f, p);
%figure

%3.6 - remover a média
ECG_mean_60s = mean(ECG_60s);
ECG_centered_60s = ECG_60s - ECG_mean_60s;
plot(t, ECG_centered_60s);
%figure
[p2,f2]= pwelch(ECG_centered_60s,8192,1024,[],fs);
plot(f2, p2);
%figure

%3.7
%freq_mean = mean(f2)
%freq_cardiaca = freq_mean * 60 %batimentos por minuto

f2_max = f2(p2 == max(p2));
freq_cardiaca = 60*f2_max;

%3.8
%plot(t,ECG_60s)
%[yR, xR] = findpeaks(ECG_60s, fs, "MinPeakHeight", 0.2); %altura minima de 0.2
%[yS,xS] = findpeaks(-ECG_60s, fs, "MinPeakHeight", 0.1, "MinPeakWidth", 0.13);
%[yQ,xQ] = findpeaks(-ECG_60s, fs, "MinPeakHeight", 0.1,"MinPeakWidth", 0.01, "MaxPeakWidth", 0.05);
%plot(t, ECG_60s)
%hold on
%plot(xR,yR, "^g")
%plot(xS, -yS, "or")
%plot(xQ, -yQ, "^b")
%hold off
%figure

%comparar sinais
%hold on
%plot(t, ECG_60s);
%plot(t, ECG_centered_60s);
%hold off

%3.9
%a coordenada x dos picos está acumulada no vetor xR
%window centrada no x e com "folga" para a esquerda e para a direita
%fazer a média dessas janelas

[yR, xR] = findpeaks(ECG_60s, "MinPeakHeight",0.2);
window_size = 0.6; %em tempo
window_samples = round(window_size * fs); %em samples
janela = [];

for i = 1:length(xR)
    margem_esq = round(xR(i) - window_samples);
    margem_dir = round(xR(i) + window_samples);

    janela(i,:) = ECG_60s(margem_esq:margem_dir);
end

modelo = mean(janela, 1);
t_janela = (-window_samples:window_samples)/fs;
plot(t_janela, modelo);
figure

%3.10
correlation = [];

for i = 1:length(xR)
    correlation(i,:) = xcorr(modelo, janela(i,:), 0);
end

%max_correlation 
[val, index] = max(correlation);
plot(janela(index,:));
figure

%3.11
[val2, index2] = min(correlation);
plot(janela(index2,:));

