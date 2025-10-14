# 🧑‍💼 RMA Agent Profile Website

![RMA Agent Profile Preview](./img/preview.png)

[![GitHub Pages](https://img.shields.io/badge/Deployed-GitHub%20Pages-blue?logo=github)](https://theekingza.github.io/RMA_agent/)
[![Built with](https://img.shields.io/badge/Built%20with-HTML%20%7C%20CSS%20%7C%20JavaScript-orange)](#)
[![License](https://img.shields.io/badge/License-Open--Source-green)](#license)

A responsive, professional **agent profile website** for RMA (Rand Mutual Assurance) agents — built using **HTML**, **CSS**, and **JavaScript** with a **fully automated deploy script** for GitHub Pages.  

---

## 🚀 Features

- 🎨 **Responsive design** — Works smoothly on desktop and mobile  
- 🧾 **Agent Profile** — Displays name, contact info, and photo  
- 💼 **What We Offer** — List of cover benefits  
- 💡 **Value-Added Services** — Optional extras displayed in a styled card  
- ✉️ **Get a Quote** button (opens email to the agent)  
- ⚙️ **Deployment Automation** via `deploy.sh`  
- 🟢 **Colored console messages** for success/error handling  
- 🌀 **Smooth fade-in animations** with `animation.js`

---

## 🗂 Project Structure
```
RMA_agent/
│
├── index.html # main webpage
├── theme.css # site theme and layout styling
├── animation.js # fade-in animations and JS interactions
├── deploy.sh # deploys & syncs gh-pages with master
└── README.md # project documentation
```

---

## ⚙️ Setup & Usage

### 1️⃣ Clone the repository
```
bash

git clone https://github.com/TheeKingZa/RMA_agent.git
cd RMA_agent

```

2️⃣ Open locally
Simply open index.html in your web browser to view the website.

3️⃣ Customize Agent Info
Edit the following placeholders in index.html:
```
<h1 id="agent-name">AGENT_NAME</h1>
<li><strong>Agent No:</strong> AGENT_NUMBER</li>
<li><strong>Email:</strong> AGENT_EMAIL</li>
<li><strong>Phone:</strong> AGENT_PHONE</li>
<img src="agent.jpg" alt="Agent photo" />
```

Then replace agent.jpg with your own image file.

🧰 Requirements
Git installed

GitHub account

(Optional) VS Code or any text editor

🚀 Deployment to GitHub Pages
The repo includes a deployment script: deploy.sh.
It automatically checks if both master and gh-pages branches exist, keeps them in sync, and pushes updates for GitHub Pages hosting.

🧩 Initialize once

```
git init
git add .
git commit -m "Initial commit"
git branch -M master
git remote add origin https://github.com/TheeKingZa/RMA_agent.git
git push -u origin master

```
🔁 Deploy anytime

```
./deploy.sh
```

This will:

Check if master and gh-pages exist

Create them if missing

Merge master into gh-pages

Push updates to GitHub

Switch you back to master

🌐 Publish via GitHub Pages
Go to Repository → Settings → Pages

Under Source, choose:

Branch: gh-pages

Folder: / (root)

Click Save

Your live site will be available shortly at:

(Website)[https://theekingza.github.io/RMA_agent/]

```
Script Details (deploy.sh)
The deploy.sh script:

Ensures repo is initialized

Checks if master and gh-pages exist

Merges changes automatically

Pushes updates to remote

Displays colored messages for clarity
```

Example Output:

```
🔍 Checking branches...
✅ Found 'master' branch.
✅ Found 'gh-pages' branch.
🌿 Switching to gh-pages...
🔁 Merging master into gh-pages...
⬆️  Pushing gh-pages to remote...
✅ Deployment complete! gh-pages is now synced with master.
```


© 2025 Pule Mathikha  
RMA Agent Profile Website — Built with ❤️ using HTML, CSS, and JS.

👨‍💻 Author
Pule Mathikha
📧 contactcentre@randmutual.co.za (RMA)[mailto:contactcenter@randmutual.co.za]
💻 GitHub: (TheeKingZa)[https://github.com/TheeKingZa]
📍 Sasolburg, South Africa

🧡 Credits
Built and designed by Pule Mathikha
for RMA Agent Services
with a focus on simplicity, automation, and accessibility.



