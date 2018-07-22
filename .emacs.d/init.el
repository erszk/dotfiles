;;; Emacs init file

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	'("melpa-stable" . "http://stable.melpa.org/packages/"))
(package-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
	(package-refresh-contents)
	(package-install 'use-package))
(eval-when-compile
	(require 'use-package))
(setq use-package-always-ensure t)	; download packages if not installed

;; load customizations (keep autogenerated config out of this file)
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;;; PACKAGE CONFIGURATION
;; for info/help mode
(use-package ace-link
	:config (ace-link-setup-default))

;; keep code well-indented
(use-package aggressive-indent
	:defer t
	:init (add-hook 'prog-mode-hook #'aggressive-indent-mode)
	:pin gnu
	:diminish aggressive-indent-mode)

;; advanced movement (can move across windows)
;; NB - dependency of ace-link
(use-package avy
	:config (setq avy-timeout-seconds 0.2)
	:bind
	(("C-'" . avy-goto-char-timer)
		;; shadows goto-line, can still enter a number
		("M-g M-g" . avy-goto-line)
		("M-g w" . avy-goto-word-1))
	:bind (:map isearch-mode-map
					("C-'" . avy-isearch)))

;; for autocompletion
(use-package company
	:diminish company-mode
	:config
	(add-hook 'after-init-hook #'global-company-mode)
	(add-to-list 'company-backends 'company-ispell t))

(use-package csv-mode
	:mode "\\.csv\\'")

(use-package editorconfig
	:ensure t
	:diminish editorconfig-mode
	:config
	(editorconfig-mode 1))

;; quickly mark word/sexp/block...
(use-package expand-region
	:bind ("C-=" . er/expand-region))

;; autodetect syntax errors
;; (use-package flymake
;;	 :init
;;	 ;; smartly activate Flymode for syn-check
;;	 (add-hook 'find-file-hook #'flymake-find-file-hook)
;;	 :bind ("C-c n" . flymake-goto-next-error))

;; (require 'forth-mode "gforth.el")
(if nil
	(use-package forth-mode
		:mode "\\.fs\\'"
		:load-path
		"/usr/local/Cellar/gforth/0.7.3_1/share/emacs/site-lisp/gforth/"))

(use-package fountain-mode
	:mode "\\.ftn\\'")

(use-package hy-mode
	:mode "\\.hy\\'")

;; Helm is for posers
(use-package ido
	:ensure nil
	:config
	(ido-mode 'buffers)
	(setq ido-enable-flex-matching t))

;; the one true git porcelain
(use-package magit
	:bind ("C-c g" . magit-status))

(use-package markdown-mode
	;; autoload on markdown, default to GFM
	:commands (markdown-mode gfm-mode)
	:mode (("README\\.md\\'" . gfm-mode)
					("\\.md\\'" . markdown-mode))
	:bind (:map gfm-mode
					("C-c C-x x" . my/table-gfm-export)
					("C-c C-x c" . my/table-gfm-capture)))

;; improve on M-x package-list
(use-package paradox
	:config (setq paradox-execute-asynchronously t)
	:bind ("C-c p" . paradox-list-packages))

;; this is needed for LISP
(use-package paredit
	:commands enable-paredit-mode
	:init
	(let
		((hooks
			 '(hy-mode-hook emacs-lisp-mode-hook
					eval-expression-minibuffer-setup-hook
					ielm-mode-hook lisp-interaction-mode-hook
					lisp-mode-hook scheme-mode-hook)))
		(mapc #'(lambda (x) (add-hook x #'enable-paredit-mode))
			hooks)
		(add-hook 'paredit-mode-hook #'show-paren-mode)))

(use-package powershell
	:mode ("\\.ps[1m]\\'" . powershell-mode))

;; ;; for editing plain-text database files (see GNU recutils)
;; (use-package rec-mode
;;	 :ensure nil				; not on MELPA
;;	 :mode "\\.rec\\'"			; autoload on *.rec files
;;	 :load-path "/usr/local/Cellar/recutils/1.7/share/emacs")

;; the Superior Lisp Interaction Mode for Emacs ©
(use-package slime
	:bind ("C-c s" . slime)
	:init
	(add-hook 'slime-repl-mode-hook #'enable-paredit-mode)
	;; (add-hook 'kill-emacs-hook #'my/slime-smart-quit)
	(setq
		slime-net-coding-system 'utf-8-unix
		slime-lisp-implementations
		'((clisp ("/usr/local/bin/clisp" "-q" "-I"))
			 (sbcl ("/usr/local/bin/sbcl" "--noinform"))
			 (ccl ("/usr/local/bin/ccl64" "--quiet")))
		slime-contribs '(slime-fancy))
	:config
	(setq
		common-lisp-hyperspec-root
		"/usr/local/share/doc/hyperspec/HyperSpec/"
		common-lisp-hyperspec-symbol-table
		(concat common-lisp-hyperspec-root "Data/Map_Sym.txt")
		common-lisp-hyperspec-issuex-table
		(concat common-lisp-hyperspec-root "Data/Map_IssX.txt")))

(use-package which-key
	:init (which-key-mode)
	:diminish which-key-mode)

;; (use-package yasnippet
;;	 :diminish yas-minor-mode
;;	 :config
;;	 (setq yas-snippet-dirs '("~/.emacs.d/snippets"
;;				 "~/.emacs.d/elpa/yasnippet-0.11.0/snippets"))
;;	 (yas-global-mode 1))

;; ;; requires AUCTeX
;; (eval-after-load 'tex
;;	 (progn
;;		 (load "auctex.el" nil t t)
;;		 ;; to allow for multi-file projects
;;		 ;; this boilerplate taken from Emacswiki
;;		 (setq TeX-auto-save t
;;		TeX-parse-self t
;;		TeX-PDF-mode t)
;;		 (setq-default TeX-master nil)
;;		 ;; use latexmk for compiling
;;		 (use-package auctex-latexmk
;;			 :config (auctex-latexmk-setup))))


;;; MISC.
;;; FUNCTIONS/MACROS

(defun my/table-gfm-capture (start end)
	"convert Markdown table to Emacs table
there should be no pipes beginning or ending the line,
although this is valid syntax. Loses justification."
	(interactive "r")
	;; should prompt user for justification
	(table-capture start end "|"
		"[\n][:|-]*" 'center))

(defun my/table-gfm-export (start end)
	"uses AWK script to convert Emacs table to
GFM Markdown table"
	(interactive "r")
	(shell-command-on-region start end "gfm_table_format" t t)
	(table-unrecognize))

(defun my/setup-text-mode ()
	(toggle-word-wrap)
	(turn-on-auto-fill)
	;; (flyspell-mode)
	(add-hook 'before-save-hook #'ispell-buffer nil t))

(defun my/setup-tex-mode ()
	(auto-fill-mode -1)
	(setq ispell-parser 'tex))

(defun my/setup-sh-mode ()
	(sh-set-shell "bash"))

(defun my/setup-prog-mode ()
	(if (not (string= "Emacs-Lisp" mode-name))
		(setq page-delimiter
			(concat "^" comment-start " "))))

(add-to-list 'load-path "~/.emacs.d/pkg/gnu-apl-mode/")
(require 'gnu-apl-mode)

;;; HOOKS
(add-hook 'prog-mode-hook #'my/setup-prog-mode)
(add-hook 'text-mode-hook #'my/setup-text-mode)
(add-hook 'tex-mode-hook #'my/setup-tex-mode)
;;; LSUIElement plist hack fix for MacOS daemon
(add-hook
	'focus-in-hook
	#'(lambda ()
			(call-process-shell-command
				"issw com.apple.keylayout.USExtended" nil 0)))

(add-hook 'sh-mode-hook #'my/setup-sh-mode)
(add-hook 'before-save-hook #'whitespace-cleanup)


;;; VARIABLES
(setq inhibit-startup-message t		; no splash screen
	initial-scratch-message nil
	;; don't leaves files ending in '~' everywhere
	backup-directory-alist `(("." . "~/.emacs.d/backups"))
	load-prefer-newer t
	message-log-max 100
	ring-bell-function 'ignore
	view-read-only t)
;;; EDITING
(setq fill-column 80			; for M-q and auto-fill-mode
	require-final-newline t
	sentence-end-double-space nil
	show-trailing-whitespace t)
;;; VC
(setq vc-follow-symlinks t)
;;; ERC - Emacs IRC client
(setq erc-fill-function 'erc-fill-static
	erc-fill-static-center 23)
;;; MISC
(setq scheme-program-name "csi")

;;; TABS
;; https://www.emacswiki.org/emacs/IndentationBasics
(setq-default tab-width 4)

;;; MODES
(global-hl-line-mode t)			; highlight the line the cursor is on
(global-linum-mode 1)			; line numbering everywhere
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
;;; MODE LINE
(column-number-mode)
;; (size-indication-mode)
;;; Perl - use the superior built-in cperl-mode
;;; from https://www.emacswiki.org/emacs/CPerlMode#toc1
(mapc
	(lambda (pair)
		(if (eq (cdr pair) 'perl-mode)
			(setcdr pair 'cperl-mode)))
	(append auto-mode-alist interpreter-mode-alist))


;;; BINDINGS
(bind-keys
	;; extras
	("M-g M-j" . next-logical-line)
	("M-g M-k" . previous-logical-line)
	("M-g e" . end-of-line)
	;; shadow defaults
	("C-e" . end-of-visual-line)
	("M-z" . zap-up-to-char)
	("C-x C-b" . buffer-menu-other-window)
	;; hyper
	("H-v" . add-file-local-variable-prop-line)
	("H-p" . previous-buffer)
	("H-n" . next-buffer)
	("H-s" . eshell))

(defhydra hydra-window-and-buffer (global-map "<f7>")
	"manage windows and buffers"
	("o" other-window "cycle window")
	("0" delete-window "close window")
	("1" delete-other-windows "max")
	("2" split-window-below "horizontal split")
	("3" split-window-right "vertical split")
	("k" kill-this-buffer "kill")
	("K" kill-buffer "kill named")
	("x" kill-buffer-and-window "kill and close")
	("s" save-buffer "save")
	("S" save-some-buffers "batch save" :color blue)
	("b" switch-to-buffer "buffer")
	("B" switch-to-buffer-other-window "buffer other window")
	("f" find-file "open file" :color blue)
	("F" find-file-other-window "open other window" :color blue)
	("d" display-buffer "display buffer")
	("r" frameset-to-register "save windows")
	("R" jump-to-register "go to register" :color blue)
	("n" next-buffer "next")
	("p" previous-buffer "last")
	("C-h" windmove-left "left")
	("C-j" windmove-down "down")
	("C-k" windmove-up "up")
	("C-l" windmove-right "right")
	("}" enlarge-window-horizontally "widen")
	("{" shrink-window-horizontally "narrow")
	("^" enlarge-window "taller")
	("-" shrink-window "shorter")
	("+" balance-windows "balance")
	("m" buffer-menu-other-window "buffer menu" :color blue)
	("M" ibuffer-other-window "ibuffer" :color blue)
	("SPC" nil "quit"))

;;; -- VIEW MODE
(with-eval-after-load 'view
	(bind-keys :map view-mode-map
		("b" . View-scroll-page-backward)))

;; mirrors some system shortcuts
(global-set-key (kbd "s-f") 'toggle-frame-fullscreen)
(global-set-key (kbd "s-<up>") 'beginning-of-buffer)
(global-set-key (kbd "s-<down>") 'end-of-buffer)

;; OS-specific configuration
(case system-type
	(darwin
		;; (toggle-frame-fullscreen)
		(setq ns-command-modifier 'control
			ns-function-modifier 'hyper
			ns-control-modifier 'super)))

;; (setq flycheck-indication-mode nil)

;; For GhostText browser extension
(atomic-chrome-start-server)
;; (setq atomic-chrome-url-major-mode-alist
;;			 '(("github\\.com" . gfm-mode)
;;				 ("old\\.reddit\\.com" . markdown-mode)))

;;; ENABLED COMMANDS
(put 'narrow-to-page 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
