# Google Cloud Platform Setup Guide

## Overview

This guide explains everything you need to do in **Google Cloud Platform (GCP) Console** before you can deploy the HealthCare Buy Plans application using GitHub Actions.

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Create GCP Project](#2-create-gcp-project)
3. [Enable Billing](#3-enable-billing)
4. [Create Service Account](#4-create-service-account)
5. [Download Service Account Key](#5-download-service-account-key)
6. [Add Secrets to GitHub](#6-add-secrets-to-github)
7. [Run GCP Initial Setup Workflow](#7-run-gcp-initial-setup-workflow)
8. [Verify Setup](#8-verify-setup)
9. [Cost Management](#9-cost-management)
10. [Cleanup When Done](#10-cleanup-when-done)
11. [Common Issues & Solutions](#11-common-issues--solutions)
12. [GCP Free Tier Limits](#12-gcp-free-tier-limits)

---

## 1. Prerequisites

Before starting, you need:

| Requirement | Details |
|-------------|---------|
| **Google Account** | Gmail or Google Workspace account |
| **Credit/Debit Card** | Required for GCP billing (free tier available) |
| **GitHub Account** | With access to the repository |
| **Web Browser** | Chrome recommended for GCP Console |

---

## 2. Create GCP Project

### 2.1 Go to GCP Console

Open: https://console.cloud.google.com

---

### 2.2 Create New Project

**Step 1:** Click on the project dropdown (top-left, next to "Google Cloud")

**Step 2:** Click **NEW PROJECT**

**Step 3:** Fill in project details:

| Field | Value | Notes |
|-------|-------|-------|
| **Project name** | `healthcare-buy-plans-app` | Choose a descriptive name |
| **Project ID** | `healthcare-buy-plans-app-123` | Auto-generated, can customize |
| **Organization** | (Leave default or select) | For personal accounts, leave blank |
| **Location** | (Leave default or select) | For personal accounts, leave blank |

**Step 4:** Click **CREATE**

**Step 5:** Wait for project creation (30-60 seconds)

**Step 6:** Select the new project from the dropdown

---

### 2.3 Note Your Project ID

Your **Project ID** is needed for GitHub secrets. Find it:

1. Click project dropdown (top-left)
2. Look at the **ID** column (not the Name)
3. Copy it (e.g., `healthcare-buy-plans-app-123`)

```
┌─────────────────────────────────────────────────────────────┐
│  Select a project                                           │
├─────────────────────────────────────────────────────────────┤
│  Name                        ID                             │
│  ─────────────────────────   ────────────────────────────   │
│  healthcare-buy-plans-app    healthcare-buy-plans-app-123   │
│                              ▲                              │
│                              │                              │
│                     Copy this Project ID                    │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Enable Billing

### 3.1 Why Billing is Required

Even though GCP has a free tier, you must enable billing to use Cloud Run, Artifact Registry, and other services.

**Good news:** 
- GCP offers **$300 free credits** for new accounts (90 days)
- Cloud Run has a generous free tier
- SQLite (used in this project) means no Cloud SQL costs

---

### 3.2 Enable Billing

**Step 1:** Go to **Billing** in the left menu (or search "Billing")

**Step 2:** Click **LINK A BILLING ACCOUNT**

**Step 3:** If you don't have a billing account:
- Click **CREATE BILLING ACCOUNT**
- Enter credit/debit card details
- Accept terms

**Step 4:** Link the billing account to your project

---

### 3.3 Set Budget Alert (Recommended)

To avoid unexpected charges:

**Step 1:** Go to **Billing** → **Budgets & alerts**

**Step 2:** Click **CREATE BUDGET**

**Step 3:** Configure:

| Field | Recommended Value |
|-------|-------------------|
| **Name** | `Healthcare App Budget` |
| **Projects** | Select your project |
| **Amount** | `$10` (or your comfort level) |
| **Alerts** | 50%, 90%, 100% |

**Step 4:** Click **FINISH**

---

## 4. Create Service Account

### 4.1 What is a Service Account?

A service account is like a "robot user" that GitHub Actions uses to deploy to GCP. It has specific permissions (roles) that control what it can do.

---

### 4.2 Create Service Account

**Step 1:** Go to **IAM & Admin** → **Service Accounts**

Or direct link: https://console.cloud.google.com/iam-admin/serviceaccounts

**Step 2:** Click **+ CREATE SERVICE ACCOUNT**

**Step 3:** Fill in details:

| Field | Value |
|-------|-------|
| **Service account name** | `healthcare-buy-plans-github-sa` |
| **Service account ID** | `healthcare-buy-plans-github-sa` (auto-filled) |
| **Description** | `Service account for GitHub Actions to deploy Healthcare App` |

**Step 4:** Click **CREATE AND CONTINUE**

---

### 4.3 Grant Roles (Permissions)

On the "Grant this service account access to project" screen, add these roles:

**Click "+ ADD ANOTHER ROLE"** for each role:

| Role | Purpose |
|------|---------|
| **Cloud Run Admin** | Deploy and manage Cloud Run services |
| **Storage Admin** | Read/write to Cloud Storage |
| **Artifact Registry Administrator** | Create repos, push/pull Docker images |
| **Service Account User** | Use service accounts |
| **Cloud SQL Admin** | Create/manage Cloud SQL instances |
| **Cloud SQL Client** | Connect to Cloud SQL databases |
| **Secret Manager Admin** | Create/manage secrets |
| **Service Usage Admin** | Enable/disable APIs |

```
┌─────────────────────────────────────────────────────────────┐
│  Grant this service account access to project               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Role: Cloud Run Admin                                  ✕   │
│  + ADD ANOTHER ROLE                                         │
│                                                             │
│  Role: Storage Admin                                    ✕   │
│  + ADD ANOTHER ROLE                                         │
│                                                             │
│  Role: Artifact Registry Administrator                  ✕   │
│  + ADD ANOTHER ROLE                                         │
│                                                             │
│  Role: Service Account User                             ✕   │
│  + ADD ANOTHER ROLE                                         │
│                                                             │
│  Role: Cloud SQL Admin                                  ✕   │
│  + ADD ANOTHER ROLE                                         │
│                                                             │
│  Role: Cloud SQL Client                                 ✕   │
│  + ADD ANOTHER ROLE                                         │
│                                                             │
│  Role: Secret Manager Admin                             ✕   │
│  + ADD ANOTHER ROLE                                         │
│                                                             │
│  Role: Service Usage Admin                              ✕   │
│                                                             │
│  [CONTINUE]                                                 │
└─────────────────────────────────────────────────────────────┘
```

**Step 5:** Click **CONTINUE**

**Step 6:** Skip "Grant users access" section (optional)

**Step 7:** Click **DONE**

---

## 5. Download Service Account Key

### 5.1 Create JSON Key

**Step 1:** In the Service Accounts list, find your service account:
`healthcare-buy-plans-github-sa@{project-id}.iam.gserviceaccount.com`

**Step 2:** Click on the service account name to open details

**Step 3:** Click **KEYS** tab

**Step 4:** Click **ADD KEY** → **Create new key**

**Step 5:** Select **JSON**

**Step 6:** Click **CREATE**

**Step 7:** The JSON file downloads automatically - **save it securely!**

---

### 5.2 Important Security Notes

⚠️ **DO NOT:**
- Share this file with anyone
- Commit it to Git
- Post it online
- Store it in public locations

✅ **DO:**
- Save it in a secure location
- Delete it after adding to GitHub Secrets
- Create a new key if compromised

---

## 6. Add Secrets to GitHub

### 6.1 Open GitHub Secrets

**Step 1:** Go to your GitHub repository

**Step 2:** Click **Settings** (tab at the top)

**Step 3:** Click **Secrets and variables** → **Actions** (left sidebar)

**Step 4:** Click **New repository secret**

---

### 6.2 Add GCP_PROJECT_ID

| Field | Value |
|-------|-------|
| **Name** | `GCP_PROJECT_ID` |
| **Secret** | Your project ID (e.g., `healthcare-buy-plans-app-123`) |

Click **Add secret**

---

### 6.3 Add GCP_SA_KEY

**Step 1:** Open the downloaded JSON file in a text editor

**Step 2:** Select ALL the content (Ctrl+A / Cmd+A)

**Step 3:** Copy it (Ctrl+C / Cmd+C)

**Step 4:** In GitHub:

| Field | Value |
|-------|-------|
| **Name** | `GCP_SA_KEY` |
| **Secret** | Paste the entire JSON content |

Click **Add secret**

---

### 6.4 Verify Secrets

Your repository secrets should show:

```
┌─────────────────────────────────────────────────────────────┐
│  Repository secrets                                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  GCP_PROJECT_ID          Updated 1 minute ago               │
│  GCP_SA_KEY              Updated 1 minute ago               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 7. Run GCP Initial Setup Workflow

### 7.1 What This Does

The GCP Initial Setup workflow:
1. Enables required GCP APIs
2. Creates Artifact Registry repository
3. (Optional) Creates Cloud SQL instances
4. (Optional) Creates Secret Manager secrets

---

### 7.2 Run the Workflow

**Step 1:** Go to GitHub repository → **Actions** tab

**Step 2:** Click **GCP Initial Setup** (left sidebar)

**Step 3:** Click **Run workflow**

**Step 4:** Select options:

| Option | Recommended |
|--------|-------------|
| **Branch** | `main` |
| **Select setup to run** | `all (Complete Setup)` |

**Step 5:** Click **Run workflow**

**Step 6:** Wait for completion (2-5 minutes)

---

### 7.3 Expected Output

```
==========================================
✅ GCP Initial Setup Complete!
==========================================

Project ID: healthcare-buy-plans-app-123
Region: asia-south1
Setup Type: all (Complete Setup)

----------------------------------------
Resources Created/Verified:
----------------------------------------

📦 Artifact Registry:
NAME               FORMAT
healthcare-plans   DOCKER

🗄️  Cloud SQL Instances:
(none - using SQLite for workshop)

🔐 Secrets:
NAME
healthcare-plans-dev-django-secret-key
healthcare-plans-dev-db-password
...
```

---

## 8. Verify Setup

### 8.1 Check APIs are Enabled

**Step 1:** Go to **APIs & Services** → **Enabled APIs & services**

**Step 2:** Verify these APIs are listed:
- ✅ Artifact Registry API
- ✅ Cloud Run Admin API
- ✅ Cloud SQL Admin API
- ✅ Secret Manager API

---

### 8.2 Check Artifact Registry

**Step 1:** Go to **Artifact Registry**

Or: https://console.cloud.google.com/artifacts

**Step 2:** Verify `healthcare-plans` repository exists in `asia-south1`

---

### 8.3 Now You Can Deploy!

After verification, you can run:
1. **Deploy Django Backend** workflow
2. **Deploy Angular Frontend** workflow

---

## 9. Cost Management

### 9.1 What Costs Money?

| Service | Free Tier | Paid After |
|---------|-----------|------------|
| **Cloud Run** | 2 million requests/month | $0.00002400/request |
| **Cloud Run** | 360,000 GB-seconds/month | $0.00002400/GB-second |
| **Artifact Registry** | 0.5 GB storage | $0.10/GB/month |
| **Cloud SQL** | None (use SQLite) | ~$7/month minimum |
| **Secret Manager** | 6 active secrets | $0.06/secret/month |

---

### 9.2 Cost-Saving Tips

| Tip | Savings |
|-----|---------|
| **Use SQLite instead of Cloud SQL** | ~$7-50/month saved |
| **Set min_instances=0** | No cost when idle |
| **Delete unused environments** | Full cost of that environment |
| **Use destroy workflow when done** | All costs stopped |

---

### 9.3 Monitor Costs

**Step 1:** Go to **Billing** → **Reports**

**Step 2:** Filter by project and date range

**Step 3:** View cost breakdown by service

---

## 10. Cleanup When Done

### 10.1 Using Destroy Workflow (Recommended)

**Step 1:** Go to GitHub repository → **Actions**

**Step 2:** Click **GCP Destroy All Resources**

**Step 3:** Click **Run workflow**

**Step 4:** Select options:

| Option | Value |
|--------|-------|
| **Select what to destroy** | `all (DESTROY EVERYTHING)` |
| **Select environment** | `all` |
| **Type "DESTROY" to confirm** | `DESTROY` |

**Step 5:** Click **Run workflow**

---

### 10.2 Manual Cleanup (Alternative)

If workflows aren't working, delete manually:

**Delete Cloud Run Services:**
1. Go to **Cloud Run**
2. Select all services
3. Click **DELETE**

**Delete Artifact Registry:**
1. Go to **Artifact Registry**
2. Click on `healthcare-plans`
3. Click **DELETE REPOSITORY**

**Delete Secrets:**
1. Go to **Secret Manager**
2. Select all secrets starting with `healthcare-plans-`
3. Click **DELETE**

---

### 10.3 Delete Entire Project (Nuclear Option)

If you want to delete everything and never use GCP again for this:

**Step 1:** Go to **IAM & Admin** → **Manage Resources**

**Step 2:** Select your project

**Step 3:** Click **DELETE**

**Step 4:** Enter project ID to confirm

⚠️ **Warning:** This is irreversible and deletes all resources!

---

## 11. Common Issues & Solutions

### 11.1 "Permission Denied" Errors

**Symptom:**
```
IAM_PERMISSION_DENIED
```

**Solution:**
- Go to IAM → Find your service account
- Add missing role
- Wait 1-2 minutes for propagation

---

### 11.2 "API Not Enabled" Errors

**Symptom:**
```
API has not been used in project xxx before or it is disabled
```

**Solution:**
1. Click the link in the error message
2. Click **ENABLE**
3. Wait 1-2 minutes
4. Re-run the workflow

---

### 11.3 "Billing Not Enabled" Errors

**Symptom:**
```
Billing must be enabled for activation of service
```

**Solution:**
- Go to Billing
- Link a billing account to your project
- See Section 3

---

### 11.4 "Quota Exceeded" Errors

**Symptom:**
```
Quota exceeded for resource
```

**Solution:**
- This usually means free tier exceeded
- Check Billing → Reports for details
- Either pay or wait for quota reset

---

### 11.5 Service Account Key Issues

**Symptom:**
```
Could not find default credentials
```

**Solution:**
- Verify `GCP_SA_KEY` secret in GitHub
- Make sure entire JSON was pasted
- Create a new key if needed

---

## 12. GCP Free Tier Limits

### 12.1 Always Free Products

These products have free quotas that don't expire:

| Product | Free Tier Limit |
|---------|-----------------|
| **Cloud Run** | 2 million requests/month |
| **Cloud Run** | 360,000 GB-seconds of compute/month |
| **Cloud Run** | 180,000 vCPU-seconds of compute/month |
| **Artifact Registry** | 0.5 GB storage/month |
| **Cloud Build** | 120 build-minutes/day |
| **Secret Manager** | 6 active secrets |

---

### 12.2 $300 Free Credits (New Users)

New GCP users get:
- **$300** in free credits
- Valid for **90 days**
- Can be used on any service
- Great for learning and testing

---

### 12.3 Estimated Costs for This Project

If you stay within free tier:

| Scenario | Estimated Monthly Cost |
|----------|----------------------|
| **Development (low traffic)** | $0 |
| **Workshop demo (1 day)** | $0 |
| **Continuous usage with SQLite** | $0-5 |
| **With Cloud SQL (PostgreSQL)** | $10-50 |
| **Production traffic** | $20-100+ |

---

## Quick Reference Checklist

### Initial Setup (Do Once)

- [ ] Create GCP Project
- [ ] Enable Billing
- [ ] Create Service Account
- [ ] Add 8 roles to Service Account
- [ ] Download JSON key
- [ ] Add `GCP_PROJECT_ID` to GitHub Secrets
- [ ] Add `GCP_SA_KEY` to GitHub Secrets
- [ ] Run "GCP Initial Setup" workflow

### Deploy Application

- [ ] Run "Deploy Django Backend" workflow
- [ ] Run "Deploy Angular Frontend" workflow
- [ ] Test the application

### Cleanup (When Done)

- [ ] Run "GCP Destroy All Resources" workflow
- [ ] Verify resources deleted in GCP Console
- [ ] (Optional) Delete GCP project entirely

---

## GCP Console Quick Links

| Service | URL |
|---------|-----|
| **Console Home** | https://console.cloud.google.com |
| **Project Selector** | https://console.cloud.google.com/projectselector |
| **IAM & Admin** | https://console.cloud.google.com/iam-admin |
| **Service Accounts** | https://console.cloud.google.com/iam-admin/serviceaccounts |
| **APIs & Services** | https://console.cloud.google.com/apis |
| **Cloud Run** | https://console.cloud.google.com/run |
| **Artifact Registry** | https://console.cloud.google.com/artifacts |
| **Secret Manager** | https://console.cloud.google.com/security/secret-manager |
| **Billing** | https://console.cloud.google.com/billing |

---

*Last Updated: December 2025*
