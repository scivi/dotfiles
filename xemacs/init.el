;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                      Basic Customization                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Define a variable to indicate whether we're running XEmacs/Lucid
;; Emacs.  (You do not have to defvar a global variable before using
;; it -- you can just call `setq' directly.  It's clearer this way,
;; though.  Note also how we check if this variable already exists
;; using `boundp', because it's defined in recent versions of
;; XEmacs.)

(or (boundp 'running-xemacs)
    (defvar running-xemacs (string-match "XEmacs\\|Lucid" emacs-version)))

;; Define a function to make it easier to check which version we're
;; running.  This function already exists in recent XEmacs versions,
;; and in fact all we've done is copied the definition.  Note again
;; how we check to avoid clobbering an existing definition. (It's good
;; style to do this, in case some improvement was made to the
;; already-existing function -- otherwise we might subsitute an older
;; definition and possibly break some code elsewhere.)

(or (fboundp 'emacs-version>=)
    (defun emacs-version>= (major &optional minor patch)
      "Return true if the Emacs version is >= to the given MAJOR, MINOR,
   and PATCH numbers.
The MAJOR version number argument is required, but the other arguments
argument are optional. Only the Non-nil arguments are used in the test."
      (let ((emacs-patch (or emacs-patch-level emacs-beta-version -1)))
	(cond ((> emacs-major-version major))
	      ((< emacs-major-version major) nil)
	      ((null minor))
	      ((> emacs-minor-version minor))
	      ((< emacs-minor-version minor) nil)
	      ((null patch))
	      ((>= emacs-patch patch))))))

;; 19.13 was released ages ago (Sep. 1995), and lots of graphic and
;; window-system stuff doesn't work before then.

(or (not running-xemacs)
    (emacs-version>= 19 13)
    (error "This init file does not support XEmacs before 19.13"))

(defun Init-safe-require (feat)
"Try to REQUIRE the specified feature.  Errors occurring are silenced.
\(Perhaps in the future there will be a way to get at the error.)
Returns t if the feature was successfully required."
  (condition-case nil
      (progn (require feat) t)
    (error nil)))

;; Load customization file now
(when running-xemacs
  (progn (setq custom-file "~/.xemacs/custom.el")
	 (load custom-file)
	 (let ((file (expand-file-name custom-file)))
	   (add-one-shot-hook 'after-init-hook
			      `(lambda () (setq custom-file ,file))))
	 (setq custom-file (make-temp-name "/tmp/non-existent-"))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                          Load packages                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; make sensible buffer names
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-min-dir-content '2)
(delay-uniquify-rationalize-file-buffer-names)

; for gnuclient (shell: alias x='gnuclient')
(gnuserv-start)

;(load-library "completer")  ; complete by word-abbreviation
(require 'completer)
(require 'vc )
(require 'php-mode)

;; (autoload 'css-mode "css-mode")
(require 'css-mode "~/.xemacs/css-mode.elc")
(setq auto-mode-alist       
      (cons '("\\.css\\'" . css-mode) auto-mode-alist))

;; (Init-safe-require 'dired)
(or (Init-safe-require 'efs-auto) (Init-safe-require 'ange-ftp))

(Init-safe-require 'filladapt)
(setq-default filladapt-mode t)
(when (fboundp 'turn-off-filladapt-mode)
  (add-hook 'c-mode-hook 'turn-off-filladapt-mode)
  (add-hook 'outline-mode-hook 'turn-off-filladapt-mode))

;; ParEdit structure editing
(add-to-list 'load-path "~/lib/emacs/")
(autoload 'paredit-mode "paredit"
  "Minor mode for pseudo-structurally editing Lisp code."
  t)
(add-hook 'lisp-mode-hook (lambda () (paredit-mode +1)))

;;; func-menu is a package that scans your source file for function
;;; definitions and makes a menubar entry that lets you jump to any
;;; particular function definition by selecting it from the menu.  The
;;; following code turns this on for all of the recognized languages.
(cond ((and running-xemacs (Init-safe-require 'func-menu))
       (global-set-key '(shift f12) 'function-menu)
       (add-hook 'find-file-hooks 'fume-add-menubar-entry)
       (global-set-key "\C-cl" 'fume-list-functions)
       (global-set-key "\C-cg" 'fume-prompt-function-goto)

;       ;; If you use this next binding, it will conflict with Hyperbole's setup.
       (global-set-key '(shift button3) 'mouse-function-menu)

;       ;; For descriptions of the following user-customizable variables,
;       ;; type C-h v <variable>
       (setq fume-max-items 25
             fume-fn-window-position 3
             fume-auto-position-popup t
             fume-display-in-modeline-p t
             fume-menubar-menu-name
	     (if (fboundp 'submenu-generate-accelerator-spec)
		 "Function%_s" "Functions")
             fume-buffer-name "*Function List*"
             fume-no-prompt-on-valid-default nil)
       ))

;;; scroll-in-place is a package that keeps the
;;; cursor on the same line (and in the same column) when scrolling by
;;; a page using PgUp/PgDn.

(if (Init-safe-require 'scroll-in-place)
    (turn-on-scroll-in-place))


;;; ilisp setup - controlling and interfacing with other Lisp processes
;; "TMC completion"
(load "completion")
(initialize-completions)

;; typeout-window keys
(add-hook 'ilisp-load-hook
   '(lambda ()
      (define-key global-map "\C-c1" 'ilisp-bury-output)
      (define-key global-map "\C-cv" 'ilisp-scroll-output)
      (define-key global-map "\C-cg" 'ilisp-grow-output)))

;; Autoload based on your Lisp. You only really need the one you use.
;; TODO: OpenMCL
(autoload 'run-ilisp   "ilisp" "Select a new inferior Lisp." t)
(autoload 'common-lisp "ilisp" "Inferior generic Common Lisp." t)
;(autoload 'allegro     "ilisp" "Inferior Allegro Common Lisp." t)
;(autoload 'cmulisp     "ilisp" "Inferior CMU Common Lisp." t)
(autoload 'clisp-hs    "ilisp" "Inferior Haible/Stoll CLISP Common Lisp." t)
(autoload 'guile       "ilisp" "Inferior GUILE Scheme." t)

;; path setup
;(setq allegro-program  "/usr/local/acl5/lisp")
;(setq cmulisp-program  "/usr/local/lib/cmucl/bin/lisp")
(setq clisp-hs-program "/sw/bin/clisp -I")
(setq guile-program    "/sw/bin/guile")

;; This makes reading a Lisp or Scheme file load in ILISP.
(set-default 'auto-mode-alist
	     (append '(("\\.lisp$" . lisp-mode)
                       ("\\.lsp$" . lisp-mode)
                       ("\\.cl$" . lisp-mode))
                     auto-mode-alist))
(add-hook 'lisp-mode-hook '(lambda () (require 'ilisp)))
(set-default 'auto-mode-alist
             (append '(("\\.scm$" . scheme-mode)
                       ("\\.ss$" . scheme-mode)
                       ("\\.stk$" . scheme-mode)
                       ("\\.stklos$" . scheme-mode))
                     auto-mode-alist))
(add-hook 'scheme-mode-hook '(lambda () (require 'ilisp)))

;; online documentation
;; If you have a local copy of the HyperSpec, set its path here.
; (setq common-lisp-hyperspec-root
;       "file:/home/joe/HyperSpec/")
; (setq common-lisp-hyperspec-symbol-table
;       "/home/joe/HyperSpec/Data/Map_Sym.Txt")

;; Here's how to get the newest version of the CLHS:
;; <http://groups.google.com/groups?selm=sfwvgftux7g.fsf%40shell01.TheWorld.com>

;;; Configuration of Utz-Uwe Haus' CLtL2 access package.
;; If you have a local copy of CLtL2, set its path here.
; (setq cltl2-root-url
;       "file:/home/joe/cltl2/")

;; from the Sample load hook
(add-hook 'ilisp-load-hook
          '(lambda ()
             ;; Change default key prefix to C-c
             (setq ilisp-*prefix* "\C-c")

             ;; Set a keybinding for the COMMON-LISP-HYPERSPEC command
             (defkey-ilisp "" 'common-lisp-hyperspec)

             ;; Make sure that you don't keep popping up the 'inferior
             ;; Lisp' buffer window when this is already visible in
             ;; another frame. Actually this variable has more impact
             ;; than that. Watch out.
             ; (setq pop-up-frames t)

             (message "Running ilisp-load-hook")
             ;; Define LispMachine-like key bindings, too.
             (ilisp-lispm-bindings)

             ;; Set the inferior Lisp directory to the directory of
             ;; the buffer that spawned it on the first prompt.
             (add-hook 'ilisp-init-hook
                       '(lambda ()
                          (default-directory-lisp ilisp-last-buffer)))
             ))

;; DesktopAid
;(setq load-path (cons "/Users/gcg/lib/emacs/desktopaid/" load-path))
;(autoload 'dta-hook-up "desktopaid.elc" "Desktop Aid" t)
;; (load "~/lib/emacs/desktopaid/desktopaid")
;(dta-hook-up)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                      Fun for Key Bindings                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun Init-kill-entire-line (&optional arg)
"Kill the entire line.
With prefix argument, kill that many lines from point.  Negative
arguments kill lines backward.

When calling from a program, nil means \"no arg\",
a number counts as a prefix arg."
  (interactive "*P")
  (let ((kill-whole-line t))
    (beginning-of-line)
    (call-interactively 'kill-line)))

(defun Init-buffers-tab-omit (buf)
  ;; a function specifying the buffers to omit from the buffers tab.
  ;; This is passed a buffer and should return non-nil if the buffer
  ;; should be omitted.  If the standard buffers-tab functionality is
  ;; there, we just call it to do things "right".  Otherwise we just
  ;; omit invisible buffers, snarfing the code from
  ;; `buffers-menu-omit-invisible-buffers'.
  (if (boundp 'buffers-tab-omit-function)
      (funcall buffers-tab-omit-function buf)
    (not (null (string-match "\\` " (buffer-name buf))))))

(defun switch-to-next-buffer (&optional n)
  "Switch to the next-most-recent buffer.
This essentially rotates the buffer list forward.
N (interactively, the prefix arg) specifies how many times to rotate
forward, and defaults to 1.  Buffers whose name begins with a space
\(i.e. \"invisible\" buffers) are ignored."
  ;; Here is a different interactive spec.  Look up the function
  ;; `interactive' (i.e. `C-h f interactive') to understand how this
  ;; all works.
  (interactive "p")
  (dotimes (n (or n 1))
    (loop
      do (bury-buffer (car (buffer-list)))
      while (Init-buffers-tab-omit (car (buffer-list))))
    (switch-to-buffer (car (buffer-list)))))

(defun buffers-menu-omit-invisible-buffers (buf)
  "For use as a value of `buffers-menu-omit-function'.
Omits normally invisible buffers (those whose name begins with a space)."
  (not (null (string-match "\\` " (buffer-name buf)))))

(defvar Init-buffers-tab-grouping-regexp 
  '("^\\(gnus-\\|message-mode\\|mime/viewer-mode\\)"
    "^\\(emacs-lisp-\\|lisp-\\)")
;; If non-nil, a list of regular expressions for buffer grouping.
;; Each regular expression is applied to the current major-mode symbol
;; name and mode-name, if it matches then any other buffers that match
;; the same regular expression be added to the current group.  This is
;; a copy of `buffers-tab-grouping-regexp'.
  )

(defun Init-select-buffers-tab-buffers (buffer-to-select buf1)
  ;; Specifies the buffers to select from the buffers tab.  This is
  ;; passed two buffers and should return non-nil if the second buffer
  ;; should be selected.  If the standard buffers-tab functionality is
  ;; there, we just call it to do things "right".  Otherwise, we group
  ;; buffers by major mode and by `Init-buffers-tab-grouping-regexp'.
  ;; [We've copied `select-buffers-tab-buffers-by-mode' and
  ;; `buffers-tab-grouping-regexp'.]
  (if (boundp 'buffers-tab-filter-function)
      (funcall buffers-tab-filter-function buffer-to-select buf1)
    (let ((mode1 (symbol-name (symbol-value-in-buffer 'major-mode buf1)))
	  (mode2 (symbol-name (symbol-value-in-buffer 'major-mode 
						      buffer-to-select)))
	  (modenm1 (symbol-value-in-buffer 'mode-name buf1))
	  (modenm2 (symbol-value-in-buffer 'mode-name buffer-to-select)))
      (cond ((or (eq mode1 mode2)
		 (eq modenm1 modenm2)
		 (and (string-match "^[^-]+-" mode1)
		      (string-match
		       (concat "^" (regexp-quote 
				    (substring mode1 0 (match-end 0))))
		       mode2))
		 (and Init-buffers-tab-grouping-regexp
		      (find-if #'(lambda (x)
				   (or
				    (and (string-match x mode1)
					 (string-match x mode2))
				    (and (string-match x modenm1)
					 (string-match x modenm2))))
			       Init-buffers-tab-grouping-regexp)))
	     t)
	    (t nil)))))

(defun switch-to-previous-buffer (&optional n)
  "Switch to the previously most-recent buffer.
This essentially rotates the buffer list backward.
N (interactively, the prefix arg) specifies how many times to rotate
backward, and defaults to 1.  Buffers whose name begins with a space
\(i.e. \"invisible\" buffers) are ignored."
  (interactive "p")
  (dotimes (n (or n 1))
    (loop
      do (switch-to-buffer (car (last (buffer-list))))
      while (Init-buffers-tab-omit (car (buffer-list))))))

(defun switch-to-next-buffer-in-group (&optional n)
  "Switch to the next-most-recent buffer in the current group.
This essentially rotates the buffer list forward.
N (interactively, the prefix arg) specifies how many times to rotate
forward, and defaults to 1.  Buffers whose name begins with a space
\(i.e. \"invisible\" buffers) are ignored."
  (interactive "p")
  (dotimes (n (or n 1))
    (let ((curbuf (car (buffer-list))))
      (loop
	do (bury-buffer (car (buffer-list)))
	while (or (Init-buffers-tab-omit (car (buffer-list)))
		  (not (Init-select-buffers-tab-buffers
			curbuf (car (buffer-list)))))))
    (switch-to-buffer (car (buffer-list)))))

(defun switch-to-previous-buffer-in-group (&optional n)
  "Switch to the previously most-recent buffer in the current group.
This essentially rotates the buffer list backward.
N (interactively, the prefix arg) specifies how many times to rotate
backward, and defaults to 1.  Buffers whose name begins with a space
\(i.e. \"invisible\" buffers) are ignored."
  (interactive "p")
  (dotimes (n (or n 1))
    (let ((curbuf (car (buffer-list))))
      (loop
	do (switch-to-buffer (car (last (buffer-list))))
	while (or (Init-buffers-tab-omit (car (buffer-list)))
		  (not (Init-select-buffers-tab-buffers
			curbuf (car (buffer-list)))))))))

(defun kill-current-buffer ()
  "Kill the current buffer (prompting if it is modified)."
  (interactive)
  (kill-buffer (current-buffer)))

(defun kill-current-buffer-and-window ()
  "Kill the current buffer (prompting if it is modified) and its window."
  (interactive)
  (kill-buffer (current-buffer))
  (delete-window))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                         Key Bindings                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Function Keys (control | alt: Window Manager/KDE!}
(define-key key-translation-map 'f2 "\C-x\C-s")
(global-set-key '(shift f2)   'save-some-buffers)

(global-set-key 'f3           'dabbrev-expand)

(global-set-key 'f4           'yank-clipboard-selection) ;; Paste
(global-set-key '(shift f4)   'next-error) ;; C-x `
(global-set-key '(meta f4)    'previous-error)

(global-set-key 'f5   'other-window)

(global-set-key '(meta shift f5)   'find-library)
(global-set-key '(shift f5)   'find-function)
(global-set-key '(meta f5)    'find-variable)

(global-set-key 'f6 'switch-to-other-buffer) ;; M-C-l

(global-set-key '(meta f6) '(lambda () (interactive) (pop-to-buffer nil)))
(global-set-key '(meta shift f6) 'switch-to-buffer-other-window)

(global-set-key 'f7         'other-frame)
(global-set-key '(shift f7) 'speedbar)
(global-set-key '(meta f7)  'abbrev-mode)

(global-set-key 'f8
  (if (fboundp 'kill-entire-line) 'kill-entire-line 'Init-kill-entire-line))

(global-set-key '(meta f8) 'auto-fill-mode)

;; (define-key reftex-mode-map 'f9 'reftex-citation)
(global-set-key '(meta f9) 'reftex-citation)
(global-set-key '(control f9) 'reftex-citep)
(global-set-key '(meta control f9) 'reftex-citet)  ;; beware: C-F9 not for WM/KDE

(global-set-key '(control f10)  'describe-function-at-point)
(global-set-key '(meta f10)   'eval-last-sexp)

;; Buffer switching
;(global-set-key '(meta n) 'switch-to-next-buffer-in-group)
;(global-set-key '(meta p) 'switch-to-previous-buffer-in-group)
(global-set-key '(meta n) 'switch-to-next-buffer)
(global-set-key '(meta p) 'switch-to-previous-buffer)

(define-key global-map '(shift tab) 'tab-to-tab-stop)

;; LISPM bindings of Control-Shift-C and Control-Shift-E.
;; See comment above about bindings like this.
(define-key emacs-lisp-mode-map '(control C) 'compile-defun)
(define-key emacs-lisp-mode-map '(control E) 'eval-defun)

;; X Window keys redefined
(when (console-on-window-system-p)
  (global-set-key "\C-z" 'zap-up-to-char))

;; no exit...
(when (console-on-window-system-p)
    (global-set-key "\C-x\C-c" nil))

;; `kill-current-buffer' (defined above) deletes the current buffer.
(global-set-key '(meta kp-multiply) 'kill-current-buffer)
(global-set-key '(shift kp-multiply) 'kill-current-buffer-and-window)
(global-set-key '(control kp-multiply) 'delete-window)

;; Ugh, modes that use `suppress-keymap' and are dumped with XEmacs will
;; need their own definition.  There is no easy way to fix this.
(define-key help-mode-map '(meta kp-multiply)  'kill-current-buffer)
(define-key help-mode-map '(shift kp-multiply) 'kill-current-buffer-and-window)
(define-key list-mode-map '(meta kp-multiply)  'kill-current-buffer)
(define-key list-mode-map '(shift kp-multiply) 'kill-current-buffer-and-window)

(global-set-key '(shift kp-add) 'query-replace-regexp)
(global-set-key '(control kp-add) 'query-replace)

(global-set-key '(shift kp-enter) 'repeat-complex-command)
(global-set-key '(control kp-enter) 'eval-expression)
(global-set-key 'kp-enter (lambda () (interactive) (set-mark-command t)))

;; This doesn't work: need's a mouse or misc-user event :(
;(global-set-key 'menu 'popup-mode-menu)
;(global-set-key '(meta menu) 'popup-buffer-menu)
;; For MacOS X, where there's no menu key
;(global-set-key 'f14 'popup-mode-menu)
;(global-set-key 'f15 'popup-buffer-menu)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                           Miscellaneous                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(setq frame-title-format "%b [%f]: emacs")
(setq frame-title-format "%b: emacs")

;;; Put all of your autosave files in one place, instead of scattering
;;; them around the file system.  
(unless (and (eq system-type 'windows-nt)
	     (not (emacs-version>= 21 4)))
  (setq auto-save-directory (expand-file-name "~/.autosave/")
	auto-save-directory-fallback auto-save-directory
	auto-save-hash-p nil
	efs-auto-save t
	efs-auto-save-remotely nil
	;; now that we have auto-save-timeout, let's crank this up
	;; for better interactive response.
	auto-save-interval 2000
	)
  )

;; speed up C parsing
(setq c-recognize-knr-p nil)

;; replace region on insert
(if (fboundp 'pending-delete-mode)
    (pending-delete-mode 1))

;; minibuffer settings
(setq minibuffer-max-depth nil)

(when (fboundp 'resize-minibuffer-mode)
  (resize-minibuffer-mode)
  (setq resize-minibuffer-window-exactly nil))

;; Rearrange the modeline so that everything is to the left of the
;; long list of minor modes, which is relatively unimportant but takes
;; up so much room that anything to the right is obliterated.
(setq-default
 modeline-format
 (list
  ""
  (if (boundp 'modeline-multibyte-status) 'modeline-multibyte-status "")
  (cons modeline-modified-extent 'modeline-modified)
  (cons modeline-buffer-id-extent
	(list (cons modeline-buffer-id-left-extent
		    (cons 15 (list
			      (list 'line-number-mode "L%l ")
			      (list 'column-number-mode "C%c ")
			      (cons -3 "%p"))))
	      (cons modeline-buffer-id-right-extent "%17b")))
  " "
  'global-mode-string
  " %[("
  (cons modeline-minor-mode-extent
	(list "" 'mode-name 'minor-mode-alist))
  (cons modeline-narrowed-extent "%n")
  'modeline-process
  ")%]--"
  "%-"
  ))

;; Get rid of modeline information taking up too much space -- in
;; particular, minor modes that are always enabled.
(setq pending-delete-modeline-string "")
(setq filladapt-mode-line-string "")

;; show speedbar
;(speedbar)

;; slime
(add-to-list 'load-path "/home/gcg/lib/emacs/slime-cvs")
(setenv "SBCL_HOME" "/home/gcg/lib/sbcl")
(setq inferior-lisp-program "/usr/local/bin/sbcl")
(require 'slime)
(setq slime-multiprocessing t)

;(setq slime-net-coding-system "utf-8-unix")
;(setq slime-net-coding-system 'iso-latin-1-unix)

(add-hook 'slime-connected-hook 'slime-ensure-typeout-frame)
(slime-setup :autodoc t)

;; load my abbrevs
(read-abbrev-file "~/.xemacs/abbrevs")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
