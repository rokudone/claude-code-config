# 🟢🟡🔴Stage-Gate Process🟢🟡🔴

## タスク

追って指示をだします。その指示に対して、以下の手順で作業を進めなさい。

## 概要と全体原則

Stage-Gate Process は、検証主義（憶測ではなく検証する）に基づく段階的な開発手法です。
各Stageで成果物を作成し、Gateでレビューを受けること
apply_patchコマンドが使用可能な場合はそれを利用すること

## 標準Gateプロセス

各Gateでは以下を実施：
1. あなたがユーザーに対して成果物を提示
2. ユーザーが確認し、問題があればフィードバック
3. 問題がないと答えるまで修正を繰り返す

## Stage-Gate フロー

### Verification Overlay（検証オーバーレイ）

Stage 1〜5 の各段階に検証活動を重ねるため、以下の四拍子（スナップ／絞る／証拠／更新）を常に意識すること。

1. **スナップ**: Stage 1で要件定義済みの内容から検証観点のみを抽出し、「Verification Snapshot」として固定化する  
2. **絞る**: Stage 2で設計情報を元にリスクを絞り込み、検証集中箇所を決定する  
3. **証拠**: Stage 3〜4でタスク単位の証跡（Evidence Bundle）を整備する  
4. **更新**: Stage 5で学びを検証ノートへ還元し、次サイクルに接続する

### Stage 0: 準備

- ユーザーに実行したいタスクの概要をヒアリングする。
- `git rev-parse --show-toplevel` でプロジェクトルートを確認する。
- 作業用ディレクトリを作成する。
  1. `date +"%Y-%m-%d_%H-%M-%S"` で時刻文字列を取得する。
  2. 取得した文字列を用いて `mkdir -p /path/to/.agent/specs/<timestamp>-feature-name/` を実行する。
- `mkdir -p` は必ず単独コマンドで実行する。パイプで繋ぐと確認が挟まるため禁止。
- 動的な値は必ず事前に取得してから使用する。

### Gate 0
- Stage 0 の成果（ヒアリング内容とディレクトリ作成状況）を報告し、Stage 1 へ進む承認を得る。

### Stage 1: spec.md 作成

- Joel Spolsky 式および EARS 表記法をベースに要件を整理する。
- Task ツールで必要な調査を並列に進める。
- ユーザーから得た情報をもとに `spec.md` を作成する。
- `spec.md` の末尾に `## Verification Snapshot` 節を設け、ユースケースごとに「前提 / トリガ / 期待する観測結果（レスポンス・ログ等）」を一行で要約した表を追加する。
  - 例:
    | ユースケース | 前提 | トリガ | 期待する観測 |
    | --- | --- | --- | --- |
    | UC-01 | 行政クーポン無効 | fee_estimation API | `errors[].code=invalid_district` |
- Verification Snapshot は検証に必要な断面のみを抜粋し、要件本体は再構成しない。

#### spec.mdの例
```markdown
# 要件定義書

## 概要
この機能は、プロジェクトテンプレートシステムを強化し、より良いテンプレート管理、テンプレート編集のUI改善、の修正を提供します。

## 要件

### 要件1
**ユーザーストーリー:** ユーザーとして、新しいプロジェクトテンプレートを準備・編集したい。

#### 受け入れ基準
1. テンプレート管理インターフェースにアクセスしたとき、システムは新しいテンプレートを作成するオプションを提供する
2. 新しいテンプレートを作成するとき、システムは初期タスク、プロジェクト構造、設定を定義できるようにする

## 参考ファイル

- 事前調査ファイル: /hoge/fuga/piyo.md
- 実装の参考にするファイル: /foo/bar/some.rb
- ...
```

### Gate 1
- 作成した `spec.md` を提示し、標準 Gate プロセスでレビューと承認を受ける。

### Stage 2: design.md 作成

- Joel Spolsky 式の観点で設計を整理し、Task ツールで必要な調査を並列に進める。
- Stage 1 の `spec.md` を基に `design.md` を作成する。
- `design.md` に `## Verification Focus` 節を設け、Verification Snapshot と設計内容を突き合わせてリスクの高い領域を列挙する。
  - リスク項目は「リスク種別 / 根拠となる設計記述 / 推奨テスト」の三列でまとめる。
  - AI に `design.md` を解析させ草案を生成させ、最終確認を自分で行う運用を推奨する。

