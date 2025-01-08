;;; init.el for Emacs29
;;;
;;; Refer to https://a.conao3.com/blog/2024/7c7c265/
;;
;;   emacs -q -l ~/.debug.emacs.d/init.el
(eval-and-compile
  (customize-set-variable
   'package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                       ("melpa" . "https://melpa.org/packages/")))
  
  (package-initialize)
  (use-package leaf :ensure t)

  (leaf leaf-keywords
    :ensure t
    :init
    (leaf hydra :ensure t)
    (leaf blackout :ensure t)

    :config
    (leaf-keywords-init)))

  (leaf leaf-convert
    :doc "Convert many format to leaf format"
    :ensure t)

;; ここにいっぱい設定を書く

;;; 基本設定
;;; Refer to https://www.grugrut.net/posts/my-emacs-init-el/
(leaf general-settings
  :config
  (global-set-key [mouse-2] 'mouse-yank-at-click) ;; ホイールマウス押し込みでペースト
  ;(global-unset-key "\C-z") ;; \C-z（中断）のキーバインド無効化 
  (delete-selection-mode t) ;;直接入力時に選択範囲を貼り付け文字列で置き換える。
  :setq
  (read-answer-short . t)
  ;(large-file-warning-threshold . '(* 25 1024 1024))
  (create-lockfiles . nil) ;; ファイルの排他制御を停止
  (history-length . 500)
  (history-delete-duplicates . t)
  (line-move-visual . nil)
  (mouse-drag-copy-region . t)
  (backup-inhibited . t)
  (require-final-newline . t)
  )

;; Setting for Japanese Input
(leaf *language-settings
  :config
  (set-language-environment 'Japanese) ;言語を日本語に
  (prefer-coding-system 'utf-8) ;極力UTF-8を使う
  (add-to-list 'default-frame-alist '(font . "Meiryo-15")) ;フォント設定
  (leaf mozc ;; Mozc setting
    :ensure t
    :config
    (setq default-input-method "japanese-mozc")
    ;; 2025/01/06現在、この変数を設定すると以下のWarningがでる
    ;; "Warning: assignment to free variable ‘mozc-candidate-style'"
    ;; そして、変数の設定が反映されない。
    ;(setq mozc-candidate-style 'echo-area)
    )
)

;;; autorevert - Emacs外でファイルが更新されたときに更新する
;;; Refer to https://a.conao3.com/blog/2024/7c7c265/
(leaf autorevert
  :doc "revert buffers when files on disk change"
  :global-minor-mode global-auto-revert-mode)

;;; paren - カッコのハイライト
;;; Refer to https://a.conao3.com/blog/2024/7c7c265/
(leaf paren
  :doc "highlight matching paren"
  :global-minor-mode show-paren-mode)

;;; delsel - 選択状態で入力したときに選択範囲を消す
;;; Refer to https://a.conao3.com/blog/2024/7c7c265/
(leaf delsel
  :doc "delete selection if you insert"
  :global-minor-mode delete-selection-mode)

;;; flymake - コード診断機能
;;; Refer to https://a.conao3.com/blog/2024/7c7c265/
(leaf flymake
  :doc "A universal on-the-fly syntax checker"
  :bind ((prog-mode-map
          ("M-n" . flymake-goto-next-error)
          ("M-p" . flymake-goto-prev-error))))

;;; vertico - 補完候補を縦に並べる
;;; Refer to https://a.conao3.com/blog/2024/7c7c265/
;;; verticoなどの説明 - https://apribase.net/2024/07/18/emacs-vertico-consult/
(leaf vertico
  :doc "VERTical Interactive COmpletion"
  :ensure t
  :global-minor-mode t)

;;; orderless - 順序違いの絞り込みスタイルの提供
;;; Refer to https://a.conao3.com/blog/2024/7c7c265/
(leaf orderless
  :doc "Completion style for matching regexps in any order"
  :ensure t
  :custom ((completion-styles . '(orderless))
           (completion-category-defaults . nil)
           (completion-category-overrides . '((file (styles partial-completion))))))

;;; marginalia - 補完候補について付随情報を追加する
;;; Refer to https://a.conao3.com/blog/2024/7c7c265/
(leaf marginalia
  :doc "Enrich existing commands with completion annotations"
  :ensure t
  :global-minor-mode t)

;;; consult - 補完候補を生成する
;;; Refer to https://a.conao3.com/blog/2024/7c7c265/
(leaf consult
  :doc "Consulting completing-read"
  :ensure t
  :hook (completion-list-mode-hook . consult-preview-at-point-mode)
  :defun consult-line
  :preface
  (defun c/consult-line (&optional at-point)
    "Consult-line uses things-at-point if set C-u prefix."
    (interactive "P")
    (if at-point
        (consult-line (thing-at-point 'symbol))
      (consult-line)))
  :custom ((xref-show-xrefs-function . #'consult-xref)
           (xref-show-definitions-function . #'consult-xref)
           (consult-line-start-from-top . t))
  :bind (;; C-c bindings (mode-specific-map)
         ([remap switch-to-buffer] . consult-buffer) ; C-x b
         ([remap project-switch-to-buffer] . consult-project-buffer) ; C-x p b

         ;; M-g bindings (goto-map)
         ([remap goto-line] . consult-goto-line)    ; M-g g
         ([remap imenu] . consult-imenu)            ; M-g i
         ("M-g f" . consult-flymake)

         ;; C-M-s bindings
         ("C-s" . c/consult-line)       ; isearch-forward
         ("C-M-s" . nil)                ; isearch-forward-regexp
         ("C-M-s s" . isearch-forward)
         ("C-M-s C-s" . isearch-forward-regexp)
         ("C-M-s r" . consult-ripgrep)

         (minibuffer-local-map
          :package emacs
          ("C-r" . consult-history))))

;; ローマ字検索を可能にするパッケージMIGEMO
;;; Refer to https://www.grugrut.net/posts/my-emacs-init-el/
(leaf migemo
  :ensure t
  :require t
  :defun
  (migemo-init)
  :custom
  (migemo-command . "cmigemo")
  (migemo-options . '("-q" "--emacs"))
  (migemo-dictionary . "/usr/share/cmigemo/utf-8/migemo-dict")
  (migemo-user-dictionary . nil)
  (migemo-regex-dictionary . nil)
  (migemo-coding-system . 'utf-8-unix)
  :config
  (migemo-init))

;;; files - 自動バックアップの保存場所変更
;;; Refer to https://a.conao3.com/blog/2024/7c7c265/
(leaf files
  :doc "file input and output commands for Emacs"
  :global-minor-mode auto-save-visited-mode
  :custom `((auto-save-file-name-transforms . '((".*" ,(locate-user-emacs-file "backup/") t)))
            (backup-directory-alist . '((".*" . ,(locate-user-emacs-file "backup"))
                                        (,tramp-file-name-regexp . nil)))
            (version-control . t)
            (delete-old-versions . t)
            (auto-save-visited-interval . 1)))

;;; startup - 自動バックアップされたファイルの表示
;;; Refer to https://a.conao3.com/blog/2024/7c7c265/
(leaf startup
  :doc "process Emacs shell arguments"
  :custom `((auto-save-list-file-prefix . ,(locate-user-emacs-file "backup/.saves-"))))

;;  emacsのウィンドウサイズの設定
(if window-system
    (progn
      (set-frame-size (selected-frame) 80 25)))

;; 背景、文字の色、カーソルの色の指定
(progn
  (set-background-color "black")
  (set-foreground-color "white")
  (set-cursor-color "white"))



;; emacsのウィンドウヘッダ部分の表記の設定
(progn
  (setq frame-title-format
	(format "%%f - Emacs@%s" (system-name))))



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

(provide 'init)
