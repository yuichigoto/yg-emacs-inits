;;参考：
;; https://www.emacswiki.org/emacs/WhiteSpace
;; https://qiita.com/itiut@github/items/4d74da2412a29ef59c3a
;; https://ja.wikipedia.org/wiki/Unicode%E4%B8%80%E8%A6%A7_0000-0FFF

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

