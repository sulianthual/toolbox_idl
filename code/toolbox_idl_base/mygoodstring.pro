function mygoodstring,inputstring,blanks=blanks
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Function to make nice looking strings, removing all white spaces from string.
; Sulian Thual IMARPE IRD 2008
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
if ~keyword_set(blanks) then begin
outputstring=strcompress(inputstring,/remove_all); removes all blanks from input string.
endif else begin
outputstring=strcompress(inputstring); let one blank at each separation
endelse
;
; See also :
;outputstring=strtrim(inputstring); removes blanks from tail
;outputstring=strtrim(inputstring,1); removes blanks from front
;outputstring=strtrim(inputstring,2); removes both
;
return,outputstring
;
end