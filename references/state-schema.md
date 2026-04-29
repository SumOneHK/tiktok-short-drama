# 剧本状态.json Schema 与状态流转

> **何时读本文件**：
> - 首次进入 `/开始` 创建 `剧本状态.json` 时
> - 任何命令要回写 `currentStep`、`deliveryProgress`、`qcStatus` 时
> - 恢复现场、核对字段含义或排查状态不一致时
>
> 日常命令若不直接写状态字段，不需要加载本文件。SKILL.md 只保留最小 JSON 样例，字段定义与同步规则以本文件为准。

## 完整 Schema

字段规范化：

- `mode` 是短枚举：`overseas | domestic`
- `languageMode` 是带细节的长枚举：`overseas-en-dialogue | domestic-zh`
- 所有命令文件中引用语言细节时统一使用 `languageMode` 字段名 + 长枚举值
- 规则文件中历史遗留的 `mode=overseas` 等价于 `languageMode=overseas-en-dialogue`

```json
{
  "project": {
    "directoryName": "",
    "displayTitle": "",
    "createdAt": "YYYY-MM-DD",
    "workspaceMode": "multi-drama"
  },
  "currentStep": "开始|立项|设定|结构|分集大纲|分集剧本|分镜脚本|总检|合规|导出",
  "platform": "tiktok",
  "mode": "overseas|domestic",
  "languageMode": "overseas-en-dialogue|domestic-zh",
  "targetMarket": "north-america|europe|sea|latam|middle-east|mixed",
  "genre": [],
  "audience": "",
  "tone": "",
  "endingType": "",
  "dramaTitle": "",
  "episodeCount": 0,
  "episodeDurationSec": 0,
  "emotionKeywords": [],
  "artStyle": "",
  "payModel": "free-only|hybrid|paywalled",
  "paidStartEpisode": 0,
  "deliveryProgress": {
    "scriptCompletedRanges": [
      "001-005"
    ],
    "storyboardCompletedRanges": [
      "001-005"
    ],
    "nextScriptRange": "",
    "nextStoryboardRange": ""
  },
  "lastQcStep": "",
  "qcStatus": {
    "start": "未检查|已通过|需修改",
    "market": "未检查|已通过|需修改",
    "bible": "未检查|已通过|需修改",
    "architecture": "未检查|已通过|需修改",
    "outline": "未检查|已通过|需修改",
    "planningRead": "未检查|已通过|需修改",
    "episodes": [
      {
        "range": "001-005",
        "checkType": "script|continuity|full-read",
        "status": "未检查|已通过|需修改",
        "date": "YYYY-MM-DD",
        "blockingIssues": [],
        "notes": ""
      }
    ],
    "storyboards": [
      {
        "range": "001-005",
        "status": "未检查|已通过|需修改",
        "date": "YYYY-MM-DD",
        "blockingIssues": [],
        "notes": ""
      }
    ],
    "production": "未检查|已通过|需修改",
    "compliance": "未检查|已通过|需修改"
  }
}
```

## 新项目初始化模板

首次进入 `/开始` 创建 `剧本状态.json` 时，必须使用下面的合法 JSON 作为最小初始状态；用户尚未确认的字段保留空值或空数组，不得把推荐方案伪装成已确认值。

```json
{
  "project": {
    "directoryName": "",
    "displayTitle": "",
    "createdAt": "YYYY-MM-DD",
    "workspaceMode": "multi-drama"
  },
  "currentStep": "开始",
  "platform": "tiktok",
  "mode": "",
  "languageMode": "",
  "targetMarket": "",
  "genre": [],
  "audience": "",
  "tone": "",
  "endingType": "",
  "dramaTitle": "",
  "episodeCount": 0,
  "episodeDurationSec": 0,
  "emotionKeywords": [],
  "artStyle": "",
  "payModel": "",
  "paidStartEpisode": 0,
  "deliveryProgress": {
    "scriptCompletedRanges": [],
    "storyboardCompletedRanges": [],
    "nextScriptRange": "",
    "nextStoryboardRange": ""
  },
  "lastQcStep": "",
  "qcStatus": {
    "start": "未检查",
    "market": "未检查",
    "bible": "未检查",
    "architecture": "未检查",
    "outline": "未检查",
    "planningRead": "未检查",
    "episodes": [],
    "storyboards": [],
    "production": "未检查",
    "compliance": "未检查"
  }
}
```

