# /导出 命令详细执行规范

> 本文件是 `/导出` 命令的自包含说明书。进入命令后先读本文件，再按本文件的分层加载规则读取必要引用；不需要再回 `SKILL.md` 查加载规则。

## 用途

汇总对外协作包(策划包、分集剧本合集、分镜脚本合集)。

## 分层加载规则

**核心层（每次进入 `/导出` 必读）：**

工作区定位：

- `references/workspace-projects.md` — 解析 `ACTIVE_DRAMA_DIR`；本命令所有业务文件都从该目录读写

业务数据文件：

- `总检报告.md` — 验证未闭环 P0 项
- `合规报告.md` — 验证合规阻塞项
- `剧本状态.json` — 校验 `deliveryProgress.storyboardCompletedRanges` 覆盖度

规则参照文件：

- 本文件（`references/commands/export.md`）— 导出定义、目录布局、脚本调用方式

**条件层（仅在满足触发条件时读取）：**

| 触发条件 | 读取文件 |
|---------|---------|
| 用户要求"完整制作包"或对 AI 制作包格式有疑问 | `references/ai-production.md`（**只读 §十 导出包**） |
| `mode=overseas` 需复查导出物中文/英文双语保留 | `references/language-mode.md`（只读字卡与对白段） |

## 执行要求

1. **最终质检硬闸门（P0）**：执行前必须确认 `qcStatus.production = 已通过` 且 `qcStatus.compliance = 已通过`，并确认 `总检报告.md` 与 `合规报告.md` 不存在阻塞项；任一不满足都不得导出。
2. **分镜覆盖率硬闸门（P0）**：默认导出定义为"制作包导出"。执行前必须确认 `deliveryProgress.scriptCompletedRanges` 覆盖 `1..episodeCount`，并确认正式 `storyboardCompletedRanges` 覆盖 `1..episodeCount`；不得按剧本批次与分镜批次的字符串是否一一对应来判断，因为正式分镜可在全剧定稿后按不同范围分批生成。若存在全剧分镜覆盖缺口，判 P0 阻塞，提示用户先完成缺失集数的 `/分镜脚本 {缺失区间}`。同时必须确认全剧分镜范围被 `qcStatus.storyboards` 中 `status=已通过` 的 range 覆盖；缺失分镜质检记录 = P0，提示用户先补 `/分镜质检 {缺失区间}`。仅在 `storyboardCompletedRanges` 与分镜质检通过记录均覆盖全剧时执行默认制作包导出。
3. 首次执行 `/导出` 时，若 `导出/` 不存在才创建。
4. `导出/{剧名}-策划包.md` 只汇总策划、追踪、总检与合规文档，不拼接完整分集正文。
5. `导出/{剧名}-分集剧本合集.md` 通过 skill 目录下的 `scripts/merge_episode_scripts.sh --public-clean` 单独生成；执行时建议以 `ACTIVE_DRAMA_DIR` 为 working directory，或显式传入 `ACTIVE_DRAMA_DIR/分集剧本` 与 `ACTIVE_DRAMA_DIR/导出/...`。默认对外协作包必须是清稿，不得包含 YAML frontmatter、写前检查 HTML 注释、质检状态、源文件注释等内部生产痕迹；若用户明确要求“内部审阅版/带质检留痕版”，才允许不加 `--public-clean`。
6. `导出/{剧名}-分镜脚本合集.md` 通过同一脚本、指定 `--source-dir 分镜脚本 --public-clean` 单独生成；缺少全剧覆盖的 `分镜脚本/` 时，禁止按默认制作包定义导出。
7. 若用户明确只要"编剧包"或"非制作包"，可跳过分镜合集，但必须在交付说明中明确写明"未包含 AI 视频制作分镜稿，不构成完整制作包"。
8. 若用户明确要求"单文件全量包"，再额外生成；默认导出定义以本节和 `references/ai-production.md` §十 为准。
9. 海外模式下保留中文策划说明；若分集正文或分镜稿包含英文对白、旁白、`OS`、`VO`、屏幕字卡，必须同时保留对应中文翻译。

## 脚本示例

```bash
{skill目录}/scripts/merge_episode_scripts.sh \
  --source-dir 分集剧本 \
  --output 导出/剧名-分集剧本合集.md \
  --title "剧名 分集剧本合集" \
  --public-clean

{skill目录}/scripts/merge_episode_scripts.sh \
  --source-dir 分镜脚本 \
  --output 导出/剧名-分镜脚本合集.md \
  --title "剧名 分镜脚本合集" \
  --public-clean
```
