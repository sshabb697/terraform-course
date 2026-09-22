# Azure DevOps — create this Linux VM

Pipeline file (repo root): `azure-pipelines.yml`

| Parameter `action` | Result |
| ------------------ | ------ |
| `plan` (default) | fmt / init / validate / plan — **no VM** |
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

Values are passed into `backend.tf` (`backend "azurerm" {}`) by the pipeline.

### 2. Service connection

Name: **`azure-terraform`** (Azure Resource Manager). Needs Contributor.

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

SSH user: `azureuser`. Private key is in Terraform state (sensitive). Do not paste it into chat or logs.

If apply fails on image or public IP, see notes in the devops2026 course copy: `Terraform-5-Day-Course/pipelines/linux-vm/README.md`.
