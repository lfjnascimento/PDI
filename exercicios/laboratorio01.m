# Autor: Luiz Filipe Nascimento
# Codigo da tarefa "Laboratorio 1"
# Cria uma interface onde o usuario pode selecionar uma imagem 
# e aplicar filtros sobre ela.
# Para cada filtro existe 2 funções, onFilterSelect() e filter()
# onFilterSelect() realiza ações quando o filtro eh selecionado, como por exemplo, alterações na interface.
# Ja a função filter() realizar e aplica o calculo do filtro.


close all;
clc;
clear all;

#global img = [
#    [1, 5, 15, 1, 0],
#    [14, 12, 10, 8, 2],
#    [12, 10, 14, 7, 7],
#    [8, 9, 0, 10, 11]
#];
global img = 0;
global img_name = "";
global img_path = "";

global filtered_img = 0;
global filtered_img_name = "";
global filtered_img_path = "";
global filtered_img_saved = false;


function showError(label)
  errordlg(label, "Erro!");
endfunction


function cleanFilteredImg()
  filtered_img = 0;
  filtered_img_name = "";
  filtered_img_path = "";
  filtered_img_saved = false;
endfunction


function closeWindow()
  answer = questdlg("Salvar imagem filtrada?", 
    "Deseja salvar imagem filtrada?", 
    "Salvar", "Não salvar","Cancelar",
    "Salvar");

  switch answer
    case "Salvar"
      saveImage();
      close all;
    case "Não salvar"
      close all;
    case "Cancelar"
  end
endfunction


function openImage(src, event, img_panel, filtered_img_panel)
  global img
  global img_name 
  global img_path
  global filtered_img 
  global filtered_img_name
  global filtered_img_path

  [img_name, img_path] = uigetfile(
    {"*.png;*.jpg", "Arquivos de imagens *.png, *.jpg"},
    "Selecione a imagem",
    "MultiSelect","off"
  );

  # Exibe img no img_panel
  img = imread(strcat(img_path, img_name));
  axes("parent", img_panel);
  imshow(img, []);

  # Exibe uma copia de img como filtered_img em filtered_img_panel
  filtered_img = img;
  filtered_img_name = img_name;
  filtered_img_path = img_path;
  axes("parent", filtered_img_panel);
  imshow(filtered_img, []);
  cleanFilteredImg()
endfunction


function saveImage()
  global filtered_img
  global filtered_img_name
  global filtered_img_path
  global filtered_img_saved

  if !filtered_img
  showError("Nenhuma imagem filtrada!");
  elseif !filtered_img_saved
    saveImageAs()
  else
    imwrite(filtered_img, strcat(filtered_img_path, filtered_img_name));
  endif
endfunction


function saveImageAs()
  global img_name
  global filtered_img
  global filtered_img_name
  global filtered_img_path
  global filtered_img_saved
 
  if !filtered_img
    showError("Nenhuma imagem filtrada!");
    return;
  endif

  # Sugere que o nome da imagem filtrada seja o nome da imagem concatenado com "_filtrada"
  filtered_img_name = strrep(img_name, ".", "_filtrada.");
  [filtered_img_name, filtered_img_path] = uiputfile(
    {"*.png;*.jpg", "Arquivos de imagens *.png, *.jpg"},
    "Salvar Imagem filtrada",
    filtered_img_name
  );

  imwrite(filtered_img, strcat(filtered_img_path, filtered_img_name));
  filtered_img_saved = true;
endfunction

function addApplyBtn(panel, cb)
  uicontrol(panel, 
    "style", "pushbutton",
    "string", "Aplicar Filtro",
    "position", [20 100 150 25],
    "callback", cb
  );
endfunction


function filterBin(lim_panel, filtered_img_panel)
  global img;
  global filtered_img;

  lim = str2double(get(lim_panel, "string"));

  if !img
    showError("Imagem de entrada vazia!");
  elseif isnan(lim)
    showError("Limiar deve ser um número!");
  else
    [m n] = size(img);
    filtered_img = zeros(m, n);
    
    for(i=1: 1: m)
      for(j=1: 1: n)
        if(img(i, j) <= lim)
          filtered_img(i, j) = 0;
        else
          filtered_img(i, j) = 1;
        endif
      endfor
    endfor

    axes("parent", filtered_img_panel);
    imshow(filtered_img, []);
  endif
endfunction


function onFilterBinSelect(src, event, panel, filtered_img_panel)
  delete(get(panel, "children"))

  set(panel, "title", "Filtro binário");
  uicontrol(panel, 
    "style", "text",
    "string", "Limiar:",
    "horizontalalignment", "left",
    "position", [20 350 50 25]
  );

  lim_panel = uicontrol(panel, 
    "style", "edit",
    "position", [70 350 100 25]
  );

  addApplyBtn(panel, @(src, event)filterBin(lim_panel, filtered_img_panel))
endfunction


function filterMean4(filtered_img_panel)
  global img;
  global filtered_img;

  [m n] = size(img);
  filtered_img = zeros(m, n);
  img_border = zeros(m+2, n+2);
  img_border(2: m+1, 2: n+1) = img(:,:);
  
  if !img
    showError("Imagem de entrada vazia!");
    return;
  endif

  for(i=2: 1: m+1)
    sum = 0; 
    for(j=2: 1: n+1)
      sum += img_border(i-1, j);
      sum += img_border(i+1, j);
      sum += img_border(i, j-1);
      sum += img_border(i, j+1);
      filtered_img(i-1, j-1) = sum/4;
    endfor
  endfor

  axes("parent", filtered_img_panel);
  imshow(filtered_img, []);
endfunction


