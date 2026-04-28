# /总检 命令详细执行规范

> 本文件是 `/总检` 命令的自包含说明书。进入命令后先读本文件，再按本文件的分层加载规则读取必要引用；不需要再回 `SKILL.md` 查加载规则。

## 用途

做跨文档一致性、商业强度、语言模式、分镜执行性和 AI 制作就绪检查。

## 分层加载规则

**核心层（每次进入 `/总检` 必读）：**

工作区定位：

- `references/workspace-projects.md` — 解析 `ACTIVE_DRAMA_DIR`；本命令所有业务文件都从该目录读写

业务数据文件（精读，只读事实与追踪段）：

- `故事设定.md` — **只读角色表、场景池、能力边界、本地化替换**
- `故事结构.md` — **只读情绪曲线、钩子系统、卡点清单**
- `分集大纲.md` — **只读尾钩与卡点标记**
- `分集追踪.md` — **只读事实账本与悬念债务状态**
- `质检检查点.md` — 历次质检的未闭环项
- （若存在）`分镜脚本/*.md` 抽样集：**关键卡点集、高潮集、尾钩集**

规则参照文件：

- `references/quality-gate.md` — 总检响应格式、P0/P1/P2 分级与回退规则
- `references/templates/review-report.md`（`总检报告.md` 固定模板）

**条件层（仅在满足触发条件时读取）：**

| 触发条件 | 读取文件 |
|---------|---------|
| 本次总检涉及前 3 集留人、钩子、情绪曲线复查 | `references/emotion-design.md` |
| 本次总检涉及卡点兑现与付费节奏复查 | `references/paywall-rules.md` |
| 本次总检发现连续性问题需追溯 | `references/continuity-ledger.md` |
| `mode=overseas`，需复查英文对白、屏幕字卡、本地化 | `references/language-mode.md` + `references/tiktok-platform-constraints.md`（只读竖屏字卡与本地化段） |
| 存在 `分镜脚本/`，需抽查镜头时长闭合与执行性 | `references/storyboard-conversion.md`（只读镜头时长闭合与回写规则段）+ `references/storyboard-script-templates.md`（只读字段口径段） |
| 总检需复查 AI 制作就绪度 | `references/ai-production.md`（**只读 §十 导出包、§十一 AI 就绪检查、§十二 质检联动**） |
| 高风险题材或海外合规前置检查 | `references/compliance-rules.md` |

## 执行要求

1. `总检报告.md` 固定模板以 `references/templates/review-report.md` 为唯一权威源。
2. 必须复查 3 秒卖点、前 3 集留人、卡点兑现、竖屏视觉表达、分镜执行性和跨文档事实一致性。
3. 若 `mode=overseas`，必须复查命名、本地化设定、场景文化、英文对白和关键冲突是否真的欧美可读；若仍是"中文情节外壳 + 英文翻译"，判 `P0`。
4. 若 `分镜脚本/` 已存在，必须抽查分镜稿与源剧本是否一致，重点检查镜头时长、转场、字卡、音效与尾钩放大镜头是否可执行；尤其要核对"本场预计时长 = 场内镜头求和""本集目标时长 = 分镜统计总时长"是否成立。
5. 若 `mode=overseas`，必须额外复查成片上屏字卡、屏幕 UI 文字和字幕强化提示是否误带中文；中文只允许留在文档说明和 `中译` 中，不得以"双语屏幕字"形式进入成片指令。
6. **总检 scope（强制先判定）**：默认 `/总检` 的目标是 `production-package`（完整制作包）。只有用户明确说"只做编剧包/非制作包/暂不含分镜"时，才允许把本轮标记为 `writing-only`。`writing-only` 只能输出写作层总检结论和待转分镜清单，不得写 `qcStatus.production = 已通过`，也不得授权 `/合规` 或默认 `/导出`。
7. **断点对齐检查（强制）**：读取 `剧本状态.json` 的 `deliveryProgress.scriptCompletedRanges` 和 `storyboardCompletedRanges`，按集号做交错对齐：
   - **裸剧本集**：有剧本但没对应分镜的集号，默认 `production-package` 下判 `P0`，列入"待转分镜"清单并阻塞 `/总检` 通过；仅当 scope=`writing-only` 时不阻塞，但必须在总检报告中显式列出，且不得回写 `qcStatus.production = 已通过`
   - **裸分镜集 / 源剧本过时**：遍历每个已落盘分镜稿，读取其 YAML frontmatter 的 `source_episode_version`，与对应 `分集剧本/第NNN集.md` frontmatter 的 `version` 字段严格比对。不一致 = 剧本已更新但分镜未重做，判 `P0`，列入"需重做分镜"清单。`version` frontmatter 字段口径见 `references/episode-script-templates.md` 与 `references/storyboard-script-templates.md`
   - **frontmatter 缺失**：任一 `分集剧本/*.md` 缺 `version` 或任一 `分镜脚本/*.md` 缺 `source_episode_version` = `P0`，本身就阻塞 `/总检` 通过
   - **交错空洞**：若存在 "第 1-5 集有剧本没分镜 / 第 6-10 集有分镜没剧本" 这种非单调推进模式，判 `P1` 并在报告中标红提示
   同时核对 `qcStatus.episodes[*]` 和 `qcStatus.storyboards[*]`：任一集仍为 `需修改` 状态 = `P0` 阻塞 `/总检` 通过。若本次总检目标是默认制作包，还必须确认已完成分镜范围被 `qcStatus.storyboards` 中 `status=已通过` 的 range 覆盖；缺失分镜质检记录 = P0，先补 `/分镜质检 {缺失区间}`。
8. 首次进入 `/总检` 时，若 `总检报告.md` 不存在才创建；不要提前创建 `合规报告.md` 或 `导出/`。
9. 未处理的 `P0` 仍然阻塞 `/合规` 与 `/导出`。
