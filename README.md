# Z-Doc — Enterprise Document Management Platform (Client)

Flutter client for the Z-Doc enterprise document platform, enabling 
teams to upload, categorize, search, and securely share documents 
via a Spring Boot REST API backend.

## 🎯 Problem
Manual document handoffs between team members caused delays and 
version confusion. Z-Doc replaces this with a permission-based, 
searchable, centralized document workflow.

## 🏗️ Architecture
- **Frontend:** Flutter (Dart) — cross-platform (Mobile + Web)
- **Backend:** Spring Boot REST API (separate repo)
- **Deployment:** Docker + Nginx + Kubernetes
- **CI/CD:** Jenkins pipeline → DockerHub

## ✨ Features
- Document upload & categorization
- Indexed full-text search
- Permission-based sharing & access control
- Team collaboration workflow
