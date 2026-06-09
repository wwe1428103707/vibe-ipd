// Claude Code Workflow 模板
// 由 vipd-tasks 在 Claude Code 模式下自动生成
// 参考: https://code.claude.com/docs/en/workflows.md
// 模板版本: 1.0
//
// 使用说明：
// - 由 vipd-tasks 在每次运行时自动重新生成
// - 通过 Workflow 工具执行：Workflow({scriptPath: '.claude/workflows/execute-tasks.wf.js'})
// - 可通过 /workflows 查看执行进度
// - 同 session 内支持暂停恢复

export const meta = {
  name: 'execute-tasks',
  description: 'Execute tasks for {{FEATURE_NAME}}',
  phases: [
    { title: 'Setup', detail: 'Project initialization and infrastructure' },
    { title: 'Foundational', detail: 'Blocking prerequisites for all stories' },
    {{PHASES_META}}
    { title: 'Polish', detail: 'Cross-cutting concerns and validation' },
  ],
}

// ============================================================
// Phase 1: Setup — 顺序执行，无外部依赖
// Barrier: 全部 Setup 完成后才进入 Foundational
// ============================================================
phase('Setup')
log('Starting Setup phase — {{SETUP_COUNT}} tasks')

{{SETUP_TASKS}}

const setupResults = await parallel(SETUP_AGENTS.map(fn => fn()))
log(`Setup complete: ${setupResults.filter(Boolean).length}/${SETUP_AGENTS.length} tasks succeeded`)

// ============================================================
// Phase 2: Foundational — 阻塞所有 User Story
// Barrier: 全部 Foundational 完成后才进入 User Stories
// ============================================================
phase('Foundational')
log('Starting Foundational phase — {{FOUNDATION_COUNT}} tasks')

{{FOUNDATION_TASKS}}

const foundationResults = await parallel(FOUNDATION_AGENTS.map(fn => fn()))
log(`Foundation complete: ${foundationResults.filter(Boolean).length}/${FOUNDATION_AGENTS.length} tasks succeeded`)
log('Foundation ready — proceeding to user stories')

// ============================================================
// User Story Phases — 并发执行，自适应并行度
// 每个 User Story 通过独立的 agent() 执行
// 并发上限: min(5, 用户故事数)
// ============================================================
{{STORY_PHASES}}

const maxConcurrent = Math.min(5, STORY_AGENTS.length)
log(`Starting ${STORY_AGENTS.length} user stories (max ${maxConcurrent} concurrent)`)

const storyResults = await parallel(STORY_AGENTS.map(fn => fn()))
const storySuccess = storyResults.filter(Boolean).length
log(`User stories complete: ${storySuccess}/${STORY_AGENTS.length} stories succeeded`)

// ============================================================
// Polish & Cross-Cutting — 收尾工作
// ============================================================
phase('Polish')
log('Starting Polish phase — {{POLISH_COUNT}} tasks')

{{POLISH_TASKS}}

const polishResults = await parallel(POLISH_AGENTS.map(fn => fn()))
log(`Polish complete: ${polishResults.filter(Boolean).length}/${POLISH_AGENTS.length} tasks succeeded`)

// ============================================================
// Summary
// ============================================================
const totalAgents = SETUP_AGENTS.length + FOUNDATION_AGENTS.length + STORY_AGENTS.length + POLISH_AGENTS.length
const totalSucceeded = [setupResults, foundationResults, storyResults, polishResults]
  .flat().filter(Boolean).length

log(`=== Execution Complete: {{FEATURE_NAME}} ===`)
log(`Total agents: ${totalAgents}`)
log(`Succeeded: ${totalSucceeded}`)
log(`Failed: ${totalAgents - totalSucceeded}`)

if (totalSucceeded < totalAgents) {
  log('WARNING: Some tasks failed. Review agent outputs for details.')
}
