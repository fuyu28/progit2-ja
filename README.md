# Pro Git 第2版（日本語訳）

Pro Git ブックの第2版の日本語訳リポジトリです。

> **注記**: 本リポジトリは [progit/progit2](https://github.com/progit/progit2) を clone し、全文を AI（Claude）で日本語に機械翻訳したものです。

オンライン版はこちらからご覧いただけます: https://git-scm.com/book/ja/v2

本書はクリエイティブ・コモンズライセンスのもとでオープンソースとして公開されています。

## ビルド方法

Asciidoctor を使って電子書籍ファイルを生成できます。

```bash
$ bundle install
$ bundle exec rake book:build
```

以下の出力ファイルが生成されます:

| コマンド | 出力ファイル |
|---|---|
| `bundle exec rake book:build_html` | `progit.html` |
| `bundle exec rake book:build_epub` | `progit.epub` |
| `bundle exec rake book:build_mobi` | `progit.mobi` |
| `bundle exec rake book:build_pdf` | `progit.pdf` |

## ライセンス

本書は [Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported](https://creativecommons.org/licenses/by-nc-sa/3.0/) ライセンスのもとで公開されています。
