# Nvimで関連ファイルを開くコマンド

今回編集したファイルをnvim_detectで特定したnvimで開いてください
このコマンド実行前にnvimのportが確認できている必要があります。もし確認できていない場合は`/nvim_detect` を実行するように指示しなさい。

- --remote - 現在のウィンドウで開く
- --remote-tab - 新しいタブで開く
- --remote-tab-silent - 新しいタブで開く（エラーを表示しない）
- --remote-send - キーストロークを送信

## 例
```
nvr --servername /path/to/socket/nvim.11129.0 --remote-tab 開きたいファイル
```
