Pro myprint,config
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; configurations
if (N_PARAMS() eq 1) then cfg=config else cfg=2
;
;
; config 1: my config for on-screen nice plots(do nothing as it does not print)
if (cfg eq 1) then begin
print,'myprint with config 1,do nothing'
return
endif
;
; config 2 : my config for printing nice plots
if (cfg eq 2) then begin
; device for printing : 'ps'
device,/close
endif
;
;;;;;;;;;;;;;;;;;;;;;AUTRES BROUILLONS
; config0 : default idl configuration
if (cfg eq 0) then begin
; ...
endif
; config 3 : boris config for printing plots(use of psonc and ps_off)
if (cfg eq 3) then begin
; device is 'x' (?) and psonc sets the output file
psoff_file
endif
;
end 