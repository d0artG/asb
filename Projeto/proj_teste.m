%% Inicialização dos dados

[data,numChan,labels,txt,fs,gain,prefiltering,ChanDim]=eeg_read_bdf("D:\FCT\4º ANO\ASB - Análise de Sinais Biomédicos\Projeto\EMG_PedroMoura\EMG_PedroMoura\Voluntário1\voluntário1_01.bdf","all","n");

n_amostras = 1001;
dez_segundos = fs * 10;
dados = data(1:32, 1:dez_segundos); %apenas as 32 primeiras linhas e os primeiros 10 segundos

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

%% Fast Independent Component Analysis (FastICA)

[icasig, A, W] = fastica(dados, 'numOfIC', 32, 'approach', 'symm','g', 'tanh', 'displayMode',"on");

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

figure;
for i = 1:32
    subplot(8,4,i);
    plot(icasig(i,:));
    title(['IC ' num2str(i)]);
end

%% Plots para encontrar o mais semelhante ao ECG

figure;
plot(icasig(31, :));

% a componente IC30 é a que mais se assemelha com um ECG (?)
% VERIFICAR COM UM ESPETRO DE FREQUÊNCIAS!!!
% ao removê-la do EMG, "limpamos" o sinal do "ruído" do ECG

%% Remover o ECG do EMG

ecg_index = 20;
componente_ecg = icasig(ecg_index, :); %guardar o ecg
icasig(ecg_index, :) = 0; %tornar a componente do ECG nula
dados_sem_ecg = A * icasig;

%% Isolar o ECG - matriz nula apenas com os dados da componente 31

ecg = zeros(size(icasig));
ecg(ecg_index, :) = componente_ecg;
ecg_reconstruido = A * ecg; % X = A * S

%% Plots de comparação

figure;
subplot(3,1,1);
plot(dados(1,:));
title('Sinal original');

subplot(3,1,2);
plot(dados_sem_ecg(1,:));
title('EMG sem ECG');

subplot(3,1,3);
plot(ecg_reconstruido(1,:));
title('ECG extraído');

% cada que fazemos o fastica, a componente que se assemelha mais com o ECG
% muda de posição. - Não
% podemos escolher a
% componente que se assemelha mais a um ECG à base do "olhómetro".
% temos de fazer um algoritmo para identificar automaticamente a componente
% que se assemelha mais ao ECG