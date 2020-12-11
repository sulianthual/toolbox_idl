Pro mywindow,wind,norsetain=noretain,nodecomposed
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for switching windows
; Sulian THUAL IMARPE-IRD 2008
;
; wind : window to be set. If not opened, it is opened. 
;        if opened it is set as current but not erased
;        of wind not set then opens a new window with free index and sets it as the current window
;       the device must be (X) before using this programm !!
;
; noretain : basically the window is set to device,retain=2, to keep graph on screen
;           and it stay after in the definitions of the (X) device.
;           if not set then we don't put that line
;
; nodecomposed : the same, if not set then device,decomposed=0
; EXAMPLE :
; mywindow; to open new window, free index
; mywindow,1; switch to window 1 (open it if necessary)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
actualdevice=!D.NAME; 'X' ou 'PS' dans mon cas
if (actualdevice eq 'X') then begin
;
if (N_PARAMS() eq 1) then begin
; if window alread exists, just make it the current window
; if window does not exist, create it and set it the current window
device,window_state=isopened
if (isopened(wind) eq 1) then wset,wind else window,wind
endif else begin
; if no designated window, create new one with free number
window,/free
endelse
;
if keyword_set(noretain) then dummy =0 else device,retain=2
if keyword_set(nodecomposed) then dummy =0 else device,decomposed=0
;
endif


end




