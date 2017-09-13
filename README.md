toWhisper
=========

音声をささやき声にかえるソフトです．

オリジナル: zeta氏 (Twitter : https://twitter.com/zeta0313) 作成の [toWhisper](https://github.com/zeta-chicken/toWhisper)

- 解説動画 http://www.nicovideo.jp/watch/sm31882296

上記のソースを C# 実装した ksasao氏 の [ToWhisperNet](https://github.com/ksasao/toWhisper) を使用しています


## 詳細

LPCボコーダをによって推測した声道フィルタを使い，
ホワイトノイズを加工することによってささやき声を合成しています．

## ダウンロード

[リリースページ](https://github.com/yamachu/toWhisper/releases)より Windows, macOSX 向けのビルド済みのアプリケーションがダウンロードが可能です．

特定の環境で起動できないバグがあるので， v_1.0.8 以降を使用してください．

## バグ

* ~~Windows 環境でファイル名もしくはパスに日本語が含まれていると正常に変換が行われない~~
  * ~~日本語が含まれない状態で変換を行ってください（現在修正中）~~
  
* Windows 環境でアプリケーションが置かれているパスに日本語が含まれていると起動できない
  * 使用しているライブラリ(Edge.js)の修正を行う必要があるため，対応は非常に遅くなる

## コンパイル

追記予定

## ライセンス

オリジナルのライセンスと同じ修正BSDライセンス
