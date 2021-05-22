原文作者：**[@itsZero](https://github.com/itszero)**

BBSRuby 版本 v0.3-DL-2, API Interface: v0.111

Source Code下載：http://orez.us/~zero/BBSRuby.c

## 為什麼開發 BBSRuby?

因為人家有 BBSLua （誤），其實只是想學學看怎麼把 Ruby interpreter 嵌入程式中。剛好人家有這麼棒的點子就拿來用囉XD

以前也曾想要寫 C# 的 BBS\
有一項功能就是用 C# 的 Runtime Compiler Service 弄 C# Script。

不過... 該計畫... 被放棄了（小聲） 所以算是實現當時的願望吧 (?) XD

## 已知問題

1. 在 CRuby 下，Ruby 全域變數／物件不會重設

## 修改記錄

v0.2
1. 修正行號不會重新計算的問題，只要故意load一個空白檔案就可以了。 :P

v0.3
1. 修正getch()對於特殊按鍵沒反應的問題

v0.3-DlPatch-1
* API 變更
    1. 重新定義 `getyx()`/`getmaxyx()` 結果的 `y` 為 row，`x` 為 column
        * 避免與其他 BBS 系統的定義衝突
        * 可以透過 `bbsruby.c` 開頭的環境設定恢復成 `x` 為 row，`y` 為 column 的定義
        * 建議改用如 `r, c = getyx().values` 的方式讀取結果
* 問題修正
    1. 修正 memory leak 以及其他記憶體存取問題
        1. 修正 Ruby interpreter 會隨機顯示 parse 錯誤的問題
    2. 修正 BBS-Ruby 執行失敗會造成 segmentation fault 的問題
    3. 修正執行 BBS-Ruby 會造成所有的 signal handler 被取代的問題
    4. 部分解決 Ruby 變數／物件不會重設的問題
    5. 修正 `move()`/`moverel()` 的結果不正確的問題
    6. 修正不接受說明文件中的 TOC 標籤格式的問題
* 功能改進
    1. 增加對 Ruby 2.0 ~ 2.2 的支援
        * 由於安全上的問題，暫不支援 Ruby 2.3+
        * 目前建議使用 Ruby 2.2 編譯
    2. 現在 BBS-Ruby 可以在其他 Maple3 / PttBBS 上編譯了
        * 可能需要自行調整 `bbsruby.c` 開頭的環境設定
    3. 讓程式出錯時的錯誤訊息更為詳細
    4. 現在 BBS-Ruby 在執行前會檢查版本
    5. 讓程式行號與文章行號一致
    6. 現在執行 BBS-Ruby 時會先清除螢幕
    7. 放寬 TOC 標籤語法
        1. TOC 標籤可以用 `##` 或 `###` 開頭
        2. TOC 標籤可以包含空格，也接受大小寫混合
        3. 可以用全小寫的 key 存取 TOC 標籤
    8. 讓 `getdata()` 在支援的 BBS 上可以用 Ctrl-C 跳出
* 其他
    1. 重新排版程式碼，修正程式碼錯字及亂碼
    2. 將程式碼改寫成符合 ISO C90/C99 標準
    3. 修正程式碼中誤用函數／參數型別不符的問題
    4. 不再load空白檔案 `empty.rb`；移除 `RubyFix.h`
    5. 將 C API 函數名稱改為以 `brb_` 開頭
    6. 其他程式碼重構／細節修正

v0.3-DL-2
* API 變更
    1. 重新定義全域物件 `BBS` 為 Ruby module 而非 Ruby class
* 問題修正
    1. 修正執行 BBS-Ruby 時沒有真的清除螢幕的問題
    2. 避免 BBS-Ruby 執行失敗時印出的錯誤訊息可能與背景同色而隱形的問題
    3. 解決 Ruby 全域變數／物件不會重設的問題 (需要 mruby)
* 功能改進
    1. 增加對 mruby 的支援，解決 Ruby 全域變數／物件不會重設的問題
    2. 使用白名單控制 Ruby gem library 的載入 (需要 mruby)
* 程式改進
    1. 強化程式碼的 const correctness
    2. 讓程式碼符合 ISO C++98 標準，支援使用 C++ 編譯器編譯
    3. 用型別安全的 `rb_funcallv()` 取代 `rb_funcall()` 的使用
    4. 將接受任意數量參數的 C API 函數改寫成接受 C array 而非 Ruby array
    5. 其他程式碼重構／細節修正
* 其他
    1. 不再設定 signal handler
    2. 避免在 Ruby interpreter 初始化前印錯誤訊息

## 如何撰寫

BBSRuby大致上與BBSLua相容，不過依然有一些變動。如程式開頭結束皆使用`###BBSRuby`。

至於API的部份，BBSRuby將參考BBSLua API實做。

以下將以BBSLua的API列表搭配說明/強調格式指示支援狀態。原文作者為 piaip。

支援狀況： ~~不支援~~ _與BBSLua有異_ 完全支援 **BBSRuby專屬**

TOC標籤 ||
 -------------- | ------------------------------------------------
　|　(以下亦可用 `###` 開頭；字的前後可包含空格，亦接受大小寫混合)
`##Interface:`  |BBS-Ruby API 版本號碼 (可方便系統警示不相容的訊息)
`##Title:`      |程式名稱
`##Notes:`      |程式說明
`##Author:`     |作者資訊
`##Version:`    |程式自訂的版號
`##Date:`       |最後修改日期
~~`##LatestRef:`~~  |最新版的位置 (格式為: `#AID Board 站名或任意字串/註解`)
　|　暫未支援。

請注意 BBSRuby 的輔助函式要以 `BBS.` 而不是 `bbs.` 來存取，TOC存取方式也不同。

Store API 暫未實作，但未來支援時，其函式也要以 `STORE.` 而不是 `store.` 來存取。

輸出 ||
 ------------------------ | ---------------------------
~~`bbs.addstr(str, ...)`~~    |畫字到目前位置
　|　目前請使用`outs`。視情況考慮是否 alias `outs` 過來。
`bbs.outs(str, ...)`      |畫字到目前位置 (同 `addstr`)
`bbs.title(str)`          |移至左上角繪製標題
`bbs.print(str, ...)`     |印完所印字串後再加上一個換行
~~`print(str, ...)`~~         |同 `bbs.print`
　|　暫未 alias 為 `bbs.print`。請使用`bbs.outs` / `bbs.print`。
　|* 全系列畫字函式都可以接受 ANSI 指令
　|* 注意: 輸出並不會立刻反應在畫面上，要等 `refresh()` <br> 或其它輸入函式才會作全螢幕的更新。請見 `refresh()` 說明
　|* 若已有鍵盤輸入則在輸入處理完前可能不會更新螢幕顯示
**`bbs.vmsg(str)`**           |顯示訊息提示框
　|　(`str` 暫不可省略) <br> (BBS-Lua 0.102 後與 `bbs.pause(msg)` 合併)

移動 ||
 ------------------------ | -------------------------------------------------------
_`bbs.getyx()`_             |傳回游標目前位置 `(y, x)`， `y`/`x` 由 `(0,0)`表左上角
　|　(會以 `{"y"=>y, "x"=>x}` 的形式傳回)
_`bbs.getmaxyx()`_          |傳回目前螢幕大小 `(my,mx)`, 實際可移動範圍到 `(my-1,mx-1)`
　|　(會以 `{"y"=>y, "x"=>x}` 的形式傳回)
`bbs.move(y,x)`           |移動到 `(y,x)` (也就是 ANSI 的 `*[x;yH`)
`bbs.moverel(dy,dx)`      |移動到游標目前位置加上 `(dy,dx)`

清除 ||
 ------------------------ | ---------------------
`bbs.clear()`             |清除整個畫面+回到左上角
`bbs.clrtoeol()`          |清至行尾
`bbs.clrtobot()`          |清至螢幕底端

2D繪圖 ||
 -------------------------- | -------------------------------------------------------------------------
~~`bbs.rect(r,c,title)`~~       |以目前游標位置為起點，用目前色彩屬性繪製一個高度 `r` (rows) 寬度 `c` (cols) 的視窗。
　|　若有指定 `title` (可省略) 則會置中輸出字串
　|　暫未支援。

更新畫面 ||
 ----------------------- | ----------------------------------------------------------
`bbs.refresh()`          |呼叫此命令時才會真的更新畫面
　|　(呼叫輸入等待指令如 `getch`/`getstr`/`pause`/`kbhit`/`sleep`時也會自動更新)

顏色、屬性與 ANSI 控制碼 ||
 ------------------------ | -------------------------------------
`bbs.color(c1,c2,...)`    |直接切換 ANSI 屬性 (也就是 `*[c1;c2;....m`，不用再 `bbs.outs()`)
　|　不指定參數時 `bbs.color() = bbs.outs("*[m")` (重設屬性)
~~`bbs.setattr(c1,c2,...)`~~  |同 `color()`
　|　請使用`color`，未來視情況決定是否支援。
　|　(在 BBS-Lua 中，此函式實際名稱為 `bbs.attrset`)
`bbs.ansi_color(c1,...)`  |傳回 ANSI 屬性字串 (不馬上變屬性，要配合 `outs` 才會變)
`bbs.ANSI_RESET`          |傳回 `"*[m"` 字串
`bbs.ESC`                 |傳回 ANSI 的 Escape (`*`: ASCII 27, `0x1b`)
~~`bbs.strip_ansi(s)`~~       |傳回無 ANSI 碼的 `s` 字串
　|　暫未支援。

輸入 ||
 ------------------------ | ---------------------------------------------------
_`bbs.getch()`_             |輸入單鍵 (會等到有輸入為止)
　|　特殊按鍵為大寫名: `UP` `DOWN` `LEFT` `RIGHT` <br> `ENTER` `BS` `TAB`   `HOME` `END` `INS` `DEL` `PGUP` `PGDN` `F1` ... `F12` <br> 另外與 Ctrl 合按的複合鍵會以 `^X` 的形式出現。
　|　注意: 某些連線程式常會為「偵測全形字」多送按鍵 <br> 會導致收方向鍵時重複 2 次按鍵 <br> 要避免這個問題的解決方法是呼叫 `getch()` 前確認游標位置不在雙位元字的第一個 Byte 上面 (Leading Byte)。 <br> 另外若游標位置為非雙位元字，前面那個字也不能是雙位元。 <br> 記得更新前把游標擺在連續的非雙位元字或是雙位元字的第二個 byte 上面。 <br> 另外的方法就是關閉連線軟體端的偵測，改回讓伺服器端偵測才是王道
　|  (`BS` 改為 `BKSP`；`F1` ... `F12` 暫未支援)
_`bbs.getdata(n,echo,str)`_ |畫 `n` 個字元的輸入框並輸入字串
　|　`echo` (可省略) = 0 時只輸入不畫字 (可作密碼輸入)
　|　`str` (可省略) 為預設已輸入字串
　|　(暫未支援 `str`)
~~`bbs.getstr(n,echo,str)`~~  |同 `getdata`
　|　請使用 `bbs.getdata`。
_`bbs.pause(msg)`_          |在底部畫暫停訊息並等輸入單鍵 (傳回值同 `getch()`)
　|　(`msg` 暫不可省略)

輸入緩衝區控制 ||
 ------------------------ | ---------------------------------------------------
　|　注意所有緩衝區控制指令等待時間都可能會有最小值 <br> 此最小值會因站台設定而不同
_`bbs.kbhit(wait)`_         |傳回使用者是否有按鍵 (若無輸入則會等待最多 `wait` 秒)
　|　`wait` 可省略
　|　(`wait` 暫不可省略)
~~`bbs.kbreset()`~~           |清空輸入緩衝區 (吃掉所有已輸入的鍵)
　|　暫未支援。
~~`bbs.kball(sec)`~~          |等待 `sec`(可省略) 秒，並傳回所有已輸入的鍵
　|　(可用 `{bbs.kball()}` 轉換成表格以供處理)
　|　適合 framerate 固定，又會同時輸入多個鍵的程式使用
　|　範例: <br> `a = {bbs.kball(0.5)}; -- 處理所有鍵` <br> `for i=1,#a do ... a[i] ... end` <br> `b = bbs.kball(0.5);   -- 只處理第一個鍵` <br> `if bbs.kball(0.5) then ... end -- 只判斷有無按鍵`
　|　暫未支援。

時間 ||
 ------------------------ | ----------------------------------------------
~~`bbs.time()`~~              |現在時間 (以數字表示)，精準度到秒 (呼叫處理速度較快)
~~`bbs.now()`~~               |同 `time()`
　|　在 CRuby 下，請使用內建的 `Time.now`
　|　在 mruby 下暫未支援
~~`bbs.ctime()`~~             |現在時間 (以字串表示)
　|　在 CRuby 下，請使用內建的 `Time.now.to_s`
　|　在 mruby 下暫未支援
`bbs.clock()`             |高精準度的時間 (可到秒的小數點以下但呼叫處理速度較慢)
~~`bbs.sleep(sec)`~~          |停止執行 `sec` 秒 (可到小數點以下)
　|　在 CRuby 下，請使用內建的 `sleep`
　|　在 mruby 下暫未支援

BBS 資訊 ||
 ------------------------ | ------------------
`bbs.userid`              |目前使用者的 id (0.119 後改為變數而非函式)
　|　(Ruby 語法中，函式呼叫的 `()` 可省略；BBS-Ruby 內部實作仍為函式)
~~`bbs.usernick`~~            |目前使用者的暱稱 (0.119+)
　|　暫未支援。
`bbs.sitename`            |BBS 站名
`bbs.interface`           |BBSRuby API 版本號碼

程式 TOC 資訊 ||
 ------------------------------- | ----------------------
　|　(以下字串亦可用全小寫) <br> (注意語法與 BBS-Lua 有異)
~~`bbs.toc["Interface"]`~~           |TOC 中的 `Interface:` 資訊
　|　暫未支援。
**`bbs.toc["Title"]`**               |TOC 中的 `Title:` 資訊
**`bbs.toc["Notes"]`**               |TOC 中的 `Notes:` 資訊
**`bbs.toc["Author"]`**              |TOC 中的 `Author:` 資訊
**`bbs.toc["Version"]`**             |TOC 中的 `Version:` 資訊
**`bbs.toc["Date"]`**                |TOC 中的 `Date:` 資訊
~~`bbs.toc["LatestRef"]`~~           |TOC 中的 `LatestRef:` 資訊
　|　暫未支援。

位元操作 ||
 ---------------- | ----------------------
~~`bit.cast(a)`~~       |cast a to the internally-used integer type
　|　請改寫為 `Integer(a)`
~~`bit.bnot(a)`~~       |returns the one's complement of a
　|　請使用內建的 `~` 運算子
~~`bit.band(w1, ...)`~~ |returns the bitwise and of the w's
　|　請使用內建的 `&` 運算子
~~`bit.bor(w1, ...)`~~  |returns the bitwise or of the w's
　|　請使用內建的 `\|` 運算子
~~`bit.bxor(w1, ...)`~~ |returns the bitwise exclusive or of the w's
　|　請使用內建的 `^` 運算子
~~`bit.lshift(a, b)`~~  |returns a shifted left b places
　|　請使用內建的 `<<` 運算子
~~`bit.rshift(a, b)`~~  |returns a shifted logically right b places
　|　請改寫為 `a >= 0 ? a >> b : (2 ** 32 + a) >> b`
~~`bit.arshift(a, b)`~~ |returns a shifted arithmetically right b places
　|　請使用內建的 `>>` 運算子

資料儲存與讀取 (暫未實作) ||
 -------------- | ----------------------
~~`store.load(c)`~~   |回傳分類 `c` 內已儲存的資料 (若失敗或無資料則回傳 `nil`)
~~`store.save(c,s)`~~ |儲存 `s` 的內容到分類 `c` (超過 limit 的部份不會存入，傳回值為 `true`/`false` 代表是否有成功存入。)
~~`store.limit(c)`~~  |回傳分類 `c` 的大小限制
~~`store.iolimit()`~~ |回傳資料存取 API (`load`/`save`) 的呼叫次數限制
~~`store.USER`~~      |分類: 使用者目錄
~~`store.GLOBAL`~~    |分類: 全站共享
