;; 背景と全景とテキストの色
(set-background-color "black")
(set-foreground-color "white")
(set-cursor-color "white")

;; 自動セーブの中止
(setq auto-save-default nil)

;; メニューバーにファイルパスを表示する
(setq frame-title-format
      (format "%%f - Emacs@%s" (system-name)))
