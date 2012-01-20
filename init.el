;; .emacs file for Noah Hoffman - ngh2 AT uw.edu - This is public
;; domain software - do whatever you want with it, but there is
;; absolutely no warranty. Note license information associated with
;; other files included in this archive.

;; modified by FS

;; NOTES
;; for auto-revert-mode see http://www.cs.cmu.edu/cgi-bin/info2www?(emacs)Reverting
;; note variable auto-revert-interval

;; non-default key mappings defined here:
;; f5 ; Call last keyboard macro
;; f6 ; Toggle lineum-mode
;; f7 ; toggle visual-line-mode
;; C-x C-b ; remap to electric-buffer-list
;; C-x m ; remap to imenu (default is compose-mail)  
;; C-right ; next-buffer
;; C-left ; previous-buffer
;; C-x C-c ; prompts to confirm save-buffers-kill-terminal
;; C-M-; ; copy region and comment
(message "using .emacs $Id: init.el 2575 2010-01-04 18:08:16Z nhoffman $")

(setq column-number-mode t)
(setq inhibit-splash-screen t)
(setq require-final-newline t)
(setq make-backup-files nil) ;; no backup files
(setq scroll-conservatively 1) ;; scroll by one line to follow cursor off screen

(transient-mark-mode 1) ;; highlight active region - not needed in emacs 23.1+
;; (global-set-key (kbd "\C-x\C-b") 'electric-buffer-list)
(global-set-key (kbd "\C-x m") 'imenu) ;; overwrites default sequence for compose-mail

;; not really a change
;; shortcuts for keyboard macros
;; see http://www.emacswiki.org/emacs/KeyboardMacros
;; note that default bindings for macros are
;; C-x ( – start defining a keyboard macro
;; C-x ) – stop defining the keyboard macro
;; C-x e – execute the keyboard macro
(global-set-key '[(f5)]          'call-last-kbd-macro)
(global-set-key '[(shift f5)]    'toggle-kbd-macro-recording-on)

(defun toggle-kbd-macro-recording-on ()
  "One-key keyboard macros: turn recording on."
  (interactive)
  (define-key
    global-map
    (events-to-keys (this-command-keys) t)
    'toggle-kbd-macro-recording-off)
  (start-kbd-macro nil))

(defun toggle-kbd-macro-recording-off ()
  "One-key keyboard macros: turn recording off."
  (interactive)
  (define-key
    global-map
    (events-to-keys (this-command-keys) t)
    'toggle-kbd-macro-recording-on)
  (end-kbd-macro))

;; not available before 23.1
(global-set-key (kbd "<f6>") 'linum-mode)
(global-set-key (kbd "<f7>") 'visual-line-mode)

;; default font
;; (set-default-font "Bitstream Vera Sans Mono-14")
(condition-case nil 
    (set-default-font "Liberation Mono-10")
  (error (message "** could not load Liberation Mono-10")))

;; key bindings for mac - see
;; http://stuff-things.net/2009/01/06/emacs-on-the-mac/
;; http://osx.iusethis.com/app/carbonemacspackage
(cond ((string= "mac" window-system)
       (message "** running carbon windowing system")
       (set-keyboard-coding-system 'mac-roman)
       (setq mac-option-modifier 'meta)
       (setq mac-command-key-is-meta nil)
       ))

;; Copies lines without selecting them
;; see http://emacs-fu.blogspot.com/2009/11/copying-lines-without-selecting-them.html
(defadvice kill-ring-save (before slick-copy activate compile) "When
  called interactively with no active region, copy a single line
  instead."  (interactive (if mark-active (list (region-beginning)
  (region-end)) (message "Copied line") (list
  (line-beginning-position) (line-beginning-position 2)))))

(defadvice kill-region (before slick-cut activate compile) "When
called interactively with no active region, kill a single line
instead."  (interactive (if mark-active (list (region-beginning)
(region-end)) (list (line-beginning-position) (line-beginning-position
2)))))

;; see http://xahlee.org/emacs/keyboard_shortcuts.html
;; would prefer to use mac-command key over control key...
;; (setq mac-command-modifier 'hyper) ; sets the command key as Hyper
(global-set-key (kbd "C-<right>") 'next-buffer)
(global-set-key (kbd "C-<left>") 'previous-buffer)

;; (setq mac-command-modifier 'hyper)
;; (global-set-key [(super right)] 'next-buffer)
;; (global-set-key [(super left)] 'previous-buffer)

;; note - for carbon, window-system is "ns"; default settings seem to
;; work

;; Default 'untabify converts a tab to equivalent number of
;; spaces before deleting a single character.
(setq backward-delete-char-untabify-method "all")
(show-paren-mode 1)
;; Start scrolling when 2 lines from top/bottom
(setq scroll-margin 2)

;; Require prompt before exit on C-x C-c 
;; http://www.dotemacs.de/dotfiles/KilianAFoth.emacs.html
(global-set-key [(control x) (control c)] 
		(function 
		 (lambda () (interactive) 
		   (cond ((y-or-n-p "Quit? ")
			  (save-buffers-kill-terminal))))))


;; automatically refresh buffers from disk (default is every 5 sec)
(global-auto-revert-mode 1)

;; set Emacs Load Path
(setq load-path (cons "~/.emacs.d" load-path))
(setq load-path (cons "/usr/local/share/emacs/site-lisp/" load-path))

;; conditional parameters for cocoa Emacs
;; (cond ((string= "ns" window-system)
;;      (message "** running ns (cocoa) windowing system")
;;      (setq load-path (cons "/usr/local/share/emacs/site-lisp/" load-path))
;; ))

;; load auctex
(condition-case nil 
    (require 'tex-site)			
  (error (message "** could not load auctex")))

;; load ess-mode
;; (condition-case nil 
;;     (require 'ess-site)
;;   (error (message "** could not load system ESS")))

;; (condition-case nil 
;;     (require 'ess-site "~/.emacs.d/ess/lisp/ess-site")
;;   (error (message "** could not load ESS in ~/.emacs.d")))
(condition-case nil 
    (require 'ess-site "~/.emacs.d/ess/lisp/ess-site")
  (error (message "** could not load local ESS in ~/.emacs.d; trying system ESS")
	 (condition-case nil 
	     (require 'ess-site)
	   (error (message "** could not load system ESS")))	 
	 )
  )

;; load nxml
(load "~/src/nxml-mode-20041004/rng-auto.el")

(setq auto-mode-alist
      (cons '("\\.\\(xml\\|xsl\\|rng\\|xhtml\\)\\'" . nxml-mode)
	    auto-mode-alist))

;; enable pylit
;; http://www.emacswiki.org/cgi-bin/wiki/pylit.el
;; As of 2007-02-09, the PyLit_ distribution does not include a script
;; to invoke PyLit's functionality from the command line.  On any
;; UNIX-like system, this can be easily worked around by creating a
;; file ``pylit`` somewhere in your executable search path (the
;; ``PATH``) with the following contents:
;;
;; #!/bin/sh
;; exec env PYTHONPATH=/path/to/pylit/repository/src \
;; python /path/to/pylit/repository/src.pylit.py "$@"
;; 
;; or perhaps better for my setup:
;; sudo cat > /usr/local/bin/pylit << EOF
;; #!/bin/sh
;; pylit.py "$@" 

;; EOF
;; sudo chmod +x /usr/local/bin/pylit

(condition-case nil 
    (require 'pylit)
  (error (message "** could not load pylit")))

(condition-case nil 
   (require 'org-install)
   (require 'org-mobile) 
;;  The following lines are always needed.  Choose your own keys.
 (error (message "** could not load system org-mode")))

;; (add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
;; (global-set-key "\C-cl" 'org-store-link)
;; (global-set-key "\C-ca" 'org-agenda)
;; (global-set-key "\C-cb" 'org-iswitchb)
;; (add-hook 'org-mode-hook 'turn-on-font-lock)

;; ;; Setup for mobile-org
;; (setq org-directory "~/org/")
;; (setq org-mobile-directory "~/Dropbox/MobileOrg/")
;; (setq org-mobile-files (list "~/org/"))
;; (setq org-mobile-inbox-for-pull "~/org/flagged.org")

;; automatic push and pull for mobileorg
;; (add-hook 'after-init-hook 'org-mobile-pull)
;; (add-hook 'kill-emacs-hook 'org-mobile-push)

;; moinmoin-mode
;;  wget -U Mozilla -O moinmoin-mode.el "http://moinmoin.wikiwikiweb.de/EmacsForMoinMoin/MoinMoinMode?action=raw"
;; requires http://homepage1.nifty.com/bmonkey/emacs/elisp/screen-lines.el

(condition-case nil 
    (require 'moinmoin-mode)
  (error (message "** could not load moinmon-mode")))

;;;;;;;; spelling ;;;;;;;
;;use aspell instead of ispell
;;this may need to remain the last line
(setq-default ispell-program-name "aspell")
(setq ispell-dictionary "en")

;;enable on-the-fly spell-check
(autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." ) 

;; support for emacs use within pine/alpine
;; see http://snarfed.org/space/emacs%20font-lock%20faces%20for%20composing%20email
(add-hook 'find-file-hooks
	  '(lambda ()
	     (if (equal "pico." (substring (buffer-name (current-buffer)) 0 5))
		 ;; (message "** running hook for pine/alpine")
		 (mail-mode)
	       )
	     )
	  )


;; python mode hooks
;; remove tab chars on save 
;; see http://www.jwz.org/doc/tabs-vs-spaces.html
(defun python-mode-untabify ()
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "[ \t]+$" nil t)
      (delete-region (match-beginning 0) (match-end 0)))
    (goto-char (point-min))
    (if (search-forward "\t" nil t)
	(untabify (1- (point)) (point-max))))
  nil)

(add-hook 'python-mode-hook
	  '(lambda ()
	     (message "Loading python-mode hooks")
	     (setq tab-width 4)
	     (setq py-indent-offset 4)
	     (setq py-indent-offset tab-width)
	     (setq py-smart-indentation t)
	     (define-key python-mode-map "\C-m" 'newline-and-indent)
	     (hs-minor-mode)
	     ;; add function index to menu bar
	     (imenu-add-menubar-index)
	     (python-mode-untabify)
	     (linum-mode)
	     )
	  )

;; ess-mode hooks
(add-hook 'ess-mode-hook
	  '(lambda()
	     (message "Loading ess-mode hooks")
	     ;; leave my underscore key alone!
	     (ess-toggle-underscore nil)
	     ;; set ESS indentation style
	     ;; choose from GNU, BSD, K&R, CLB, and C++
	     (ess-set-style 'GNU 'quiet) 
	     (flyspell-mode)
	     (ess-imenu-S) ;; add function index to menu bar TODO - why doesn't this work?
	     )
	  )

;; text mode hooks
(add-hook 'text-mode-hook
	  '(lambda ()
	     ;; (longlines-mode)
	     (flyspell-mode)
	     )
	  )

;; tex-mode hooks
(add-hook 'tex-mode-hook
	  '(lambda ()
	     (flyspell-mode)
	     (imenu-add-menubar-index) ;; add function index to menu bar
	     )
	  )

;; rst-mode hooks
(add-hook 'rst-mode-hook
	  '(lambda ()
	     (message "Loading rst-mode hooks")
	     (flyspell-mode)
	     (define-key rst-mode-map (kbd "C-c C-a") 'rst-adjust)
	     )
	  )

;; pylit-mode hooks
(add-hook 'pylit-mode-hook
	  '(lambda ()
	     (message "Loading pylit-mode hooks")
	     (flyspell-mode)
	     )
	  )

;; remote file editing using tramp
;; see http://www.gnu.org/software/tramp/
(condition-case nil 
    (require 'tramp)
  (setq tramp-default-method "scp")
  (error (message "** could not load tramp")))

;; keyboard macro copy-and-comment, bound to CM-;
(fset 'copy-and-comment
   "\367\C-x\C-x\273")
(global-set-key (kbd "M-C-;") 'copy-and-comment)

;; ibuffer
(require 'ibuffer)
(global-set-key (kbd "C-x C-b") 'ibuffer-other-window)

;; filter buffer by mode, type, custom group, etc.
(setq ibuffer-saved-filter-groups
      (quote (("default"
	       ("courier" (filename . "courierArrivals"))
	       ("reqTally" (filename . "reqTally"))
	       ("workload" (filename . "workload"))
	       ("phlebotomy" (filename . "phlebotomy"))
	       ("deltas" (filename . "deltas"))))))

    (add-hook 'ibuffer-mode-hook
              (lambda ()
                (ibuffer-switch-to-saved-filter-groups "default")))

;; automatic desktop save
(require 'desktop)

(unless (equal desktop-save-mode nil)
  (message "Enabling desktop auto-save")
  (add-hook 'auto-save-hook (lambda () (desktop-save-in-desktop-dir)))
  ;; (add-hook 'auto-save-hook (lambda () (org-mobile-push)))
  ;; (add-hook 'auto-save-hook (lambda () (org-mobile-pull)))
)

(desktop-save-mode 1)

