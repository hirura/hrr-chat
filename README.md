#Hrr-Chat App.


##Description:

Ruby単体（標準のライブラリ）で動くチャットアプリケーション．  
クライアントには，端末，WEBブラウザが利用可能．


##Usage:

1. server/logger.rb を起動する．
2. server/httpd.rb or server/httpd_integrate-cgi.rb を起動する．
3. 端末からは，client/terminal/sender.rb を実行してメッセージを書き込み，  
   client/terminal/viewer*.rb を実行することで書き込まれたログを逐次読み込むことが出来る．  
   WEBブラウザからは，http://localhost:10080/client/web/*sync*.html のようにアクセスして  
   書き込み，読み込みが出来る．


##Files:

    .
    ├── README.md
    ├── client
    │   ├── pseudo-web
    │   │   ├── async.rb
    │   │   ├── async_cgi-wait-logger.rb
    │   │   ├── async_js-wait-cgi.rb
    │   │   ├── sender.rb
    │   │   └── sender_auto.rb
    │   ├── terminal
    │   │   ├── sender.rb
    │   │   ├── sender_auto.rb
    │   │   ├── viewer.rb
    │   │   └── viewer_long-polling.rb
    │   └── web
    │       ├── async.html
    │       ├── async_cgi-wait-logger.html
    │       ├── async_js-wait-cgi.html
    │       ├── sync.html
    │       └── sync_get.html
    └── server
        ├── cgi-bin
        │   ├── sender.rb
        │   ├── viewer.rb
        │   ├── viewer_cgi-wait-logger.rb
        │   └── viewer_js-wait-cgi.rb
        ├── httpd.rb
        ├── httpd_integrate-cgi.rb
        └── logger.rb

###server/logger.rb
書き込みのログを保存するチャットサーバー．  
書き込みは12347番ポートへsocket接続により可能，受け付ける形式は "NAME|LINE" で，[TIME, NAME, LINE] として保存する．  
読み込みは12346番ポートへsocket接続し，クライアントが現在持っているログの行数（初期値：-1）を受け取り，それ以降のログを返す．  
12348番ポートも同様に読み込みを受け付けるが，socket接続への返答を，ログが追加されるまで，もしくは10秒間待つ．  
httpd_integrate-cgi.rbへのログ出力において，ログが巨大だとタイムアウトするレベルで処理に時間がかかるため，さかのぼれる行数を1000に制限（2013/09/10時点）．
	
###server/httpd.rb
webクライアントからの書き込み，読み込み接続を受け付けるHPPPサーバー．
10080番ポートで待ち受ける．  
/cgi-bin/への要求を，./cgi-bin/への要求とみなし，./cgi-bin/以下のRubyスクリプトをCGIとして起動する．  

###server/httpd_integrate-cgi.rb
httpd.rbと同様，webクライアントからの書き込み，読み込み接続を受け付けるHPPPサーバー．
/cgi-bin/への要求を，Rubyスクリプトを起動するのではなく，内部の関数（スレッド？）で実行する．
GETメソッドによる要求へのレスポンスは未実装（2013/09/10時点）．
10080番ポートで待ち受ける．

###server/cgi-bin/
HTTPサーバーとlogger.rbとの間の処理を実行するスクリプト群．  
デフォルトは，localhostで起動しているlogger.rbへ接続する．

###server/cgi-bin/sender.rb
name, lineを受け取り，logger.rbへ書き込みを行うクライアント．

###server/cgi-bin/viewer.rb
numを受け取り，logger.rbの12346番ポートに接続し，ログを読み込む．

###server/cgi-bin/viewer_js-wait-cgi.rb
numを受け取り，logger.rbの12346番ポートに接続し，ログを読み込む．  
webブラウザへの返答を，スクリプト内でループすることにより，ログが追加されるまで，もしくは10秒間待つ．  
logger.rbへ0.1秒毎にsocket接続して新規ログを問い合わせる．

###server/cgi-bin/viewer_cgi-wait-logger.rb
numを受け取り，logger.rbの12348番ポートに接続し，ログを読み込む．

###client/terminal/
logger.rbが受け付けるsocketに直接書き込み，読み込みを行うクライアント群．

###client/terminal/sender.rb
    sender.rb [-p, --port=PORT] [-n, --name=NAME] [HOSTNAME]
logger.rbへ書き込みを行うクライアント．  
起動後，インタラクティブに書き込みを行う．  
デフォルトは，port=12347，name=名無し，hostname=localhost．

