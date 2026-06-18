# Pro Git 第2版 日本語訳

[progit/progit2](https://github.com/progit/progit2) の非公式日本語訳リポジトリです。
AI（Claude）を活用して全文を日本語に翻訳し、日本語組版の改善を加えています。

> 公式の日本語版はこちら: https://git-scm.com/book/ja/v2

## ビルド

依存 gem のインストール:

```bash
bundle install
```

### 形式別ビルド

| コマンド | 出力ファイル |
|---|---|
| `make html` | `progit.html` |
| `make epub` | `progit.epub` |
| `make fb2` | `progit.fb2.zip` |
| `make mobi` | `progit.mobi` |
| `make pdf` | `progit.pdf` |
| `make` | 全形式 |

```bash
make pdf
```

### 環境要件

- Ruby 4.0+
- 日本語フォント（PDF 用）
  - IPAMincho / IPAGothic（`/usr/share/fonts/OTF/`）
  - HackGenConsole（`/usr/share/fonts/TTF/`）

Arch Linux の場合:

```bash
sudo pacman -S otf-ipafont ttf-hackgen
```

## 翻訳について

原文の Pro Git v2 を Claude（Anthropic）で日本語に機械翻訳したものをベースにしています。
日本語組版として以下の対応を行っています:

- PDF・HTML 向けの日本語フォント設定
- 英単語と日本語の間の不要なスペース除去による改行最適化
- 図・表・目次などのキャプション日本語化

## ライセンス

原著は [Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported](https://creativecommons.org/licenses/by-nc-sa/3.0/) ライセンスで公開されています。
本翻訳も同ライセンスに従います。
