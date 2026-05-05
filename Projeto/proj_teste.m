%% Inicialização dos dados
clear
[data,numChan,labels,txt,fs,gain,prefiltering,ChanDim]=eeg_read_bdf("EMG_PedroMoura\EMG_PedroMoura\Voluntário1\voluntário1_01.bdf","all","n");

n_amostras = 1001;
dez_segundos = fs * 10;
dados = data(1:32, :); %apenas as 32 primeiras linhas e os primeiros 10 segundos

% porque é que usamos os 32 canais ao invés de 1? o fastica faz a separação
% em componentes independentes, onde o número de componentes independentes
% será igual ao número de canais

% retirar a média?
% aplicar um passa banda? ECG -> 1-60Hz; EMG -> 20-400Hz;

tempo_dados = n_amostras/fs; %converter as amostras em tempo

% Complot(dados); Verificar se todos os canais tinham dados
% media_dados = mean(data, 2)
% dados_sem_media = dados - media_dados; Retirar a média se necessário
% figure(1), plot(tempo_dados, data(1, tempo_dados)), title("Primeiras 1000 amostras");

%% Plot dados originais
figure
Complot(dados - mean(dados, 2))

%% Fast Independent Component Analysis (FastICA)
maxEig = 5;

[icasig, A, W] = fastica(dados, 'numOfIC', 16, 'approach', 'symm','g', 'tanh', 'displayMode','on','lastEig',maxEig);

% qual o número indicado de componentes? posso usar até 32.
%
% alterar os outros parâmetros para ver quais nos dão o melhor resultado
%
% icasig - componentes independentes
% A - matriz de mistura - os "pesos" de cada fonte; há pelo menos tantas
% misturas como número de componentes independentes
% W - matriz de separação - valores que multiplicam pelos dados para dar a
% "solução" - sinal da fonte; valor que maximiza a curtose
%
% primeiro ocorre whitening - tonrnar os componentes "descorrelacionados",
% o que para fontes gaussianas é o equivalente a "independente"
%
% x(t) = A * s(t)
% S = W * X

%% Removemos a média das componentes
media_ica = mean(icasig, 2);
icasig_nomean = icasig - media_ica;

%% Visualizar o sinal com média

figure
for i = 1:maxEig
    subplot(maxEig,1,i)
    plot(icasig(i,:));
    title(['IC ' num2str(i)]);
end 

figure
%Visualizar o espetro de potencia
for i = 1:maxEig
    subplot(maxEig,1,i)
    plot(pwelch(icasig(i,:)));
    %xlim([0 800])
    title(['IC ' num2str(i)]);
end 


%% Visualizar o sinal sem média

figure
for i = 1:maxEig
    subplot(maxEig,1,i)
    plot(icasig_nomean(i,:));
    title(['IC ' num2str(i)]);
end 

figure
%Visualizar o espetro de potencia
for i = 1:maxEig
    subplot(maxEig,1,i)
    plot(pwelch(icasig_nomean(i,:)));
    %xlim([0 800])
    title(['IC ' num2str(i)]);
end 

%% Encontrar IC correspondente ao ECG

%Observa-se que o IC que tem o maior pico na região do 1 Hz corresponde ao
%sinal ECG. Ainda assim, este altera de posição. Automatizemos de forma a
%encontrar sempre o IC correto

picos_potencia = zeros(1,maxEig);

for i = 1:maxEig
    p_spectre = pwelch(icasig_nomean(i,:));
    picos_potencia(i) = max(p_spectre(1:3));
end

[maior_pico, id_ecg] = min(picos_potencia);

%% Plots para encontrar o mais semelhante ao ECG

figure;
plot(icasig_nomean(id_ecg, :));

% a componente IC30 é a que mais se assemelha com um ECG (?)
% VERIFICAR COM UM ESPETRO DE FREQUÊNCIAS!!!
% ao removê-la do EMG, "limpamos" o sinal do "ruído" do ECG

%% Remover o ECG do EMG

componente_ecg = icasig_nomean(id_ecg, :); %guardar o ecg
icasig_noecg = icasig_nomean;
icasig_noecg(id_ecg, :) = 0; %tornar a componente do ECG nula
dados_sem_ecg = A * icasig_noecg;

%% Isolar o ECG - matriz nula apenas com os dados da componente ECG

ecg = zeros(size(icasig_noecg));
ecg(id_ecg, :) = componente_ecg;
ecg_reconstruido = A * ecg; % X = A * S

%% Plots de comparação

figure;
subplot(3,1,1);
plot(dados(1,:));
%xlim([0 8E3])
title('Sinal original');

subplot(3,1,2);
plot(dados_sem_ecg(1,:));
%xlim([0 8E3])
title('EMG sem ECG');

subplot(3,1,3);
plot(ecg_reconstruido(1,:));
%xlim([0 8E3])
title('ECG extraído');

% cada que fazemos o fastica, a componente que se assemelha mais com o ECG
% muda de posição. - Não
% podemos escolher a
% componente que se assemelha mais a um ECG à base do "olhómetro".
% temos de fazer um algoritmo para identificar automaticamente a componente
% que se assemelha mais ao ECG

%% Complot final
figure
Complot(ecg_reconstruido)

figure
Complot(dados_sem_ecg)

%% Cálculo frequência cardíaca
ECG = ecg_reconstruido(1,:);
[yR, xR] = findpeaks(ECG, "MinPeakHeight",0.84E4, MinPeakDistance=1000);

picos = size(xR,2);
samples_total=size(ecg_reconstruido,2);
FC=picos/samples_total*60*fs;
%%

%{

window_size = 0.4; %em tempo
window_samples = round(window_size * fs); %em samples
janela = [];



for i = 1:length(xR)
    margem_esq = round(xR(i) - window_samples);
    margem_dir = round(xR(i) + window_samples);

    janela(i,:) = ECG(margem_esq:margem_dir);
end

modelo = mean(janela, 1);
t_janela = (-window_samples:window_samples)/fs;
figure
plot(modelo);
%}

