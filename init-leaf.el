;;; init.el --- My init.el  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Naoya Yamashita

;; Author: Naoya Yamashita <conao3@gmail.com>

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; My init.el.

;;; Code:

;; this enables this running method
;;   emacs -q -l ~/.debug.emacs.d/init.el
(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
           (file-name-directory (or load-file-name byte-compile-current-file))))))

(eval-and-compile
  (customize-set-variable
   'package-archives '(("gnu"   . "https://elpa.gnu.org/packages/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("org"   . "https://orgmode.org/elpa/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))

;; ここにいっぱい設定を書く

;;; ref. https://emacs-jp.github.io/tips/emacs-in-2020ep
(leaf leaf
  :config
  (leaf leaf-convert :ensure t)
  (leaf leaf-tree
    :ensure t
    :custom ((imenu-list-size . 30)
             (imenu-list-position . 'left))))


;;  emacsのウィンドウサイズの設定
(if window-system
    (progn
      (set-frame-size (selected-frame) 80 25)))

;; 背景、文字の色、カーソルの色の指定
(progn
  (set-background-color "black")
  (set-foreground-color "white")
  (set-cursor-color "white"))

;; 自動セーブの停止
(progn
  (setq auto-save-default nil))

;; emacsのウィンドウヘッダ部分の表記の設定
(progn
  (setq frame-title-format
	(format "%%f - Emacs@%s" (system-name))))

;; Setting for Japanese Input
(progn
  (set-language-environment "Japanese")
  ;; ターミナルから呼び出したときにターミナルに
  ;; 渡す文字コード
  (set-terminal-coding-system 'utf-8-unix)
  ;; 新しく開いたファイルを保存しておくときの
  ;; 文字コード
  (prefer-coding-system 'utf-8-unix)
  ;; emacsをXのアプリケーションへ貼り付ける
  ;; ときの文字コード
  (set-clipboard-coding-system 'utf-8))

(progn
  (require 'mozc)
  (setq default-input-method "japanese-mozc")
  (setq mozc-candidate-style 'overlay))

;; emacsで使用するフォントの設定
;; Windows上のフォント（メイリオフォント）を使っているので
;; 先にWindows上のフォントを利用できるように設定すること。
(progn
  (add-to-list 'default-frame-alist '(font . "Meiryo-13.5"))
  (custom-set-faces
   '(variable-pitch ((t (:family "Meiryo"))))
   '(fixed-pitch ((t (:family "Meiryo"))))
   ))

;;参考：
;; https://www.emacswiki.org/emacs/WhiteSpace
;; https://qiita.com/itiut@github/items/4d74da2412a29ef59c3a
;; https://ja.wikipedia.org/wiki/Unicode%E4%B8%80%E8%A6%A7_0000-0FFF
(progn
  (require 'whitespace)
  (global-whitespace-mode 1)
  (setq whitespace-style '(
			   face            ; 可視化
			   trailing        ; 行末
			   tabs            ; タブ
			   spaces        ; スペース
			   empty         ; 先頭、末尾のスペース
			   space-mark ; 全角スペースの別記号表記
			   tab-mark    ; タブの別記号表記
			   ))
  (setq whitespace-display-mappings
        '(
          (space-mark ?\u3000 [?\u20DE]) ; 全角スペースを別記号で表記
          (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t]) ; タブを別記号で表記
          ))
  (setq whitespace-trailing-regexp  "\\([ \u00A0]+\\)$")
  (setq whitespace-space-regexp "\\(\u3000+\\)")
  (set-face-attribute 'whitespace-trailing nil
                      :foreground "RoyalBlue4"
                      :background "RoyalBlue4"
                      :underline nil)
  (set-face-attribute 'whitespace-tab nil
                      :foreground "orange red"
                      :background "yellow4"
                      :underline nil)
  (set-face-attribute 'whitespace-space nil
                      :foreground "gray40"
                      :background "light gray"
                      :underline nil))

;;; ref. https://emacs-jp.github.io/tips/emacs-in-2020
(leaf autorevert
  :doc "revert buffers when files on disk change"
  :tag "builtin"
  :custom ((auto-revert-interval . 0.1))
  :global-minor-mode global-auto-revert-mode)

;;; ミニバッファの拡張機能 ivy
;;; ref. https://emacs-jp.github.io/tips/emacs-in-2020
;;; ref. https://github.com/abo-abo/swiper
(leaf ivy
  :doc "Incremental Vertical completYon"
  :req "emacs-24.5"
  :tag "matching" "emacs>=24.5"
  :url "https://github.com/abo-abo/swiper"
  :emacs>= 24.5
  :ensure t
  :blackout t
  :leaf-defer nil
  :custom ((ivy-initial-inputs-alist . nil)
           (ivy-use-selectable-prompt . t))
  :global-minor-mode t
  :config

 ; 2020/4/12 後藤注：Migemoと併用する方法が
 ; わからないのでコメントアウトしている。
 ;(leaf swiper
 ;   :doc "Isearch with an overview. Oh, man!"
 ;   :req "emacs-24.5" "ivy-0.13.0"
 ;   :tag "matching" "emacs>=24.5"
 ;   :url "https://github.com/abo-abo/swiper"
 ;   :emacs>= 24.5
 ;   :ensure t
 ;   :bind (("C-s" . swiper)))

  (leaf counsel
    :doc "Various completion functions using Ivy"
    :req "emacs-24.5" "swiper-0.13.0"
    :tag "tools" "matching" "convenience" "emacs>=24.5"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :blackout t
    :bind (("C-S-s" . counsel-imenu)
           ("C-x C-r" . counsel-recentf))
    :custom `((counsel-yank-pop-separator . "\n----------\n")
              (counsel-find-file-ignore-regexp . ,(rx-to-string '(or "./" "../") 'no-group)))
    :global-minor-mode t))

(leaf prescient
  :doc "Better sorting and filtering"
  :req "emacs-25.1"
  :tag "extensions" "emacs>=25.1"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :custom ((prescient-aggressive-file-save . t))
  :global-minor-mode prescient-persist-mode)
  
(leaf ivy-prescient
  :doc "prescient.el + Ivy"
  :req "emacs-25.1" "prescient-4.0" "ivy-0.11.0"
  :tag "extensions" "emacs>=25.1"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :after prescient ivy
  :custom ((ivy-prescient-retain-classic-highlighting . t))
  :global-minor-mode t)

;; ローマ字検索を可能にするパッケージMIGEMO
(progn
  (require 'migemo)
  (setq migemo-command "cmigemo")
  (setq migemo-options '("-q" "--emacs"))
  (setq migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict")
  (setq migemo-user-dictionary nil)
  (setq migemo-regex-dictionary nil)
  (setq migemo-coding-system 'utf-8-unix)
  (load-library "migemo")
  (migemo-init))

(provide 'init)
