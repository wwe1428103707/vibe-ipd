// Claude Code Workflow 环境探测脚本
// 用于验证 Workflow 工具在当前环境中可用
// 由 vipd-implement 在 Claude Code 模式下调用

export const meta = {
  name: 'probe',
  description: 'Workflow runtime availability probe',
  phases: [],
}

// 空 Workflow — 仅用于探测 Workflow 工具是否可用
// 如果此脚本能被 Workflow 工具成功解析并执行，
// 则说明当前环境支持 Clode Code Workflow
