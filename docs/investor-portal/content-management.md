# EaaSGrid Investor Portal Content Management Guide


## Overview

The EaaSGrid Investor Portal uses a modular section-based content
architecture.

Each major website section is maintained as an independent React
component.

This allows content updates without affecting the complete application.


---

# Content Location

Main application:


---

# Section Management


## Hero Section

File:

Purpose:

Controls the opening investor message.

Contains:

- Main headline
- Company positioning
- Pilot statistics
- Key investment figures


---

## Problem Section

File:


Purpose:

Explains the energy infrastructure challenge.

Update:

- Market challenges
- Customer pain points
- Industry statistics


---

## Solution Section

File:

Purpose:

Explains the EaaSGrid Energy-as-a-Service model.

Contains:

- Infrastructure deployment
- Digital monitoring
- Subscription model
- Operations management


---

## Business Model Section

File:

Purpose:

Explains revenue generation.

Contains:

- Energy subscription revenue
- Infrastructure leasing
- Digital platform revenue
- Sustainability opportunities


---

## Market Section

File:

Purpose:

Defines target markets.

Current sectors:

- Commercial
- Industrial
- Healthcare
- Education
- Government infrastructure


---

## Financial Section

File:

Purpose:

Investor financial information.

Current information:

- Pilot programme
- ₦298 Million capital requirement
- Six-site deployment
- Expansion strategy
- Revenue streams


---

## Roadmap Section

File:

Purpose:

Deployment phases.

Future updates:

- Pilot completion
- Deployment milestones
- Regional expansion


---

## Contact Section

File:

Purpose:

Investor and partnership engagement.

Contains:

- Investor relations
- Partnership opportunities
- Business development


---

# Update Process

After content changes:


## 1. Run validation

python3 tools/release/validate.py

## 2. Test production build

python3 tools/release/build.py

## 3. Create release package

python3 tools/release/package.py

## 4. Generate release report

python3 tools/release/report.py

or run complete release:

python3 tools/release/release.py

---

# Content Change Rules

Before updating:

- Preserve existing component structure
- Maintain investor-focused messaging
- Avoid unsupported financial claims
- Keep figures consistent across sections
- Test the website after changes


---

# Version Control

All changes should be committed with a clear message.

Example:
All changes should be committed with a clear message.

Example:

git add .
git commit -m "Update investor portal financial messaging"


---

## Current Portal Version

EaaSGrid Investor Portal v2.3 RC1

Status:

Release Candidate
