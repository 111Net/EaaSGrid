# EaaSGrid Platform API Documentation

Version: 1.0  
Environment: Development  
API Framework: Node.js + Express  
Database: Supabase PostgreSQL  

---

# 1. Overview

The EaaSGrid Platform API provides backend services for:

- Company information
- Investor information
- Platform data
- Database connectivity
- Future energy infrastructure services

The API acts as the integration layer between:
EaaSGrid Investor Portal
|
|
API Layer
|
|
Supabase Database

---

# 2. Base URL

Development:
http://localhost:4000/api/v1


Production:


https://api.eaasgrid.com/api/v1

---

# 3. Authentication

Current version:

Public API access


Authentication will be added in a future phase using:

- JWT authentication
- Role-based access control
- Investor portal authentication

---

# 4. Health Endpoint

## GET

Purpose:

Checks API availability.

Example:

```bash
curl http://localhost:4000/api/v1/health

Response:

{
    "status": "ok",
    "service": "eaasgrid-api"
5. Company Endpoint
GET
/company

Purpose:

Returns official EAASGrid company information.

Example:

curl http://localhost:4000/api/v1/company

Response:

{
    "id": "uuid",
    "company_name": "EAASGrid Platform Ltd",
    "parent_company": "IIMCICS Ltd",
    "country": "Nigeria",
    "platform": "Energy-as-a-Service (EaaS)",
    "vision": "To become Africa's leading intelligent energy and enterprise infrastructure platform.",
    "mission": "Deliver reliable distributed energy infrastructure through technology, automation and digital services.",
    "current_stage": "Investor Showcase and Technology Validation",
    "deployment": "Docker + Node.js + Supabase",
    "year_started": 2024
}
6. Investor Endpoint
GET
/investor

Purpose:

Returns investment information.

Example:

curl http://localhost:4000/api/v1/investor

Response:

{
    "company": "EAASGrid Platform Ltd",
    "project": "Energy-as-a-Service (EaaS) Platform",
    "stage": "Investor Showcase",
    "funding_required": {
        "currency": "NGN",
        "amount": 298000000
    },
    "business_model": [
        "Energy-as-a-Service",
        "Subscription Revenue",
        "Infrastructure Leasing",
        "Carbon Credits",
        "Energy Management Software"
    ],
    "target_markets": [
        "Commercial",
        "Industrial",
        "Government",
        "Healthcare",
        "Education"
    ]
}
7. Database Endpoint
GET
/database

Purpose:

Database connectivity test.

Example:

curl http://localhost:4000/api/v1/database

Response:

{
    "success": true,
    "rows": 1,
    "data": []
}
8. Error Handling

Unknown routes return JSON:

Example:

Request:

GET /invalid-route

Response:

{
    "success": false,
    "message": "Route /invalid-route not found"
}
9. HTTP Status Codes
Code	Meaning
200	Successful request
400	Bad request
401	Unauthorized
403	Forbidden
404	Resource not found
500	Internal server error
10. Current Technology Stack

Backend:

Node.js
Express.js
Supabase Client

Database:

Supabase PostgreSQL

Security:

CORS
Security Headers
Environment Validation
Error Middleware
11. Deployment Architecture

Current:

Developer Machine

        |
        |
   Express API

        |
        |
 Supabase Database

Target:

Investor Portal
        |
        |
 EaaSGrid API Server
        |
        |
 Supabase Cloud Database
        |
        |
 Energy Monitoring Platform
12. Future API Modules

Planned:

Customers
/customers
Energy Sites
/sites
Billing
/billing
Payments
/payments
Monitoring
/monitoring
IoT Devices
/devices
Document Control

Project:

EaaSGrid Platform

Company:

EAASGrid Platform Ltd

Parent:

IIMCICS Ltd

Last Updated:

July 2026

