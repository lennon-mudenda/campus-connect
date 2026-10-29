# MCRI CampusConnect

SwiftUI debugging hackathon project.

## Getting started
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