###client/terminal/sender_auto.rb
    sender_auto.rb [-p, --port=PORT] [-n, --name=NAME] [-m, --max=MAX] [-i, --interval=INTERVAL] [HOSTNAME]
logger.rbへ，INTERVAL秒間隔でMAX回，'x'*(rand(40)+1)を書き込むクライアント．  
デフォルトは，port=12347，name=名無し，hostname=localhost，max=1，interval=0.5．

###client/terminal/viewer.rb
    viewer.rb [-p, --port=PORT] [HOSTNAME]
logger.rbから読み込みを行うクライアント．  
0.1秒毎にlogger.rbへ問い合わせる．  
デフォルトは，port=12346，hostname=localhost．

###client/terminal/viewer_long-polling.rb
    viewer_long-polling.rb [-p, --port=PORT] [HOSTNAME]
logger.rbから読み込みを行うクライアント．  
デフォルトは，port=12348，hostname=localhost．  
新規ログを待ち（12348番ポートのlogger.rbの機能），ログの取得後すぐに再問い合わせを行う．

###web/
webブラウザからHTTPサーバーに接続するクライアント群．  
terminal/のsender*.rbとviewer*.rbが統合されている．  
javascriptとXMLHttpRequestにより，Ajax的な操作を実現している．

###web/sync.html
HTTPサーバー（/cgi-bin/viewer.rb）へ，0.1秒毎にXMLHttpRequestの同期モードでログを問い合わせるクライアント．  
書き込み，読み込み共にPOSTメソッドを用いる．

###web/sync_get.html
sync.htmlと同様，HTTPサーバー（/cgi-bin/viewer.rb）へ，0.1秒毎にXMLHttpRequestの同期モードでログを問い合わせるクライアント．  
書き込みにはPOSTメソッド，読み込みにはGETメソッドを用いる．

###web/async.html
HTTPサーバー（/cgi-bin/viewer.rb）へ，0.1秒毎にXMLHttpRequestの非同期モードでログを問い合わせるクライアント．  
書き込み，読み込み共にPOSTメソッドを用いる．

###web/async_js-wait-cgi.html
/cgi-bin/viewer_js-wait-cgi.rbに新規ログを問い合わせ，ログの取得後すぐに再問い合わせを行う．  
書き込み，読み込み共にPOSTメソッドを用いる．

###web/async_cgi-wait-logger.html
/cgi-bin/viewer_cgi-wait-logger.rbに新規ログを問い合わせ，ログの取得後すぐに再問い合わせを行う．  
書き込み，読み込み共にPOSTメソッドを用いる．

###pseudo-web/
TerminalからHTTPサーバーに接続するクライアント群．

###pseudo-web/sender.rb
    sender.rb [-p, --port=PORT] [-n, --name=NAME] [HOSTNAME]
書き込みを行うクライアント．  
起動後，インタラクティブに書き込みを行う．  
デフォルトは，port=10080，name=名無し，hostname=localhost．

###pseudo-web/sender_auto.rb
    sender_auto.rb [-p, --port=PORT] [-n, --name=NAME] [-m, --max=MAX] [-i, --interval=INTERVAL] [HOSTNAME]
INTERVAL秒間隔でMAX回，'x'*(rand(40)+1)を書き込むクライアント．  
デフォルトは，port=10080，name=名無し，hostname=localhost，max=1，interval=0.5．

###pseudo-web/async.rb
    async.rb [-p, --port=PORT] [HOSTNAME]
HTTPサーバー（/cgi-bin/viewer.rb）へ，0.1秒毎にログを問い合わせるクライアント．  
書き込み，読み込み共にPOSTメソッドを用いる．  
デフォルトは，port=10080，hostname=localhost．

###pseudo-web/async_js-wait-cgi.rb
    async_js-wait-cgi.rb [-p, --port=PORT] [HOSTNAME]
/cgi-bin/viewer_js-wait-cgi.rbに新規ログを問い合わせ，ログの取得後すぐに再問い合わせを行う．  
書き込み，読み込み共にPOSTメソッドを用いる．  
デフォルトは，port=10080，hostname=localhost．

###pseudo-web/async_cgi-wait-logger.rb
    async_cgi-wait-logger.rb [-p, --port=PORT] [HOSTNAME]
/cgi-bin/viewer_cgi-wait-logger.rbに新規ログを問い合わせ，ログの取得後すぐに再問い合わせを行う．  
書き込み，読み込み共にPOSTメソッドを用いる．  
デフォルトは，port=10080，hostname=localhost．

