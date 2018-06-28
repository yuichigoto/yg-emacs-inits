;; Use init-loader.el
;; ref. https://github.com/emacs-jp/init-loader

;; Load downloaded init-loader.el
;; ref. http://tatsuyano.github.io/blog/2013/03/19/emacs-el-get-init-loader/

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq load-path
      (append
       (list
	(expand-file-name "~/.emacs.d/init-loader/")
	)
       load-path))

;; Define directory of init files.
(require 'init-loader)
(init-loader-load "~/.emacs.d/inits")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (migemo))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
