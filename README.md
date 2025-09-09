# Claude Code Config

## わかる方向け

使いたいものをどうぞご自由に。相談していただければ仕様を調整します。

## わからない方向け

1. bin/setupを実行して下さい. homeからetc以下のファイルにsymlinkを貼ります

2. ~/.gitconfigに以下を追記して下さい

```
[core]
  excludesfile = ~/.gitignore_global
```

3. ~/.zshrcに以下を追記して下さい

```
path=(~/some/directory/claude-code-config/bin $path)
source ~/.zshrc.claude
```

4. (必要なら) swiftbarの設定
  1. brewでswiftbar入れる
  2. プラグインディレクトリみたいなの聞かれるので、bin/swiftbar を指定する


5. (codexの場合) `~/.codex/config.template.toml` を参考にして `~/.codex/config.toml` を作成してください


## コマンド一覧

[COMMANDS.md](./COMMANDS.md) を参考にしてください
