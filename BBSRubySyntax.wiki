#labels Featured
   BBSRuby 版本 v0.2, API Interface: v0.111

     Source Code下載：http://orez.us/~zero/BBSRuby.c

  === 為什麼開發 BBSRuby? ===

   因為人家有 BBSLua （誤），其實只是想學學看怎麼把 Ruby interpreter 嵌入
   程式中。剛好人家有這麼棒的點子就拿來用囉XD 以前也曾想要寫 C# 的 BBS
   有一項功能就是用 C# 的 Runtime Compiler Service 弄 C# Script。

   不過... 該計畫... 被放棄了（小聲） 所以算是實現當時的願望吧 (?) XD

  === 已知問題 ===

    1. Hash.to_s() 不明原因出現 parameter error. @@

    2. Ruby interpreter 有時候啟動時會顯示 parse 錯誤，可是重新再進入一次
       卻又可以正常執行。

  === 修改記錄 ===

    v0.2
      1. 修正行號不會重新計算的問題，只要故意load一個空白檔案就可以了。 :P

    v0.3
      1. 修正getch()對於特殊按鍵沒反應的問題

  === 如何撰寫 ===

   BBSRuby大致上與BBSLua相容，不過依然有一些變動。
   如程式開頭結束皆使用###BBSRuby。 至於API的部份，BBSRuby將參考
   BBSLua API實做。以下將以BBSLua的API列表搭配說明/顏色指示支援狀態。
   原文作者為 piaip。

   支援狀況： 不支援 部份實做 完全支援 BBSRuby專屬

   TOC標籤：
      ##Interface:  BBS-Ruby API 版本號碼 (可方便系統警示不相容的訊息)
      ##Title:      程式名稱
      ##Notes:      程式說明
      ##Author:     作者資訊
      ##Version:    程式自訂的版號
      ##Date:       最後修改日期

   請注意 BBSRuby 的輔助函式以 "BBS." 不是 "bbs."，TOC存取方式也不同。

   [輸出]
      bbs.addstr(str, ...)    畫字到目前位置
        目前請使用outs。視情況考慮是否 alias outs 過來。

      bbs.outs(str, ...)      畫字到目前位置 (同 addstr)
      bbs.title(str)          移至左上角繪製標題
      bbs.print(str, ...)     印完所印字串後再加上一個換行
      print(str, ...)         同 bbs.print
        不支援STDOUT輸出。請使用bbs.outs / bbs.print。

                      * 全系列畫字函式都可以接受 ANSI 指令
                      * 注意: 輸出並不會立刻反應在畫面上，要等 refresh()
                      或其它輸入函式才會作全螢幕的更新。請見 refresh() 說明

      bbs.vmsg(str)           顯示訊息提示框

   [移動]
      bbs.getyx()             傳回游標目前位置 (y, x)， y/x 由 (0,0)表左上角
      bbs.getmaxyx()          傳回目前螢幕大小 (my,mx), 實際可移動範圍到
                              (my-1,mx-1)
      bbs.move(y,x)           移動到 (y,x) (也就是 ANSI 的 *[x;yH)
      bbs.moverel(dy,dx)      移動到游標目前位置加上 (dy,dx)

   [清除]
      bbs.clear()             清除整個畫面+回到左上角
      bbs.clrtoeol()          清至行尾
      bbs.clrtobot()          清至螢幕底端

   [2D繪圖]
      bbs.box(rows,cols,title)  以目前游標位置為起點，用目前色彩屬性繪製一個
                                 高度 rows 寬度 cols 的視窗。
                                 若有指定 title (可省略) 則會置中輸出字串

   [更新畫面]
       bbs.refresh()          呼叫此命令時才會真的更新畫面
                              (呼叫輸入等待指令如 getch/getstr/pause/
                               kbhit/sleep/vmsg時也會自動更新)

   [屬性]
       bbs.color(c1,c2,...)    切換 ANSI 屬性 (也就是 *[c1;c2;....m)
                               不指定參數時 bbs.color() = *[m (重設屬性)
       bbs.setattr(c1,c2,...)  同 color()
         請使用color，未來視情況決定是否支援。

       bbs.ANSI_COLOR(c1,...)  傳回 ANSI 屬性字串 (不馬上變屬性，要 outs 才會變)
       bbs.ANSI_RESET          傳回 *[m 字串
       bbs.ESC                 傳回 ANSI 的 *

   [輸入]
       bbs.getch()             輸入單鍵
                        特殊按鍵為大寫名: UP DOWN LEFT RIGHT
                        ENTER BS TAB   HOME END INS DEL PGUP PGDN F1 ... F12
                        另外與 Ctrl 合按的複合鍵會以 ^X 的形式出現。

       bbs.getdata(n,echo)     畫 n 個字元的輸入框並輸入字串
                        echo (可省略) = 0 時只輸入不畫字 (可作密碼輸入)
       bbs.getstr(n,echo)      同 getdata
          請使用 bbs.getdata。

       bbs.pause(msg)          在底部畫暫停訊息並等輸入單鍵 (傳回值同 getch())

       bbs.kbhit(wait)         傳回使用者是否有按鍵 (若無輸入則會等待最多 wait\0
 秒)
       bbs.kbreset()           清空輸入緩衝區 (吃掉所有已輸入的鍵)
          因為BBS I/O核心的關係暫時不支援。

   [時間]
       bbs.time()              現在時間 (以數字表示)，精準度到秒 (處理速度較快)
       bbs.now()               同 time()
         請使用 Ruby 內建的 Time.now

       bbs.ctime()             現在時間 (以字串表示)
         請使用 Ruby 內建的 Time.now.to_s

       bbs.clock()             高精準度的時間 (可到秒的小數點以下但速度較慢)
       bbs.sleep(sec)          停止執行 sec 秒 (可到小數點以下)
         請使用 Ruby 內建的 sleep。

   [BBS 資訊]
       bbs.userid()            目前使用者的 id
       bbs.sitename            BBS 站名
       bbs.interface           BBSRuby API 版本號碼

   [程式 TOC 資訊]
        bbs.toc["Title"]               TOC 中的 Title: 資訊
        bbs.toc["Notes"]               TOC 中的 Notes: 資訊
        bbs.toc["Author"]              TOC 中的 Author: 資訊
        bbs.toc["Version"]             TOC 中的 Version: 資訊
        bbs.toc["Date"]                TOC 中的 Date: 資訊