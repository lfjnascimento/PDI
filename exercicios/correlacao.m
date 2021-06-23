# codigo baseado na nota explicativa "Filtragem compacta"
# para calcular a correlacao de uma imagem  representada pela funcao f(x,y) 
# com um operador de transformacao T, de dimensoes A x A, A ımpar e A > 1.

close all;
clc;
clear all;

f = [
    [1, 5, 15, 1, 0],
    [14, 12, 10, 8, 2],
    [12, 10, 14, 7, 7],
    [8, 9, 0, 10, 11]
];
[M_f, N_f] = size(f);

# a contruibuicao de valores 0 eh nula
# filtro vizinhaca-4
T = [
    [0, -1, 0],
    [-1, 4, -1],
    [0, -1, 0]
];
A = size(T)(1);
c = (A-1)/2;
k = A - c;
border_width = c;

f_with_border = zeros(M_f+border_width*2, N_f+border_width*2);
f_with_border(border_width+1: M_f+border_width, border_width+1: N_f+border_width) = f(:,:);

f_out = zeros(size(f));

for(y=border_width+1: 1:  M_f+border_width)
  for(x=border_width+1: 1: N_f+border_width)
    accumulator = 0;
    for(t=-c: 1: c)
      for(s=-c: 1: c)
        accumulator += f_with_border(y+t, x+s) * T(k+t, k+s);
      endfor
    endfor
    f_out(y-border_width, x-border_width) = accumulator;
  endfor
endfor

imwrite(f_out, "./correlacao.png")
subplot(1, 2, 1);
imshow(f, []);
title("Imagem original");
subplot(1, 2, 2);
imshow(f_out, []);
title("Imagem após correlação");