## `deliveryProgress` 字段约定

- `scriptCompletedRanges`：**已落盘但不代表已质检通过**的剧本区间列表（即"写完盘上有这一批的 md 文件"），写实际集数区间，如 `001-005`。落盘 ≠ 通过——是否允许推进正式 `/分镜脚本` 以“全剧剧本已落盘 + 全剧批次剧本质检已通过 + `/整剧通读` 已通过”为唯一授权源，不以本字段为准
- `storyboardCompletedRanges`：已完成并落盘的**正式分镜**区间列表，写实际集数区间，如 `001-005`；视觉试片 / 风格验证等非主流程试验稿不得写入
- `nextScriptRange`：下一批计划写作的剧本区间；未知时留空
- `nextStoryboardRange`：下一批计划转换的正式分镜区间；全剧剧本未完成或 `/整剧通读` 未通过前必须留空

维护规则：

- 区间一律写实际批次，不写模糊文字
- 若两个相邻区间已经连续且内容稳定，可在后续更新时合并
- 恢复现场时优先依据 `scriptCompletedRanges` 与 `qcStatus.episodes` 判断下一批剧本或质检缺口；`storyboardCompletedRanges` 只在全剧定稿后判断正式分镜缺口
- **权威源优先级**：判断能否推进正式 `/分镜脚本` 时，必须同时满足：`scriptCompletedRanges` 覆盖 `1..episodeCount`、`qcStatus.episodes` 中 `checkType == "script"` 且 `status == 已通过` 的 range 覆盖全剧、存在覆盖全剧的 `checkType == "full-read"` 且 `status == 已通过` 记录。若任一条件不满足，即使某批次剧本质检已通过，也**不得**进入正式 `/分镜脚本`
- **回退规则**：若 `/剧本质检` 判 `P0`，不得从 `scriptCompletedRanges` 里删除该区间（文件确实存在），但必须同步把 `qcStatus.episodes` 中对应 `range + checkType=script` 的 `status` 写为 `需修改`，且 `currentStep` 保持 `分集剧本` 不前进
- 若 `/整剧通读` 判 `P0/P1` 且阻塞分镜，不得删除任何已落盘剧本区间；必须把覆盖全剧的 `range + checkType=full-read` 写为 `需修改`，并把需要修源的具体 `script` 批次回退为 `未检查` 或 `需修改`
- `/导出` 前必须核对 `storyboardCompletedRanges` 是否覆盖全剧

## `qcStatus.episodes` 字段约定

- `range`：质检覆盖的集数区间，固定写成 `001-005`
- `checkType`：`script` 对应 `/剧本质检`，`continuity` 对应 `/衔接质检`，`full-read` 对应 `/整剧通读`
- `status`：本批次结论
- `date`：最近一次更新日期
- `blockingIssues`：当前仍阻塞推进的 QC ID 列表
- `notes`：对本批次的短备注；同一 `range + checkType` 组合应更新原记录，不重复新建

## `qcStatus.storyboards` 字段约定

- `range`：质检覆盖的集数区间，固定写成 `001-005`
- `status`：本批次结论
- `date`：最近一次更新日期
- `blockingIssues`：当前仍阻塞推进的 QC ID 列表
- `notes`：对本批次的短备注；同一 `range` 应更新原记录，不重复新建

## 状态同步规则

- `/开始` 新建剧本目录时更新：
  - `project.directoryName = ACTIVE_DRAMA_DIR` 的目录名
  - `project.createdAt = YYYY-MM-DD`
  - `project.workspaceMode = multi-drama`
  - 若已有临时或正式标题，`project.displayTitle` 可同步写入；未确认时留空
- `/开始` 内建自检通过后更新：
  - `lastQcStep = "/开始"`
  - `qcStatus.start = 已通过 / 需修改`
  - 自检通过且用户已明确选定方向时：`currentStep = 立项`
  - 自检结果只写入 `选题分析.md` 推荐版末尾，不落盘 `质检检查点.md`
- `/立项` 内建自检通过后更新：
  - `lastQcStep = "/立项"`
  - `qcStatus.market = 已通过 / 需修改`
  - 若正式剧名已确认，同步写入 `dramaTitle` 与 `project.displayTitle`
  - 自检通过后：`currentStep = 设定`
  - 自检结果只写入 `选题分析.md` 正式版末尾，不落盘 `质检检查点.md`
