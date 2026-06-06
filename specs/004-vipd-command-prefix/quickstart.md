# Quickstart: VIPD Command Prefix Renaming

```bash
# 1. Copy skill dirs
for dir in .claude/skills/vipd-speckit-*/; do
  newdir=".claude/skills/vipd-${dir#.claude/skills/vipd-speckit-}"
  cp -r "$dir" "$newdir"
  sed -i 's|/vipd-speckit-|/vipd-speckit-|g' "$newdir/SKILL.md"
done

# 2. Replace in docs
find docs/ipd-transformation/ -name "*.md" -exec sed -i 's|/vipd-speckit-|/vipd-speckit-|g' {} +

# 3. Replace in templates
find .specify/templates/ -name "*.md" -exec sed -i 's|/vipd-speckit-|/vipd-speckit-|g' {} +

# 4. Replace in constitution
sed -i 's|/vipd-speckit-|/vipd-speckit-|g' .specify/memory/constitution.md

# 5. Replace in spec artifacts
find specs/ -name "*.md" -exec sed -i 's|/vipd-speckit-|/vipd-speckit-|g' {} +

# 6. Update extensions.yml dotted names
sed -i 's|speckit\.|vipd.speckit.|g' .specify/extensions.yml

# 7. Verify
grep -rn "/vipd-speckit-" . --include="*.md" --include="*.yml"
# Should return zero matches
```
