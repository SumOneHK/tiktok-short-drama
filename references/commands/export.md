# /导出 命令详细执行规范

> 本文件是 `/导出` 命令的自包含说明书。进入命令后只读本文件即可。

## 用途

汇总对外协作包(策划包、分集剧本合集、分镜脚本合集)。

## 分层加载规则

**核心层（每次进入 `/导出` 必读）：**

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
2. **分镜覆盖率硬闸门（P0）**：默认导出定义为"制作包导出"。执行前必须交叉检查 `deliveryProgress.scriptCompletedRanges` 与 `deliveryProgress.storyboardCompletedRanges`——若存在"某批次剧本已完成但对应分镜未完成"的缺口（即 `scriptCompletedRanges` 中某区间 ∉ `storyboardCompletedRanges`），判 P0 阻塞，提示用户先完成缺失批次的 `/分镜脚本`。同时必须确认全剧分镜范围被 `qcStatus.storyboards` 中 `status=已通过` 的 range 覆盖；缺失分镜质检记录 = P0，提示用户先补 `/分镜质检 {缺失区间}`。仅在 `storyboardCompletedRanges` 与分镜质检通过记录均覆盖全剧时执行默认制作包导出。
3. 首次执行 `/导出` 时，若 `导出/` 不存在才创建。
4. `导出/{剧名}-策划包.md` 只汇总策划、追踪、总检与合规文档，不拼接完整分集正文。
5. `导出/{剧名}-分集剧本合集.md` 通过 `.claude/skills/tiktok-short-drama/scripts/merge_episode_scripts.sh` 单独生成。
6. `导出/{剧名}-分镜脚本合集.md` 通过同一脚本、指定 `--source-dir 分镜脚本` 单独生成；缺少全剧覆盖的 `分镜脚本/` 时，禁止按默认制作包定义导出。
7. 若用户明确只要"编剧包"或"非制作包"，可跳过分镜合集，但必须在交付说明中明确写明"未包含 AI 视频制作分镜稿，不构成完整制作包"。
8. 若用户明确要求"单文件全量包"，再额外生成；默认导出定义以本节和 `references/ai-production.md` §十 为准。
9. 海外模式下保留中文策划说明；若分集正文或分镜稿包含英文对白、旁白、`OS`、`VO`、屏幕字卡，必须同时保留对应中文翻译。

## 脚本示例

```bash
.claude/skills/tiktok-short-drama/scripts/merge_episode_scripts.sh \
  --source-dir 分集剧本 \
  --output 导出/剧名-分集剧本合集.md \
  --title "剧名 分集剧本合集"

.claude/skills/tiktok-short-drama/scripts/merge_episode_scripts.sh \
  --source-dir 分镜脚本 \
  --output 导出/剧名-分镜脚本合集.md \
  --title "剧名 分镜脚本合集"
```