- `/设定质检` 结束后更新：
  - `lastQcStep = "/设定质检"`
  - `qcStatus.bible = 已通过 / 需修改`
  - 通过后：`currentStep = 结构`；不通过：`currentStep = 设定`
- `/结构质检` 结束后更新：
  - `lastQcStep = "/结构质检"`
  - `qcStatus.architecture = 已通过 / 需修改`
  - 通过后：`currentStep = 分集大纲`；不通过：`currentStep = 结构`
- `/大纲质检` 结束后更新:
  - `lastQcStep = "/大纲质检"`
  - `qcStatus.outline = 已通过 / 需修改`
  - 通过后：`qcStatus.planningRead = 未检查`，`currentStep = 分集剧本`；不通过：`qcStatus.planningRead = 未检查`，`currentStep = 分集大纲`
- `/策划通读` 结束后更新：
  - `lastQcStep = "/策划通读"`
  - `qcStatus.planningRead = 已通过 / 需修改`
  - 通过后：`currentStep = 分集剧本`
  - 不通过：按最早需要修源的阶段回退 `currentStep`（通常为 `分集大纲`；若需改设定或结构，则回退到对应阶段）
- `/分集剧本 {起止集}` 成功落盘后更新：
  - `deliveryProgress.scriptCompletedRanges` 追加或合并对应区间（仅代表"已落盘"，不代表"已通过"）
  - `deliveryProgress.nextStoryboardRange` 在全剧剧本未完成或 `/整剧通读` 未通过前保持空值；不得默认指向本批次区间
  - `currentStep` 按 §批次生产的 currentStep 语义 重新判定（不得硬写 `分集剧本`）
- `/剧本质检 {起止集}`、`/衔接质检 {起止集}` 或 `/整剧通读` 结束后更新：
  - `lastQcStep = "/剧本质检"`、`"/衔接质检"` 或 `"/整剧通读"`
  - `qcStatus.episodes` 追加或更新对应批次记录
  - `/整剧通读` 的 `range` 必须覆盖全剧，如 `001-048`，`checkType = "full-read"`；若通读要求修源，必须同步把受影响 `checkType=script` 批次回退为 `未检查` 或 `需修改`
  - 通过后按 §批次生产的 currentStep 语义 重新判定 `currentStep`
- `/分镜脚本 {起止集}` 成功落盘后更新：
  - `deliveryProgress.storyboardCompletedRanges` 追加或合并对应区间
  - `currentStep` 按 §批次生产的 currentStep 语义 重新判定（**不得硬写 `分镜脚本`**——若后续修源导致剧本批次、整剧通读或前置门禁失效，必须回到 `分集剧本` 或对应上游阶段）
- `/分镜质检 {起止集}` 结束后更新：
  - `lastQcStep = "/分镜质检"`
  - `qcStatus.storyboards` 追加或更新对应批次记录
  - 通过后按 §批次生产的 currentStep 语义 重新判定 `currentStep`
- `/总检` 结束后更新：
  - `lastQcStep = "/总检"`
  - 默认 `production-package` 总检：`qcStatus.production = 已通过 / 需修改`
  - 若用户明确要求 `writing-only` 总检（编剧包/非制作包/暂不含分镜），只更新 `总检报告.md` 与 `lastQcStep`，不得写 `qcStatus.production = 已通过`；可在报告和备注中标明"写作层通过，未授权制作包/合规/导出"
- `/合规` 结束后更新：
  - `lastQcStep = "/合规"`
  - `qcStatus.compliance = 已通过 / 需修改`

## 批次生产的 currentStep 语义

> 本 skill 默认“剧本批次滚动、正式分镜后置”（批次剧本 → 批次剧本质检 → 循环至全剧剧本完成 → 整剧通读 → 正式分镜）。`currentStep` **不是单调前进状态机**，而是"本会话当前处于哪个生产动作里"的标签。单一命令结束时不得硬写固定值，必须按下列规则重新判定：

**判定规则**（按优先级从上到下）：

