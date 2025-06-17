Claude Code Config

# わかる方向け

使いたいものをどうぞご自由に。相談していただければ仕様を調整します。

# わからない方向け

1. bin/setupを実行して下さい. homeからetc以下のファイルにsymlinkを貼ります

2. ~/.gitignoreに以下を追記して下さい

```
[core]
  excludesfile = ~/.gitignore_global
```

3. ~/.zshrcに以下を追記して下さい

```
path=(~/some/directory/claude-code-config/bin $path)
source ~/.zshrc.claude
```

4. swiftbarの設定
  1. brewでswiftbar入れる
  2. プラグインディレクトリみたいなの聞かれるので、bin/swiftbar を指定する