#### design.mdの例
````markdown
# 設計書

## 概要
プロジェクトテンプレートシステムの強化により、テンプレート管理の改善を実現します。

## アーキテクチャ
```
UI Layer
├── ProjectTemplateManager.tsx (専用ポップアップ)
├── TemplateEditModal.tsx (新規作成)
└── TaskColumn.tsx (横スクロール対応)
```

## 主要コンポーネント
### 1. ProjectTemplateManager.tsx
```typescript
interface ProjectTemplateManagerProps {
  onApplyTemplate: (projectName: string, templateId: string) => void;
  isOpen: boolean;
  onClose: () => void;
}
````

### Gate 2: design.md承認ステージ
design.mdを作成していることを確認し、そのファイルのレビューを依頼する
標準Gateプロセスを実施（design.mdのレビュー）

### Stage 3: tasks.md 作成

- 実装計画を策定し、Task ツールを活用して前提調査を並列に進める。
- Stage 1・Stage 2 の成果を踏まえて `tasks.md` を作成する。
- 各タスクに対応する Evidence Bundle の準備タスクを追加し、`evidence/<feature>/<task-id>/` 配下に以下を整備する。
  - `summary.md`: 検証観点と結論を三行以内で記載する。
  - `tests/`: 実行した spec ファイルやテストケースの控えを配置する。
  - `logs/`: テスト実行ログ、レスポンス例、スクリーンショットなどを格納する。
  - `observations.json`: 失敗ケースや未解決事項を JSON 形式で記録する。
- Evidence Bundle の初稿作成は AI に依頼し、内容確認と承認は自分で行う。

#### tasks.mdの例
```markdown
# 実装計画

- [ ] 1. TemplateEditModal コンポーネントの作成
  - 専用のテンプレート編集ポップアップモーダルを実装
  - 新規作成モードと編集モードの両方をサポート
  - _要件: 2.1, 2.2, 3.1, 3.2_

- [ ] 2. ProjectTemplateManager の編集機能分離
  - 右パネルから編集フォームを削除
  - _要件: 2.1, 2.3_
```

### Gate 3
- 作成した `tasks.md` を提示し、標準 Gate プロセスでレビューと承認を受ける。

### Stage 4: 実装（Kent Beck 式 TDD）

- `spec.md`・`design.md`・`tasks.md` の内容に従い実装と検証を進める。
- Kent Beck 式 TDD（Red → Green → Refactor）のサイクルごとに、対応する Evidence Bundle に以下を追記する。
  - 実行したテスト結果ログ（成功・失敗の双方）。
  - 更新したテストコードの差分。
  - 追加で得られた観測メモ（AI が整形した草稿を確認する）。
- Evidence Bundle の `summary.md` とログ整形は AI に依頼し、内容確認と補足は自分で行う。

### Gate 4
- 実装結果と証跡（コード、Evidence Bundle）を提示し、承認または修正指示を受ける。必要に応じて前のステージに戻る。

### Stage 5: クリーンアップ

- 開発中に作成した一時ファイルを削除する。
- デバッグ用の `console.log` やコメントアウトされたコードを削除する。
- 不要な import を削除し、必要に応じてフォーマッター（prettier, eslint 等）を実行する。
- TODO コメントの対応状況を確認し、必要に応じて解消する。
- テスト用のモックデータやダミーファイルを整理する。
- `.agent/specs/` 配下の作業ファイルを確認し、アーカイブする。
- Evidence Bundle から不要なログや冗長ファイルを削除し、必要な成果のみを残す。

### Gate 5
- Stage 5 の成果と全体の要件充足状況を確認し、次サイクルへ引き継げる状態であることを最終承認する。

## 必須出力フォーマット

技術的な作業（実装、修正、調査など）の応答には🟢🟡🔴のいずれかの絵文字を含め必ず冒頭に以下を表示：

```
🟢 Stage-Gate状態 🟢
現在: Stage X - {ステージ名}
状態: {未着手|進行中|完了}
次: {具体的なアクション}
```

## 最後に

追って指示をだします。まだ作業をしないでください。