1. 上游门禁未通过时按最早未通过阶段回退：`qcStatus.market != 已通过` → `立项`；`qcStatus.bible != 已通过` → `设定`；`qcStatus.architecture != 已通过` → `结构`；`qcStatus.outline != 已通过` → `分集大纲`
2. 全部区间都通过 `/合规` 且 `qcStatus.compliance == 已通过` → `currentStep = 导出`
3. 全部区间都通过 `/总检` 且 `qcStatus.production == 已通过`，但合规未过 → `currentStep = 合规`
4. 首批剧本前，若项目满足 `/策划通读` 触发条件且 `qcStatus.planningRead != 已通过` → `currentStep` 仍可为 `分集剧本`，但 `/分集剧本 {起止集}` 被阻塞，必须先执行或修复 `/策划通读`
5. 存在任一区间 `qcStatus.episodes[*].status == 需修改` → `currentStep = 分集剧本`（需修复当前批次剧本或整剧通读修源问题）
6. 存在已落盘剧本区间但未被 `qcStatus.episodes[*]` 中 `checkType == "script"` 且 `status == 已通过` 的 range 覆盖 → `currentStep = 分集剧本`（需补 `/剧本质检` 或修复剧本）
7. 剧本未覆盖全剧（`scriptCompletedRanges` 未覆盖 `1..episodeCount`） → `currentStep = 分集剧本`
8. 全剧分集剧本已落盘且 `checkType=script` 已通过覆盖 `1..episodeCount`，但不存在覆盖全剧的 `checkType=full-read` 且 `status=已通过` 记录 → `currentStep = 分集剧本`（需执行 `/整剧通读` 或修复通读问题）
9. 在规则 1-8 全部通过后，若存在任一区间 `qcStatus.storyboards[*].status == 需修改` → `currentStep = 分镜脚本`（需修复当前批次分镜）
10. 在规则 1-8 全部通过后，若存在已落盘正式分镜区间但未被 `qcStatus.storyboards[*].status == 已通过` 的 range 覆盖 → `currentStep = 分镜脚本`（需补 `/分镜质检` 或修复分镜）
11. 在规则 1-8 全部通过后，若 `storyboardCompletedRanges` 未覆盖目标正式分镜范围 → `currentStep = 分镜脚本`
12. 在规则 1-8 全部通过后，若正式分镜与分镜质检已覆盖目标交付范围但 `qcStatus.production != 已通过` → `currentStep = 总检`
13. 其余情况按上游命令决定

**触发时机**：

- `/分集剧本 {起止集}` 成功落盘后：按规则 1-8 重新判定（通常停在 `分集剧本` 等待 `/剧本质检`；若全剧完成且批次剧本质检全通过，则继续等待 `/整剧通读`，不得因文件已落盘而进入分镜）
- `/剧本质检 {起止集}` 通过后：按规则 1-8 判定（全剧未完成时继续停在 `分集剧本`，提示下一批剧本；全剧剧本已完成但未整剧通读时，停在 `分集剧本` 等 `/整剧通读`）
- `/整剧通读` 通过后：按规则 1-13 判定（若全剧剧本已通过且尚未转正式分镜，通常转 `分镜脚本`）
- `/分镜脚本 {起止集}` 成功落盘后：按规则 1-13 重新判定（**不得硬写 `分镜脚本`**——若后续修源导致剧本批次或整剧通读未过，应回到 `分集剧本`）
- `/分镜质检 {起止集}` 通过后：按规则 1-13 判定
- 用户通过 `/复盘` 或 `/继续` 恢复现场时：全量按规则 1-13 判定

**禁止模式**：

- ❌ `/分镜脚本` 落盘后无脑写 `currentStep = 分镜脚本`（会遮蔽剧本批次缺口）
- ❌ `/剧本质检` 通过后无脑写 `currentStep = 分镜脚本`（正式分镜必须等全剧剧本完成并通过 `/整剧通读`）
- ❌ 以 `scriptCompletedRanges` 的最大区间直接推 `currentStep`（忽略质检状态）

## P0 与收口回退规则

若任一质检出现 `P0`，对应 `qcStatus` 必须记为 `需修改`，且不得推进下一阶段。

若在 `/总检` 或 `/合规` 之后继续修改 `故事设定.md`、`故事结构.md`、`分集大纲.md`、`分集剧本/*.md`、`分镜脚本/*.md`、`分集追踪.md` 中任何影响内容判断的字段：

- `qcStatus.production` 必须回退为 `未检查`
- `qcStatus.compliance` 必须回退为 `未检查`
- 必须重新执行 `/总检`，必要时再执行 `/合规`
