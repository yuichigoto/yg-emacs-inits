;; Setting for Japanese Input
(set-language-environment "Japanese")

;; Mac OSの場合InputMethodは「ことえり」をもちいるので
;; この設定はコメントアウトする。
;; Mozcの設定
;(require 'mozc)
;(setq default-input-method "japanese-mozc")
;(setq mozc-candidate-style 'overlay)

;; ターミナルから呼び出したときにターミナルに
;; 渡す文字コード
(set-terminal-coding-system 'utf-8-unix)

;; 新しく開いたファイルを保存しておくときの
;; 文字コード
(prefer-coding-system 'utf-8-unix)

;; emacsをXのアプリケーションへ貼り付ける
;; ときの文字コード
(set-clipboard-coding-system 'utf-8)
