%3.1
[data,numChan,labels,txt,fs,gain,prefiltering,ChanDim] = eeg_read_bdf("EEG_repouso.bdf","all","n");

%amostragem total
sample_total = size(data, 2);

%3.3
%duração da aquisição do sinal
t_total = sample_total/fs; %185s

%3.4
%número de amostras em 20s
t1 = 20 * fs;
%passo
passo = 1:t1;

%canal frontal - 1
canal_frontal_20s = data(1, passo);

%canal occipital - 16
canal_occipital_20s = data(16, passo);

plot(passo, canal_frontal_20s);
%figure
plot(passo, canal_occipital_20s);
%figure

%3.5
Complot(data)
%figure

%3.6
media = mean(data,2); %2 - faz a média dos valores das colunas
data_nomean = data - media;
Complot(data_nomean)
%figure

%3.7
f_max = fs/2; %teorema de nyquist fs > 2*f_max
f_min = fs/size(data,2); %taxa de amostragem / nº de amostras

%3.8
frontal_nomean = data_nomean(1, :);
[Pxx, F] = pwelch(frontal_nomean,5000,100,[],fs);
plot(F, Pxx)
%figure

%20s
frontal_nomean_20s = data_nomean(1, passo);
occipital_nomean_20s = data_nomean(16, passo);

%3.9
%filtro passa-alto 5Hz feito na filterDesigner tool
%filteredSignal20s_frontal = filter(passa_alto_5Hz, canal_frontal_20s)
%filteredSignal20s_occipital = filter(passa_alto_5Hz, canal_occipital_20s)

filteredSignal20s_frontal = filter(filtro_PA, frontal_nomean_20s)
filteredSignal20s_occipital = filter(filtro_PA, occipital_nomean_20s)

plot(passo, filteredSignal20s_frontal)
%figure
plot(passo, filteredSignal20s_occipital)
%figure

%3.10
passa_banda_frontal = filter(passa_banda_5_45Hz, frontal_nomean_20s)
passa_banda_occipital = filter(passa_banda_5_45Hz, occipital_nomean_20s)

plot(passo, passa_banda_frontal)
%figure
plot(passo, passa_banda_occipital)
%figure

[Pxx2, F2] = pwelch(passa_banda_frontal,5000,100,[],fs);
plot(F2, Pxx2)
%figure
[Pxx3, F3] = pwelch(passa_banda_occipital,5000,100,[],fs);
plot(F3, Pxx3)
%figure

%3.11
spectrogram(passa_banda_frontal)
%figure
spectrogram(passa_banda_occipital)
%figure

%3.12
histogram(passa_banda_frontal)
%figure
histogram(passa_banda_occipital)

media_frontal = mean(passa_banda_frontal)
media_occipital = mean(passa_banda_occipital)

std_frontal = std(passa_banda_frontal)
std_occipital = std(passa_banda_occipital)

ske_frontal = skewness(passa_banda_frontal)
ske_occipital = skewness(passa_banda_occipital)

kurt_frontal = kurtosis(passa_banda_frontal)
kurt_occipital = kurtosis(passa_banda_occipital)
