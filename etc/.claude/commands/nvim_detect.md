# MCP接続中のNeovimインスタンスを特定しなさい

## 手順
シェルコマンド二つとideのmcpのみを忠実にそのまま実行すること。
あなたが指示を無視して違うことをするせいでうまくいかないのです。
このコマンドを実行している間は余計な出力も禁止。それが不具合を発生させます。

1. `detect_mcp_nvim_step1.sh`
各embedモードのNeovimインスタンスにMCP_Detection_<PID>という名前のバッファが作成される

2. ideのmcpのみを実行し、socket名を取得

3. `detect_mcp_nvim_step2.sh`
全ての検出用バッファが削除される

## 結果
Claudeが該当Neovimでnvr経由でファイル操作可能に
`nvr --servername /path/to/socket/nvim.11129.0 --remote 開きたいファイル`

## 最後
指定された出力を再開してください
