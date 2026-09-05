-- Workspace rules wiki https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- Keep one persistent default workspace per monitor; further numbered workspaces are dynamic.
hl.workspace_rule({ workspace = "name:gaming", monitor = PRIMARY_MONITOR})
hl.workspace_rule({ workspace = "1", monitor = MONITOR1, default = true, persistent = true })
hl.workspace_rule({ workspace = "2", monitor = MONITOR2, default = true, persistent = true })
