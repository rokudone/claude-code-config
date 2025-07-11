# git now コマンド

あなたがここまでにした変更をコミットしなさい
コミットメッセージは、"[from now]"を頭につけなさい。
例: `[from now] hogehoge機能作成`

## 参考

通常のgit_nowコマンドが以下です

```
function git_now() {
    if [ $# -eq 0 ]; then
        git commit -m "[from now] $(date '+%Y-%m-%d %H:%M:%S')"
    else
        git commit -m "[from now] $*"
    fi
}
```


