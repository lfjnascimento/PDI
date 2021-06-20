close all;
clc;
clear all;

# funcao calcula a Media aritmetica simples global da matriz M 
function result = Masg(M)
  result = 0;
  [m n] = size(M);

  for(i=1: 1: m*n)
    result += M(i);
  endfor

  result /= m*n;
endfunction


# funcao calcula a mediana da matriz M
function result = mediana(M)
  [m n] = size(M);
  qtd_items = m*n;
  V_sort = sort(M(:));

  # se a quantidde de itens for impar
  if(mod(qtd_items, 2))
    result = V_sort(ceil(qtd_items/2));
  # se a quantidde de itens for par
  else
    result = (V_sort(qtd_items/2) + V_sort(qtd_items/2 + 1))/2;
  endif
endfunction


# funcao calcula a moda da matriz M.
# essa funcao imita o comportamento da funcao nativa mode()
# portanto, se M  for amodal entao o resultado eh o menor valor de M;
# se M for multimodal entao o resultado eh o menor valor dentro do conjunto de modas;
# se M tiver uma unica moda o resultado eh a moda.
function result = moda(M)
  uniq = unique(M);
  qtd_value = [0, 0];

  for(i=1: 1: size(uniq)(1));
    qtd_i = sum(M(:) == uniq(i));
    if(qtd_i > qtd_value(1))
      qtd_value = [qtd_i, uniq(i)];
    endif    
  endfor

  result = qtd_value(2);
endfunction


# funcao calcula o desvio padrao da matriz M
function result = dp(M)
  med = Masg(M);
  [m n] = size(M);
  sum = 0;

  for(i=1: 1: m*n)
    sum +=  (M(i) - med)^2;
  endfor

  result = sqrt(sum/(m*n));
end


M = [
    [1, 5, 15, 1, 0],
    [14, 12, 10, 8, 2],
    [12, 10, 14, 7, 7],
    [8, 9, 0, 10, 11]
];


printf("A média aritmética da matriz é: %.2f\n", Masg(M))
printf("A mediana da matriz é: %.2f\n", mediana(M))
printf("A moda da matriz é: %d\n", moda(M))
printf("O desvio padrão da matriz é: %.2f\n", dp(M))

