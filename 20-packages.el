;; Load package repository
;; ref. http://qiita.com/catatsuy/items/5f1cd86e2522fd3384a0
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))

;; このパッケージリポジトリは壊れているとのこと
;; https://qastack.jp/emacs/33061/tls-connection-to-marmalade-repo-org443-is-insecure-after-updating-to-emacs-25
;(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)
