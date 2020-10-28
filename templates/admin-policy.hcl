{
  "policy": "# Manage auth methods broadly across Vault\npath \"auth/*\"\n{\n  capabilities = [\"create\", \"read\", \"update\", \"delete\", \"list\", \"sudo\"]\n}\n\n# Create, update, and delete auth methods\npath \"sys/auth/*\"\n{\n  capabilities = [\"create\", \"update\", \"delete\", \"sudo\"]\n}\n\n# List auth methods\npath \"sys/auth\"\n{\n  capabilities = [\"read\"]\n}\n\n# List existing policies\npath \"sys/policies/acl\"\n{\n  capabilities = [\"list\"]\n}\n\n# Create and manage ACL policies \npath \"sys/policies/acl/*\"\n{\n  capabilities = [\"create\", \"read\", \"update\", \"delete\", \"list\", \"sudo\"]\n}\n\n# List, create, update, and delete key/value secrets\npath \"secret/*\"\n{\n  capabilities = [\"create\", \"read\", \"update\", \"delete\", \"list\", \"sudo\"]\n}\n\n# Manage secrets engines\npath \"sys/mounts/*\"\n{\n  capabilities = [\"create\", \"read\", \"update\", \"delete\", \"list\", \"sudo\"]\n}\n\n# List existing secrets engines.\npath \"sys/mounts\"\n{\n  capabilities = [\"read\"]\n}\n\n# Read health checks\npath \"sys/health\"\n{\n  capabilities = [\"read\", \"sudo\"]\n}"
}