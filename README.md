# MCRI CampusConnect

SwiftUI debugging hackathon project.

## Getting started

### 1. Clone the starter project

Each student must work in their own GitHub repository. Clone the starter project, then remove its remote before making changes:

```sh
git clone https://github.com/lennon-mudenda/campus-connect.git
cd campus-connect
git remote remove origin
```

Removing `origin` disconnects your local copy from the starter repository while preserving the code and commit history.

### 2. Create your own GitHub repository

Sign in to your GitHub account and create a new repository, for example `campus-connect-challenge`. Leave it empty: do not add a README, license, or `.gitignore`, because the cloned project already contains files and history.

### 3. Connect and push to your repository

Replace `YOUR_USERNAME` and `YOUR_REPOSITORY` below with your GitHub username and the repository name you just created:

```sh
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
git branch -M main
git remote -v
```

Check that both the fetch and push URLs point to **your own GitHub repository**, then upload the project:

```sh
git push -u origin main
```

Complete this setup before starting the challenge. Commit and push all subsequent work to your repository so each student's changes stay independent and the original starter project is unaffected:

```sh
git add .
git commit -m "Describe your changes"
git push
```

### 4. Run the app

Open `CampusConnect.xcodeproj` in Xcode 15 or later, select an iOS 17+ simulator, and Run. No API keys or backend setup are required.

## Demo accounts
Use Profile → Demo account to switch between `student1@mcri.edu` through `student20@mcri.edu` and `facilitator1@mcri.edu` through `facilitator3@mcri.edu`. No password is needed in local demo mode.

## Features
Browse activities, filter and search events, register, cancel, check in, view rankings, and manage events as a facilitator. Reset demo data from Profile.

## Challenge
Investigate and repair unexpected application behavior. Explain each issue, its reproduction steps, and your fix.

## Local demo behavior
All application data is held in memory. Reset demo data restores the original dataset; restarting the app also restores it. The discovery sort preference is saved on this device. No network connection or backend credentials are needed.

Profile includes a demo clock. The seed calendar is fixed at 29 October 2026; change the clock to explore registration deadlines and attendance windows, then restore it with **Restore demo clock**. Resetting data preserves the selected clock so scenarios can be repeated.

Facilitators can open Manage → an event → Registrations and attendance to inspect participation. Profile → Participation history provides activity history and a month/year summary.
