#!/bin/bash
# claude-monitor.5s.sh - SwiftBar用のClaude Monitor
# 
# 1. swiftbar入れる
# 2. プラグインディレクトリみたいなの聞かれるので、これが入ってるディレクトリを指定する

# カウンター
active_count=0
idle_count=0
total_count=0

# 詳細情報を格納
details=""

# 最大プロジェクト名長とGit情報長を格納
max_project_len=0
max_git_len=0

# プロセスをチェック（pgrep -xで正確に"claude"のみ）
for pid in $(pgrep -x claude | sort -u); do
    # ディレクトリを取得
    dir=$(lsof -p $pid 2>&1 | grep -v "ERR:" | grep cwd | awk '{print $NF}' | head -1)
    [ -z "$dir" ] || [ "$dir" = "/" ] && continue
    
    # CPU使用率を取得
    cpu=$(ps -p $pid -o %cpu= 2>/dev/null | tr -d ' ')
    [ -z "$cpu" ] && continue
    
    ((total_count++))
    
    # プロジェクト名とCPU使用率
    project=$(basename "$dir")
    
    # CPU使用率の整数部分を取得（小数点処理を確実に）
    cpu_int=$(echo "$cpu" | cut -d'.' -f1)
    [ -z "$cpu_int" ] && cpu_int=0
    
    # Git情報を取得
    git_info=""
    if [ -d "$dir/.git" ]; then
        branch=$(cd "$dir" && git branch --show-current 2>/dev/null)
        changes=$(cd "$dir" && git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
        if [ -n "$branch" ]; then
            git_info=" [$branch"
            [ "$changes" != "0" ] && [ -n "$changes" ] && git_info="${git_info} +$changes"
            git_info="${git_info}]"
        fi
    fi
    
    # プロジェクト名とGit情報の長さを個別に計算
    project_len=${#project}
    [ $project_len -gt $max_project_len ] && max_project_len=$project_len
    git_len=${#git_info}
    [ $git_len -gt $max_git_len ] && max_git_len=$git_len
    
    # 状態判定と詳細作成（一時的に保存）
    if [ "$cpu_int" -gt 1 ]; then
        ((active_count++))
        details="${details}🔵|${project}|${git_info}||size=12\n"
    else
        ((idle_count++))
        # 待機時間を計算（簡易版）
        idle_time_file="/tmp/claude-idle-$pid"
        if [ ! -f "$idle_time_file" ]; then
            date +%s > "$idle_time_file"
            time_str="(開始)"
        else
            start_time=$(cat "$idle_time_file")
            current_time=$(date +%s)
            idle_seconds=$((current_time - start_time))
            
            if [ $idle_seconds -lt 60 ]; then
                time_str="(${idle_seconds}s)"
            elif [ $idle_seconds -lt 3600 ]; then
                minutes=$((idle_seconds / 60))
                seconds=$((idle_seconds % 60))
                time_str="(${minutes}m${seconds}s)"
            else
                hours=$((idle_seconds / 3600))
                minutes=$(((idle_seconds % 3600) / 60))
                time_str="(${hours}h${minutes}m)"
            fi
        fi
        details="${details}🔴|${project}|${git_info}|${time_str}|size=12\n"
    fi
done

# アクティブなプロセスの待機時間ファイルをクリーンアップ
for idle_file in /tmp/claude-idle-*; do
    [ -f "$idle_file" ] || continue
    pid=$(basename "$idle_file" | cut -d'-' -f3)
    # プロセスが存在するかチェック
    if ! kill -0 $pid 2>/dev/null; then
        rm -f "$idle_file"
    else
        # CPUが高い場合もクリア
        cpu_check=$(ps -p $pid -o %cpu= 2>/dev/null | tr -d ' ')
        if [ -n "$cpu_check" ]; then
            cpu_int_check=$(echo "$cpu_check" | cut -d'.' -f1)
            [ "$cpu_int_check" -gt 1 ] 2>/dev/null && rm -f "$idle_file"
        fi
    fi
done

# メニューバーに表示
if [ $total_count -eq 0 ]; then
    echo "Claude: なし|color=#666666"
    echo "---"
    echo "プロセスが見つかりません|size=12 color=#666666"
else
    # アイコンとカウント表示
    echo "Claude: 🔵${active_count} 🔴${idle_count}"
    echo "---"
    
    # 最小幅を設定
    [ $max_project_len -lt 20 ] && max_project_len=20
    [ $max_git_len -lt 15 ] && max_git_len=15
    
    # 詳細をフォーマットして表示
    echo -e "$details" | sort -t'|' -k2 | while IFS='|' read -r emoji project git_info time_str size_attr; do
        if [ -n "$emoji" ]; then
            # Git情報がない場合は空白で埋める
            [ -z "$git_info" ] && git_info=" "
            # SwiftBar用にモノスペースフォントを指定
            if [ -n "$time_str" ]; then
                printf "%-2s %-${max_project_len}s %-${max_git_len}s %s|%s font=\"SF Mono\"\n" "$emoji" "$project" "$git_info" "$time_str" "$size_attr"
            else
                printf "%-2s %-${max_project_len}s %s|%s font=\"SF Mono\"\n" "$emoji" "$project" "$git_info" "$size_attr"
            fi
        fi
    done
    
    echo "---"
    echo "合計: ${total_count}|size=11 color=#666666"
fi

# アクション
echo "---"
echo "ターミナルで監視を開く|bash='$HOME/bin/claude-monitor' terminal=true"
echo "更新|refresh=true"
