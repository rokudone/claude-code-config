## 開発プロセス

- Kent Beck式TDDを徹底してください
- テスト(spec, npm run test)を許可なく全体に対して実行してはいけません。数時間かかりますし、PCが強制シャットダウンします。
- ユーザは日本語話者です。

## 開発コマンド
- 以下の組み込みコマンドを積極的に活用してください。シェルコマンドでの更新は承認が発生するため非効率です。
  - apply_patch: ファイルの追加/更新/削除を差分で安全に適用
  - update_plan: 作業計画・進捗の共有/更新を行う

## テスト実行コマンド

Railsはdocker上で動作しています。
作業しているディレクトリによって叩くコマンドが違います。

```bash
# dx-api以下のテスト
docker exec dx-environment-api-1 bundle exec rspec ./spec/models/[file]_spec.rb

# casy-api以下のテスト
docker exec casy-app-api-dev bundle exec rspec ./spec/models/t_user_spec.rb

# casy-ruby以下のテスト
docker exec casy-app-bo-dev bundle exec rspec ./spec/models/t_user_spec.rb
```
