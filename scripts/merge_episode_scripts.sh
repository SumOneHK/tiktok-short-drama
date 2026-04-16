#!/usr/bin/env bash
set -euo pipefail

source_dir="分集剧本"
output_path=""
title=""
public_clean=false

extract_episode_number() {
  local file_name
  file_name="$(basename "$1")"

  if [[ "$file_name" =~ ^第([0-9]{3,})集\.md$ ]]; then
    printf '%s\n' "${BASH_REMATCH[1]}"
    return 0
  fi

  return 1
}

usage() {
  cat <<'EOF'
用法：
  merge_episode_scripts.sh --output 导出/剧名-分集剧本合集.md [--source-dir 分集剧本] [--title "剧名 分集剧本合集"] [文件...]

说明：
  1. 如果不传具体文件，则会合并 source-dir 下全部 .md 文件。
  2. 如果传入文件列表，则按传入顺序合并。
  3. 默认 source-dir 为当前项目下的 `分集剧本/`。
  4. 传入 --public-clean 时，去除 YAML frontmatter、写前检查 HTML 注释和源文件注释，生成对外清稿。
EOF
}

emit_file() {
  local file="$1"

  if [[ "$public_clean" != true ]]; then
    cat "$file"
    return 0
  fi

  awk '
    NR == 1 && $0 == "---" {
      in_frontmatter = 1
      next
    }
    in_frontmatter && $0 == "---" {
      in_frontmatter = 0
      next
    }
    in_frontmatter {
      next
    }
    /<!-- 写前检查答案/ || /<!-- 写前14问答案/ {
      in_check_comment = 1
      next
    }
    in_check_comment && /-->/ {
      in_check_comment = 0
      next
    }
    in_check_comment {
      next
    }
    /^<!-- 源文件：/ {
      next
    }
    {
      print
    }
  ' "$file"
}

files=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source-dir)
      source_dir="$2"
      shift 2
      ;;
    --output)
      output_path="$2"
      shift 2
      ;;
    --title)
      title="$2"
      shift 2
      ;;
    --public-clean)
      public_clean=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      while [[ $# -gt 0 ]]; do
        files+=("$1")
        shift
      done
      ;;
    *)
      files+=("$1")
      shift
      ;;
  esac
done

if [[ -z "$output_path" ]]; then
  echo "错误：必须通过 --output 指定输出文件。" >&2
  usage >&2
  exit 1
fi

if [[ ${#files[@]} -eq 0 ]]; then
  if [[ ! -d "$source_dir" ]]; then
    echo "错误：分集目录不存在：$source_dir" >&2
    exit 1
  fi

  while IFS= read -r file; do
    episode_number="$(extract_episode_number "$file")" || {
      echo "错误：自动合并模式要求文件名符合 第NNN集.md，发现：$file" >&2
      exit 1
    }
    files+=("${episode_number}"$'\t'"${file}")
  done < <(find "$source_dir" -maxdepth 1 -type f -name '*.md' | LC_ALL=C sort -V)

  if [[ ${#files[@]} -eq 0 ]]; then
    echo "错误：没有找到可合并的分集剧本文件。" >&2
    exit 1
  fi

  sorted_files=()
  while IFS= read -r line; do
    sorted_files+=("${line#*$'\t'}")
  done < <(printf '%s\n' "${files[@]}" | sort -n -k1,1)
  files=("${sorted_files[@]}")
fi

if [[ ${#files[@]} -eq 0 ]]; then
  echo "错误：没有找到可合并的分集剧本文件。" >&2
  exit 1
fi

mkdir -p "$(dirname "$output_path")"

{
  if [[ -n "$title" ]]; then
    printf '# %s\n\n' "$title"
  fi
  if [[ "$public_clean" != true ]]; then
    printf '<!-- 由 scripts/merge_episode_scripts.sh 自动生成，请勿手工逐段拼接 -->\n\n'
    printf '> 合并时间：%s\n\n' "$(date '+%Y-%m-%d %H:%M:%S')"
  fi

  for file in "${files[@]}"; do
    if [[ ! -f "$file" ]]; then
      echo "错误：文件不存在：$file" >&2
      exit 1
    fi

    if [[ "$public_clean" != true ]]; then
      printf '\n<!-- 源文件：%s -->\n\n' "$file"
    fi
    emit_file "$file"
    printf '\n'
  done
} > "$output_path"

printf '已生成：%s\n' "$output_path"
