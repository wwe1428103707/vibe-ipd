# Data Model: VIPD Command Prefix Renaming

## Entity: Skill Directory

| Attribute | Old Value | New Value |
|-----------|-----------|-----------|
| Directory name | `speckit-<name>` | `vipd-speckit-<name>` |
| Skill name in SKILL.md | `speckit-<name>` | `vipd-speckit-<name>` |
| Internal command refs | `/vipd-speckit-*` | `/vipd-speckit-*` |

## Entity: Document Reference

| Attribute | Old | New |
|-----------|-----|-----|
| Command reference | `/vipd-speckit-<name>` | `/vipd-speckit-<name>` |
| Hook command name | `speckit.<group>.<action>` | `vipd.speckit.<group>.<action>` |
