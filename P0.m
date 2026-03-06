[data,numChan,labels,txt,fs,gain,prefiltering,ChanDim] = eeg_read_bdf("EEG_repouso.bdf","all","n");

%amostragem total
sample_total = size(data, 2);

%duração da aquisição do sinal
t_total = sample_total/fs; %185s

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

%3.6
media = mean(data,2);
data_nomean = data - media;
Complot(data_nomean)

%3.7
f_max = fs/2;
f_min=fs/size(data,2);

%3.8
frontal_nomean = data_nomean(1, :);
[Pxx, F] = pwelch(frontal_nomean,5000,100,[],fs);
plot(F, Pxx)
