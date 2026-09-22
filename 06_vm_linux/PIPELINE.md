# Azure DevOps — create this Linux VM

Pipeline file (repo root): `azure-pipelines.yml`

Uses **Terraform extension tasks** (`TerraformInstaller@1`, `TerraformTaskV4@4`), not Azure CLI scripts.

## Install the extension

Organization settings → **Extensions** → Browse marketplace → install **[Terraform](https://marketplace.visualstudio.com/items?itemName=charleszipp.azure-pipelines-tasks-terraform)** by Charles Zipp.

If you installed **Terraform by Microsoft DevLabs** instead, in the YAML change every `TerraformTaskV4@4` to `TerraformTask@5` (same inputs).

| Parameter `action` | Result |
| ------------------ | ------ |
| `plan` (default) | init / validate / plan — **no VM** |
| `apply` | Creates the Ubuntu VM |
| `destroy` | Deletes the VM and related resources |

CI on `main` is **plan only**. Apply and destroy are **manual** runs.

---

## One-time setup

### 1. Remote state

```bash
az group create -n tfstate-rg -l westeurope
az storage account create -n UNIQUE_STATE_ACCOUNT -g tfstate-rg --sku Standard_LRS
az storage container create -n tfstate --account-name UNIQUE_STATE_ACCOUNT
```

### 2. Service connection

Name: **`azure-terraform`** (Azure Resource Manager). Needs Contributor.  
The Terraform tasks use this for **init** (`backendServiceArm`) and **plan/apply/destroy** (`environmentServiceNameAzureRM`).

### 3. Variable group `terraform-linux-vm`

| Variable | Example |
| -------- | ------- |
| `TF_BACKEND_RG` | `tfstate-rg` |
| `TF_BACKEND_STORAGE` | unique storage account name |
| `TF_BACKEND_CONTAINER` | `tfstate` |
| `TF_BACKEND_KEY` | `06-vm-linux.tfstate` |

### 4. Environment `linux-vm-apply`

Pipelines → Environments → add approval on yourself.

---

## Create pipeline in Azure DevOps

New pipeline → GitHub `sshabb697/terraform-course` → existing YAML → `/azure-pipelines.yml`.

To create the VM: Run → set **action = apply** → approve.

Destroy when finished: **action = destroy**. VM size is billed.

SSH user: `azureuser`. Private key is in Terraform state (sensitive).

---

## Error: listing Service Principals 403 (graphrbac)

`azurerm` **2.78.0** asks Azure AD Graph who the pipeline identity is. Most Azure DevOps service connections are not allowed to **list service principals** → 403.

This lab now pins **azurerm ~> 3.117**, which uses Microsoft Graph instead. Re-run the pipeline after pulling this change.

If you must stay on 2.x: Azure Portal → Entra ID → Roles → give the pipeline app **Directory Readers** (needs an admin). Upgrading the provider is the better fix.

