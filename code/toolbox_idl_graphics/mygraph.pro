Pro mygraph,config,close=close
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for handling graphic parameters such as 
; device definition, for showing on screen or printing
; Sulian THUAL IMARPE-IRD 2008
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; AJOUT 2011:
;
; mygraph: definit graph de base
;
; mygraph,2: definit graph pour print dans file
; mygraph,'fileout.ps'=> definit aussi dans quel fichier ecrire ! et se met en type config=2
; mygraph,/close => ferme seulement le fichier ecriture
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ANCIENS
; 
; config : the configuration choosen by user(default is 1 if not set)
;
; EXAMPLE : you should be working on a linux, where device 'x' and 'ps' are supported.
; mygraph : loads config 1,ie opens device 'x' for on-screen graphics
; mygraph,1 : same as precedent
; mygraph,2 : opens device 'ps' for printing in 'ps' file (see myprint)
; mygraph,3 : the boris config for ps printing, but i cannot make it work.
;
; 
; NOTE : - The following device only apply on my linux workstation
;        If you are working for example on windows, you should specify your
;        specific device('win'). See graphic supported devices.
;        - I only print images using 'ps' device, as the TV procedure crashs
;        on my computer.
;        - graphic parameters(colors,background,margin...) are specific for 
;        my type of configuration
;        -once set, configuration remains for all graphics until other 
;        configuration is set.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Set device for graphic : (see graphic supported devices in Help)
;
; Si mode PS actuel, ferme avant redefinitions
actualdevice=!D.NAME; 'X' ou 'PS' dans mon cas
if (actualdevice eq 'PS') then begin
device,/close
endif
;
; configuration par defaut
if (N_PARAMS() ge 1) then begin
if (size(config,/type) eq 7) then begin; string
flt=config & cfg=2
endif else begin
cfg=config 
flt='mygraph_out.ps'
endelse
endif else begin
cfg=1 
flt='mygraph_out.ps'
endelse 
;
; config 1: my config for on-screen nice plots
if (cfg eq 1) then begin
; device for on-screen plots: 'x'
set_plot,'x'
;if (!d.window ne -1) then wdelete,!d.window;  ; delete current window
; specific parameters for device 'x' (!d.name='X'):
device,retain=2; to keep graph on screen
device,decomposed=0; to keep graph on screen
; other parameters :
loadct,39,/silent; load a color table
!p.color=0; set plot color(black) 
; exemple de couleur en sortie X : !p.color=50(bleu)
!p.background=16777215; ; set background color(white)
!y.margin=[2,2]; margin for graph
!x.margin=[6,2]; margin for graph
!p.charsize=1.7
!p.charthick=2
!p.thick=0
!p.multi=[0,0,0]
!p.title=''
; mettre !x.thicks,!y.thicks
; mettre !x.thickname,!y.thickname
; mettre !p.thicks
; mettre !p.linestyle
; !p.charsize
; !p.charthick
; ...
endif
;

;
; config 2 : my config for printing nice plots
if (cfg eq 2) then begin
;
; device for printing : 'ps'
set_plot,'ps'
; specific parameters for device 'ps' (!d.name='PS'):
device,filename=flt
device,/portrait;/landscape; set portrait orientation
device,/color
; other parameters :
loadct,39,/silent; load a color table
!p.color=0; set plot color(black) 
!p.background=16777215; ; set background color(white)
!y.margin=[4,4]; margin for graph
!x.margin=[12,8]; margin for graph
!p.charsize=1.5
!p.charthick=3
!p.thick=0
!p.multi=[0,0,0]
!p.title=''
; ...
; Pour faire un graph dans un eps :
;mygraph,2
; faire le plot,contour...
;device,/close
; rechercher mygraph_out.ps
;
endif
;
;;;;;;;;;;;;;;;;;BROUILLONS
;
; config0: INUTILE
; config 0 : default idl configuration : on ne fait rien....
if (cfg eq 0) then begin
endif
;
; config3: INUTILE
; config 3 : boris config for printing plots(needs functions psonc and ps_off)
; DOES NOT WORK, NOT READEABLE OUPTUT FILE.
if (cfg eq 3) then begin
; device is 'x'(?) with psonc for printing :
;set_plot,'x'; needed?
;window,1; needed ?
psonc,'mygraph_out',/ls
device,/portrait
; other parameters :
loadct,39,/silent; load a color table
!p.color=0; set plot color(black) 
!p.background=16777215; ; set background color(white)
!y.margin=[4,4]; margin for graph
!x.margin=[12,4]; margin for graph
endif
;
end




