# ツール活用ガイド（Serenaもあるのだ）

このドキュメントは「ツールを積極的に使う」ための指示をまとめたものなのだ。Serena MCPサーバは強力な選択肢のひとつで、探索・解析・安全な小編集に向くのだ。他にも計画や差分適用のためのツールを組み合わせて、小さく速く安全に進めるのだ。

---

## 1. 原則（ツールファースト）なのだ

- 直接編集より「ツールで操作」を優先するのだ。
  - 探索・解析はSerenaの検索/シンボル系を使うのだ。
  - 編集はSerenaの`insert_*`/`replace_symbol_body`か、複数ファイルにまたがる場合は`apply_patch`を使うのだ。
- 進め方は必ずStage Gateで合意を取りつつ進行するのだ。

---

## 2. 何を使うかの判断フローなのだ

1) どこに何があるか知りたいのだ → Serenaの探索系
- `serena__list_dir` で俯瞰
- `serena__find_file` で候補抽出
- `serena__search_for_pattern` でキーワード検索（対象を必ず絞るのだ）

2) ファイルの構造や影響範囲を知りたいのだ → Serenaのシンボル系
- `serena__get_symbols_overview` で構造把握
- `serena__find_symbol` で定義特定（必要なら `depth>0`）
- `serena__find_referencing_symbols` で参照元を洗い出すのだ

3) ごく小さく安全に編集したいのだ → Serenaの編集系
- 追記なら `serena__insert_before_symbol` / `serena__insert_after_symbol`
- 置換なら `serena__replace_symbol_body`（必ず影響を見てからなのだ）

4) 複数ファイルを一括で直したいのだ → `apply_patch`
- 変更が広いときはパッチでまとめて差分化するのだ。
- ただし一度に詰め込みすぎず、小さく分割するのだ。

5) 進行の見える化・合意形成をしたいのだ → `update_plan`
- ステップを短く列挙し、完了/着手中を更新して共有するのだ。

---

## 3. クイックスタート（実行しないチェックリスト）なのだ

このセクションは実行手順ではなく「提案テンプレート」と「チェックリスト」なのだ。自動実行は禁止で、必ずStage Gateで承認を得てから進めるのだ。

- Step 1: プロジェクトの有効化を提案するのだ
  - 提案例: 「Stage Gate: `activate_project` を実行して良いのだ？ 対象は <作業ディレクトリ> なのだ」
- Step 2: 状態取得を提案するのだ
  - 提案例: 「`get_current_config` でツールとモードを確認して良いのだ？」
- Step 3: ルート一覧の取得を提案するのだ
  - 提案例: 「`list_dir` で `.` を浅く見るのを許可してほしいのだ」

承認を得られたステップのみ、各ツールを実行するのだ。承認がなければ次に進まないのだ。

---

## 4. Serenaツール要点なのだ

- プロジェクト/状態
  - `activate_project`, `get_current_config`
- 探索/検索
  - `list_dir`, `find_file`, `search_for_pattern`
- シンボル解析
  - `get_symbols_overview`, `find_symbol`, `find_referencing_symbols`
- 編集
  - `insert_before_symbol`, `insert_after_symbol`, `replace_symbol_body`
- メモリ/オンボーディング
  - `check_onboarding_performed`, `onboarding`, `write_memory`, `read_memory`, `list_memories`, `delete_memory`
- 思考補助
  - `think_about_task_adherence`, `think_about_collected_information`, `think_about_whether_you_are_done`

コツなのだ：`search_for_pattern` は範囲を強く絞るのだ（`paths_include_glob`/`relative_path`）。編集はまず追記系で段階移行し、最後に置換に踏み込むのだ。

---

## 5. Serena以外の主要ツールの押さえどころなのだ

- 計画共有: `update_plan`
  - ステップは短く、1つだけ `in_progress` にするのだ。

- 差分適用: `apply_patch`
  - ファイルの追加/更新/削除を安全に差分として適用するのだ。
  - 変更は最小単位で、関連外の修正は混ぜないのだ。

（注）Web検索などネット依存のツールは環境により制約があるのだ。使えるかは状況に応じて確認するのだ。

---

## 6. ワークフロー（Stage Gate）なのだ

1) Plan: `update_plan` で合意を取るのだ。
2) Explore: Serenaの探索/シンボル系で事実を集めるのだ。
3) Check: `think_about_collected_information` で不足を洗うのだ。
4) Edit: Serenaの編集系 or `apply_patch` で最小差分を入れるのだ。
5) Review: `think_about_task_adherence` → `think_about_whether_you_are_done` でズレ/完了確認なのだ。

---

## 7. チートシート（すぐ使う断片）なのだ

以下は実行例なのだ。使う前にStage Gateで承認を得るのだ。

```
# 状態を見るのだ
serena__get_current_config()

# ルートの様子を確認するのだ
serena__list_dir(relative_path=".", recursive=False)

# etc配下だけでTODOを探すのだ
serena__search_for_pattern(
  substring_pattern="TODO:",
  relative_path="./etc",
  paths_include_glob="**/*.md",
  max_answer_chars=8000,
)

# メソッド定義→参照→安全な追記なのだ
serena__find_symbol(name_path="/ClassName/method_name", relative_path="./app", depth=1)
serena__find_referencing_symbols(name_path="/ClassName/method_name", relative_path="./app")
serena__insert_after_symbol(
  name_path="/ClassName/method_name",
  relative_path="app/models/class_name.rb",
  body="""
    # 追記: ログ出力なのだ
    logger.info("something happened")
  """,
)

# 複数ファイル変更はパッチでやるのだ
*** Begin Patch
*** Update File: path/to/file.rb
@@
- old
+ new
*** End Patch
```

---

## 8. 最後になのだ

- 小さく進めて、常にツールで事実を取りにいくのだ。
- Serenaは探索と小編集の主力なのだ。他ツールと併用して最短距離で進むのだ。

