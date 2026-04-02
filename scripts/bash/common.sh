#!/usr/bin/env bash
# 共用函式與變數：所有 bash 腳本都會引用這裡的工具函式

# 取得 repo 根目錄：
# 1) 有 git 時，用 git rev-parse
# 2) 沒有 git 時，退回到腳本所在位置往上推
get_repo_root() {
    if git rev-parse --show-toplevel >/dev/null 2>&1; then
        git rev-parse --show-toplevel
    else
        # 非 git repo：用腳本位置往上回溯為專案根
        local script_dir="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        (cd "$script_dir/../../.." && pwd)
    fi
}

# 取得目前分支/功能名稱：
# 1) 優先使用 SPECIFY_FEATURE 環境變數（適用於無 git 或手動指定）
# 2) 其次使用 git 取得目前分支
# 3) 再不行就找 specs/ 下最新的數字前綴目錄
# 4) 最後回退為 main
get_current_branch() {
    # 先看是否有明確指定功能名稱
    if [[ -n "${SPECIFY_FEATURE:-}" ]]; then
        echo "$SPECIFY_FEATURE"
        return
    fi

    # 有 git 的話直接用目前分支
    if git rev-parse --abbrev-ref HEAD >/dev/null 2>&1; then
        git rev-parse --abbrev-ref HEAD
        return
    fi

    # 無 git 時，從 specs/ 找出最大數字前綴的功能目錄
    local repo_root=$(get_repo_root)
    local specs_dir="$repo_root/specs"

    if [[ -d "$specs_dir" ]]; then
        local latest_feature=""
        local highest=0

        for dir in "$specs_dir"/*; do
            if [[ -d "$dir" ]]; then
                local dirname=$(basename "$dir")
                if [[ "$dirname" =~ ^([0-9]{3})- ]]; then
                    local number=${BASH_REMATCH[1]}
                    number=$((10#$number))
                    if [[ "$number" -gt "$highest" ]]; then
                        highest=$number
                        latest_feature=$dirname
                    fi
                fi
            fi
        done

        if [[ -n "$latest_feature" ]]; then
            echo "$latest_feature"
            return
        fi
    fi

    # 最終兜底
    echo "main"
}

# 是否為 git repo（用於決定是否檢查分支命名）
has_git() {
    git rev-parse --show-toplevel >/dev/null 2>&1
}

# 檢查分支是否符合 `###-xxx` 命名規則：
# - 非 git repo 直接略過驗證（但仍輸出提示）
# - git repo 且不符合規則則回傳失敗
check_feature_branch() {
    local branch="$1"
    local has_git_repo="$2"

    # 非 git repo：不強制規則
    if [[ "$has_git_repo" != "true" ]]; then
        echo "[specify] Warning: Git repository not detected; skipped branch validation" >&2
        return 0
    fi

    if [[ ! "$branch" =~ ^[0-9]{3}- ]]; then
        echo "ERROR: Not on a feature branch. Current branch: $branch" >&2
        echo "Feature branches should be named like: 001-feature-name" >&2
        return 1
    fi

    return 0
}

# 組合功能目錄位置：<repo>/specs/<branch>
get_feature_dir() { echo "$1/specs/$2"; }

# 以數字前綴找到對應的 spec 目錄（允許多分支共用同一 spec）
# 例如：004-fix-bug、004-add-feature 都對應 specs/004-*
find_feature_dir_by_prefix() {
    local repo_root="$1"
    local branch_name="$2"
    local specs_dir="$repo_root/specs"

    # 從分支名稱擷取 3 位數前綴
    if [[ ! "$branch_name" =~ ^([0-9]{3})- ]]; then
        # 沒有前綴：改用完整分支名稱
        echo "$specs_dir/$branch_name"
        return
    fi

    local prefix="${BASH_REMATCH[1]}"

    # 搜尋 specs/ 下相同前綴的目錄
    local matches=()
    if [[ -d "$specs_dir" ]]; then
        for dir in "$specs_dir"/"$prefix"-*; do
            if [[ -d "$dir" ]]; then
                matches+=("$(basename "$dir")")
            fi
        done
    fi

    # 根據匹配結果回傳路徑
    if [[ ${#matches[@]} -eq 0 ]]; then
        # 無匹配：回傳原分支名稱（後續會有清楚錯誤）
        echo "$specs_dir/$branch_name"
    elif [[ ${#matches[@]} -eq 1 ]]; then
        # 只有一個匹配：直接使用
        echo "$specs_dir/${matches[0]}"
    else
        # 多個匹配：提示使用者修正
        echo "ERROR: Multiple spec directories found with prefix '$prefix': ${matches[*]}" >&2
        echo "Please ensure only one spec directory exists per numeric prefix." >&2
        echo "$specs_dir/$branch_name"  # Return something to avoid breaking the script
    fi
}

# 匯出一組關鍵路徑，供其他腳本 eval 使用
get_feature_paths() {
    local repo_root=$(get_repo_root)
    local current_branch=$(get_current_branch)
    local has_git_repo="false"

    if has_git; then
        has_git_repo="true"
    fi

    # 使用前綴查找，支援多分支對同一 spec
    local feature_dir=$(find_feature_dir_by_prefix "$repo_root" "$current_branch")

    cat <<EOF
REPO_ROOT='$repo_root'
CURRENT_BRANCH='$current_branch'
HAS_GIT='$has_git_repo'
FEATURE_DIR='$feature_dir'
FEATURE_SPEC='$feature_dir/spec.md'
IMPL_PLAN='$feature_dir/plan.md'
TASKS='$feature_dir/tasks.md'
RESEARCH='$feature_dir/research.md'
DATA_MODEL='$feature_dir/data-model.md'
QUICKSTART='$feature_dir/quickstart.md'
CONTRACTS_DIR='$feature_dir/contracts'
EOF
}

# 檢查檔案/目錄是否存在並輸出狀態（✓/✗）
check_file() { [[ -f "$1" ]] && echo "  ✓ $2" || echo "  ✗ $2"; }
check_dir() { [[ -d "$1" && -n $(ls -A "$1" 2>/dev/null) ]] && echo "  ✓ $2" || echo "  ✗ $2"; }
