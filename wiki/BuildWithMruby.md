# 如何使用 mruby 函式庫建置 BBS-Ruby

本文為如何使用 mruby 函式庫建置 BBS-Ruby 的簡要說明。

以下內容為針對 mruby 3.0.0 所撰寫。

## 建置環境

請參考附在 mruby 原始碼（下述）中的說明，安裝必要的套件。

此說明位於 mruby 原始碼目錄下的 `doc/guides/compile.md`，請見 Prerequisites 一節。

此外，需要安裝 `rake` 建置工具。

## 取得 mruby 原始碼

可行的兩種方式：
1. 從 [mruby.org](https://mruby.org) 下載原始碼壓縮檔
2. 使用 `git` 取得原始碼

以下說明以 `git` 取得原始碼的方式。

```shell
$ git clone https://github.com/mruby/mruby.git
$ cd mruby/
$ git checkout stable
```

## 建置 mruby 函式庫

在 BBS-Ruby 原始碼目錄中的 `mruby_build_config/` 目錄下，已準備了適用於 BBS-Ruby 的 mruby 建置設定檔，請選擇其一使用。

請記住這個建置設定檔的路徑。

接著進入 mruby 的原始碼目錄下，執行：
```shell
$ CONFIG=<建置設定檔路徑> rake clean all
```
即可建置完成。

請確認 `build/<建置設定檔檔名>/bin/mruby-config` 此執行檔是否存在，並且記住其路徑。

有關建置 mruby 函式庫的進一步資訊，可見 <https://mruby.org/docs/api/>。

## 建置 BBS-Ruby

BBS-Ruby 原始碼目錄中的 `Makefile` 僅是範例，未搭配 BBS 原始碼則無法完成建置。

不過此段落會說明此 `Makefile` 的大致使用方式。

本 `Makefile` 中定義了 `RUBY_CFLAGS` 與 `RUBY_LDFLAGS` 兩個變數，需要配合 `mruby-config` 以正確代入。

進入 BBS-Ruby 的原始碼目錄下，執行：
```shell
MRB_CONFIG=<mruby-config 路徑> make
```
即可自動代入合適的建置設定並進行建置。

根據此 `Makefile` 所寫的規則，假如建置完成，應會產生 `bbsruby.so` 這個共用函式庫。
