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
figure
plot(passo, canal_occipital_20s);
figure

%3.5
Complot(data)
figure

%3.6
media = mean(data,2); %2 - faz a média dos valores das colunas
data_nomean = data - media;
Complot(data_nomean)
figure

%3.7
f_max = fs/2; %teorema de nyquist fs > 2*f_max
f_min = fs/size(data,2); %taxa de amostragem / nº de amostras

%3.8
frontal_nomean = data_nomean(1, :);
[Pxx, F] = pwelch(frontal_nomean,5000,100,[],fs);
plot(F, Pxx)
figure

%3.9
%filtro passa-alto 5Hz feito na filterDesigner tool
%filteredSignal20s_frontal = filter(passa_alto_5Hz, canal_frontal_20s)
%filteredSignal20s_occipital = filter(passa_alto_5Hz, canal_occipital_20s)

filteredSignal20s_frontal = filter(filtro_PA, canal_frontal_20s)
filteredSignal20s_occipital = filter(filtro_PA, canal_occipital_20s)

plot(passo, filteredSignal20s_frontal)
figure
plot(passo, filteredSignal20s_occipital)
figure

%3.10
passa_banda_frontal = filter(passa_banda_5_45Hz, canal_frontal_20s)
passa_banda_occipital = filter(passa_banda_5_45Hz, canal_occipital_20s)

plot(passo, passa_banda_frontal)
figure
plot(passo, passa_banda_occipital)
figure
