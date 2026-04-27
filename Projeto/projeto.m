clear 
[data,numChan,labels,txt,fs,gain,prefiltering,ChanDim]=eeg_read_bdf("EMG_PedroMoura\EMG_PedroMoura\Voluntário1\voluntário1_01.bdf","all","n");

A = data(1:32,1:1001);

media2 = mean(A,2);
Complot(A-media2)

Out1 = fastica(A, 'numOfIC',3, 'displayMode',"on");



% %% Pequeno teste para o ICA (corre mas acho que nao está a fazer o suposto)
% mdl = rica(data_no_mean(1:2, :)', 2); % dados em colunas aqui!
% Z = transform(mdl, data_no_mean(1:2, :)');
% 
% figure(3), plot(Z(:,1));
% figure(4), plot(Z(:,2));