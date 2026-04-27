clear 
[data,numChan,labels,txt,fs,gain,prefiltering,ChanDim]=eeg_read_bdf("EMG_PedroMoura\EMG_PedroMoura\Voluntário1\voluntário1_01.bdf","all","n");

% A = data(1:32,1:1001);
% n_amostras = size(A, 2);
% 
% tempo_amostra_total = n_amostras/fs;
% T = 20*fs;
% vinte_seg = 1:(T );
% media2 = mean(A,2);
% Complot(A)
% 
% figure(1), plot(vinte_seg, data(1, vinte_seg)), title("Primeiros 20 Segundos")

media = mean(data,2);
data_no_mean = data - media;

figure(2), plot(vinte_seg, data_no_mean(1, vinte_seg)), title("Primeiros 20 Segundos sem média")


%% Pequeno teste para o ICA (corre mas acho que nao está a fazer o suposto)
mdl = rica(data_no_mean(1:2, :)', 2); % dados em colunas aqui!
Z = transform(mdl, data_no_mean(1:2, :)');

figure(3), plot(Z(:,1));
figure(4), plot(Z(:,2));