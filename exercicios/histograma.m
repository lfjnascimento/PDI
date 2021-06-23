close all;
clc;
clear all;


function result= hist(M, Q)
  result = zeros(1, Q+1);
  [y x] = size(M);

  for(i=1: 1: y)
    for(j=1: 1: x)
      result(M(i,j)+1)++;
    endfor
  endfor
end

img = [
    [1, 5, 15, 1, 0],
    [14, 12, 10, 8, 2],
    [12, 10, 14, 7, 7],
    [8, 9, 0, 10, 11]
];
n = 4;
Q = (n^2)-1;

subplot(1, 2, 1);
imshow(img, []);

x = (0: Q);
subplot(1, 2, 2);
stem(x, hist(img, Q));
xlim([0 Q]);