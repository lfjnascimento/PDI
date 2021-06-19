# o codigo abaixo funciona apenas para filtro(w) impar e simetrico
close all;
clc;
clear all;

img = [
    [1, 5, 15, 1, 0],
    [14, 12, 10, 8, 2],
    [12, 10, 14, 7, 7],
    [8, 9, 0, 10, 11]
];
[M_img, N_img] = size(img);
L = unique(img);
Q = size(L)(1);

# a contruibuicao de valores 0 eh nula
# filtro vizinhaca-8
w = [
    [1, 1, 1],
    [1, 1, 1],
    [1, 1, 1]
];
sum_w = sum(sum(w));
[M_w, N_w] = size(w);
largura_borda = floor(M_w/2);  #apenas filtros simetricos

img_borda = zeros(M_img + largura_borda*2, N_img + largura_borda*2);
img_borda(largura_borda + 1: M_img + largura_borda, largura_borda + 1: N_img + largura_borda) = img(:,:);
[M_img_borda N_img_borda] = size(img_borda);

img_saida = zeros(size(img));

for(i=largura_borda+1: 1 : M_img_borda - largura_borda)
    for(j=largura_borda+1: 1 : N_img_borda - largura_borda)
        soma_intensidade = 0;
        for(t=0: 1: M_w-1)
            for(u=0: 1: N_w-1)
                soma_intensidade += img_borda(i-largura_borda+t, j-largura_borda+u) * w(t+1, u+1);
            endfor
        endfor
        img_saida(i-largura_borda, j-largura_borda) = floor(soma_intensidade / sum_w);
    endfor
endfor

r = 2;
c = 2;
subplot(r, c, 1);
imshow(img, []);
title("Imagem original");
subplot(r, c, 2);
imshow(img_saida, []);
title("Imagem filtrada");
subplot(r, c, 3);
imshow(img_borda, []);
title("Imagem com borda");
subplot(r, c, 4);
imshow(img - img_saida, []);
title("(Original - Filtrada)");
