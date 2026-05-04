-- Lua workflow notes template.
-- Replace placeholders only with verified API calls from the source tree.

local workflow = {
  name = 'workflow-name',
  purpose = 'describe the purpose',
  source_units = {
    'LuaHandler.pas'
  }
}

print('Workflow: ' .. workflow.name)
print('Purpose: ' .. workflow.purpose)
