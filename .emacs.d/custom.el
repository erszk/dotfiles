;;; CUSTOMIZATIONS
;;; Where all auto-inserted values go
;;; from using M-x customize-group, etc.

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
	'(ansi-color-names-vector
		 ["#2d3743" "#ff4242" "#74af68" "#dbdb95" "#34cae2" "#008b8b" "#00ede1" "#e1e1e0"])
 '(custom-enabled-themes (quote (deeper-blue)))
	'(dired-garbage-files-regexp
		 "\\.\\(?:aux\\|bak\\|dvi\\|log\\|orig\\|rej\\|toc\\|DS_Store\\)\\'")
	'(flymake-allowed-file-name-masks
		 (quote
			 (("\\.\\(?:c\\(?:pp\\|xx\\|\\+\\+\\)?\\|CC\\)\\'" flymake-simple-make-init nil nil)
				 ("\\.cs\\'" flymake-simple-make-init nil nil)
				 ("\\.p[ml]\\'" flymake-perl-init nil nil)
				 ("\\.h\\'" flymake-master-make-header-init flymake-master-cleanup nil))))
	'(flymake-proc-allowed-file-name-masks
		 (quote
			 (("\\.\\(?:c\\(?:pp\\|xx\\|\\+\\+\\)?\\|CC\\)\\'" flymake-simple-make-init nil nil)
				 ("\\.cs\\'" flymake-simple-make-init nil nil)
				 ("\\.p[ml]\\'" flymake-perl-init nil nil)
				 ("\\.h\\'" flymake-master-make-header-init flymake-master-cleanup nil))))
 '(indicate-buffer-boundaries (quote left))
	'(package-selected-packages
		 (quote
			 (powershell forth-mode hy-mode editorconfig atomic-chrome lua-mode fish-mode fountain-mode haskell-mode abc-mode apples-mode yaml-mode csv-mode yasnippet aggressive-indent ace-link company auctex-latexmk agressive-indent markdown-mode auctex expand-region which-key paradox use-package typit magit paredit slime)))
 '(paradox-github-token t))

(custom-set-faces
	;; custom-set-faces was added by Custom.
	;; If you edit it by hand, you could mess it up, so be careful.
	;; Your init file should contain only one such instance.
	;; If there is more than one, they won't work right.
	'(default ((t (:inherit nil :stipple nil :background "#181a26" :foreground "gray80" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 160 :width normal :foundry "nil" :family "Menlo"))))
	'(Man-overstrike ((t (:inherit bold :foreground "dark orange"))))
	'(Man-underline ((t (:inherit bold :foreground "SteelBlue3"))))
	'(hl-line ((t (:background "gray32" :underline "Yellow"))))
	'(mode-line ((t (:box 1))))
	'(region ((t (:background "firebrick4" :foreground "#f6f3e8")))))


;;; EXTRACTED FROM CUSTOMIZE
;;; midnight mode
(setq
	midnight-mode t
	clean-buffer-list-kill-buffer-names
	'("*Disabled Command*" "*Help*" "*Apropos*" "*Buffer List*" "*Compile-Log*"
		 "*vc*" "*vc-diff*" "*Diff*" "*Backtrace*" "*Warnings*")
	clean-buffer-list-kill-never-buffer-names '("*scratch*")
	clean-buffer-list-kill-regexps
	'("\\`\\*Man " "\\`\\*magit" "\\`\\*Paradox" "\\`\\*info"))

;;; spelling
(setq
	ispell-dictionary "en"
	ispell-help-in-bufferp 'electric)

;;; editing
(setq
	kill-do-not-save-duplicates t
	next-line-add-newlines t
	save-interprogram-paste-before-kill t)