function onFilterMean4Select(src, event, panel, filtered_img_panel)
  delete(get(panel, "children"))

  set(panel, "title", "Filtro média 4");

  addApplyBtn(panel, @(src, event)filterMean4(filtered_img_panel))
endfunction


function filterMean8(filtered_img_panel)
  global img;
  global filtered_img;

  [m n] = size(img);
  filtered_img = zeros(m, n);
  img_border = zeros(m+2, n+2);
  img_border(2: m+1, 2: n+1) = img(:,:);
  
  if !img
    showError("Imagem de entrada vazia!");
    return;
  endif

  for(i=2: 1: m+1)
    sum = 0; 
    for(j=2: 1: n+1)
      sum += img_border(i-1, j-1); 
      sum += img_border(i-1, j);
      sum += img_border(i-1, j+1);

      sum += img_border(i, j-1);
      sum += img_border(i, j+1);
      
      sum += img_border(i+1, j-1);
      sum += img_border(i+1, j);
      sum += img_border(i+1, j+1);
      filtered_img(i-1, j-1) = sum/8;
    endfor
  endfor

  axes("parent", filtered_img_panel);
  imshow(filtered_img, []);
endfunction


function onFilterMean8Select(src, event, panel, filtered_img_panel)
  delete(get(panel, "children"))

  set(panel, "title", "Filtro média 8");

  addApplyBtn(panel, @(src, event)filterMean8(filtered_img_panel))
endfunction


function filterLog(option_panel, filtered_img_panel)
  global img;
  global filtered_img;

  if !filtered_img
    showError("Imagem de entrada vazia!");
    return;
  endif

  [m n] = size(img);
  filtered_img = zeros(m, n);
  
  # curva logaritmica
  if(get(option_panel, "value") == 1);
    for(i=1: 1: m)
      for(j=1: 1: n)
        r = img(i, j);
        filtered_img(i, j) = ( log10(1+r) );
      endfor
    endfor
  # curva logaritmica inversa
  else
    filtered_img = 10.^img;
  endif

  axes("parent", filtered_img_panel);
  imshow(filtered_img, []);
endfunction


function onFilterLogSelect(src, event, panel, filtered_img_panel)
  delete(get(panel, "children"))

  set(panel, "title", "Transformação Logarítmica");

  uicontrol(panel, 
    "style", "text",
    "string", "Função: log(1+r)",
    "horizontalalignment", "left",
    "position", [20 375 150 25]
  );

  
  uicontrol(panel, 
    "style", "text",
    "string", "Curva: ",
    "horizontalalignment", "left",
    "position", [20 325 50 25]
  );

  option_panel = uicontrol(panel, 
    "style", "popupmenu",
    "string", {"Logarítmica"; "Inversa"},
    "position", [70 325 120 25]
  );

  addApplyBtn(panel, @(src, event)filterLog(option_panel, filtered_img_panel));
endfunction


function filterGama(y_panel, filtered_img_panel)
  global img;
  global filtered_img;

  y = str2double(get(y_panel, "string"));

  if !img
    showError("Imagem de entrada vazia!");
  elseif isnan(y)
    showError("y deve ser um número!");
  else
    filtered_img = img.^y;

    axes("parent", filtered_img_panel);
    imshow(filtered_img, []);
  endif
endfunction


function onFilterGamaSelect(src, event, panel, filtered_img_panel)
  delete(get(panel, "children"))

  set(panel, "title", "Transformação gama");

  uicontrol(panel, 
    "style", "text",
    "string", "Função: r^y",
    "horizontalalignment", "left",
    "position", [20 375 150 25]
  );

  uicontrol(panel, 
    "style", "text",
    "string", "y:",
    "horizontalalignment", "left",
    "position", [20 330 50 25]
  );

  y_panel = uicontrol(panel, 
    "style", "edit",
    "position", [45 330 100 25]
  );

  addApplyBtn(panel, @(src, event)filterGama(y_panel, filtered_img_panel))
endfunction


root = figure(
  "numbertitle", "off",
  "name", "Transformações de intensidade", 
  "menubar","none", 
  "toolbar", "none",
  "position", [50 50 1000 500]
);

left_panel = uipanel(root,"title","Imagem Original","position",[.025 .075 .350 .900]);
middle_panel = uipanel(root,"title","Controle","position",[.400 .075 .200 .900]);
right_panel = uipanel(root,"title","Imagem Filtrada","position",[.625 .075 .350 .900]);

file_menu = uimenu(root,"label","Arquivo");
uimenu(file_menu,"label", "Abrir", "callback", {@openImage, left_panel, right_panel});
uimenu(file_menu,"label", "Salvar", "callback", {@saveImage, left_panel});
uimenu(file_menu,"label", "Salvar Como...", "callback", {@saveImageAs, left_panel});
uimenu(file_menu,"label", "Fechar", "callback", {@closeWindow});

filter_menu = uimenu(root,"label","Filtros");
submenu = uimenu(filter_menu,"label", "Transformações de intensidade");
uimenu(submenu,"label", "Filtro binário", "callback", {@onFilterBinSelect, middle_panel, right_panel});
uimenu(submenu,"label", "Média 4", "callback", {@onFilterMean4Select, middle_panel, right_panel});
uimenu(submenu,"label", "Média 8", "callback", {@onFilterMean8Select, middle_panel, right_panel});
uimenu(submenu,"label", "Transformação Logarítmica", "callback", {@onFilterLogSelect, middle_panel, right_panel});
uimenu(submenu,"label", "Transformação gama", "callback", {@onFilterGamaSelect, middle_panel, right_panel});

# Definindo o filtro binario como padrao
onFilterBinSelect("", "", middle_panel, right_panel)

