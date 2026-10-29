# Codex Build Specification: MCRI CampusConnect

## Current delivery scope

The project owner requested completing the local application before Supabase integration. For this milestone, the Supabase backend, SDK dependency, schema, persistent remote data and production authorization requirements are deferred. The local repository protocol remains the boundary for a future backend. Application data is held in memory; lightweight discovery preferences use UserDefaults. All other feature and challenge requirements apply.

## 1. Project Objective

Build a complete, visually polished iOS application using SwiftUI that intentionally contains **35 logical bugs** distributed across its features.

The application must compile, launch, and support realistic end-to-end user interactions.

The purpose is to create a debugging challenge where students must discover and fix defects in an unfamiliar application.

**Important:** The application must not appear deliberately broken. Most features should work under normal conditions, with bugs becoming apparent when users perform particular actions, encounter edge cases, or examine the business logic.

## 2. Technology Requirements

- **Language:** Swift
- **UI framework:** SwiftUI
- **Architecture:** MVVM
- **Backend:** Supabase, with a local mock-data mode
- **Persistence:** UserDefaults for lightweight local preferences; Supabase for persistent application data
- **Minimum iOS version:** iOS 17
- **Dependencies:** Supabase Swift SDK where applicable
- **Development environment:** Xcode

The application must work without Supabase credentials by using a local mock repository containing realistic seed data. This allows students to run and debug the application immediately.

Use protocols to separate data access from business logic so the same application can run with either mock data or Supabase.

## 3. Application Features

### 3.1 Authentication and Profiles

Users should be able to sign in using demo accounts and access a personalized dashboard.

Support two roles:

- Student
- Facilitator

Each profile should contain a name, email address, role, participation points, and registered activities.

### 3.2 Event Discovery

Display upcoming MCRI activities including:

- Coding workshops
- Hackathons
- Mentorship sessions
- Technical talks
- Team challenges
- Community activities

Each event should have a title, description, date, time, location, category, capacity, available places, and participation points.

Users should be able to search, filter, sort, and inspect events.

### 3.3 Event Registration

Students should be able to register for events, cancel registrations, and view their registered activities.

Events should enforce capacity restrictions and registration deadlines.

### 3.4 Attendance and Check-In

Students should be able to check in to events for which they are registered.

Facilitators should be able to view attendance records.

### 3.5 Participation Points and Leaderboard

Students earn points for attending activities.

The application should display individual point totals, participation history, and a leaderboard.

### 3.6 Facilitator Event Management

Facilitators should be able to create, edit, and cancel events, review registrations, and view attendance summaries.

### 3.7 Dashboard and Analytics

Provide students with an overview of their upcoming events, completed activities, and participation points.

Provide facilitators with event statistics and attendance summaries.

## 4. Interface Requirements

Create a modern, professional SwiftUI interface with consistent colors, typography, reusable components, and smooth navigation.

Use a bottom tab bar with:

1. Home
2. Explore
3. My Events
4. Leaderboard
5. Profile

Facilitators should have access to additional event management screens.

Include loading states, empty states, confirmation dialogs, alerts, and realistic sample content.

The application should contain enough data to make searching, filtering, pagination, registration, attendance, and leaderboard behavior meaningful.

## 5. Confidential Logical Bug Injection Specification

Implement the following **35 intentional bugs**.

Each bug must have a reproducible trigger and an observable incorrect outcome.

Do not create compilation errors, crashes, missing dependencies, or deliberately unfinished screens.

### Category A: Authentication and Profiles

**BUG-01: Incorrect Email Validation**

- Intended behavior: Accept valid email addresses, including those containing `+` in the local part.
- Injected behavior: Reject otherwise valid addresses containing `+`.
- Example: `student+test@mcri.edu` is rejected.

**BUG-02: Incorrect Profile Completion**

- Intended behavior: A profile is complete when all required fields contain valid values.
- Injected behavior: The profile is considered complete when only the name and email are provided, even if another required field is missing.

**BUG-03: Incorrect Role-Based Navigation**

- Intended behavior: Facilitator-only management screens are visible only to facilitators.
- Injected behavior: A student who switches from a facilitator demo account can still see the facilitator management tab until the application restarts.
- Do not expose actual protected Supabase data or weaken server-side authorization.

**BUG-04: Incorrect Profile Update**

- Intended behavior: Editing a profile updates only the selected fields.
- Injected behavior: Changing a student's display name also resets their locally displayed participation points to zero.

### Category B: Event Discovery

**BUG-05: Case-Sensitive Search**

- Intended behavior: Searching for `swift` should find an event named `Swift Fundamentals`.
- Injected behavior: Search results require exact letter casing.

**BUG-06: Incorrect Category Filter**

- Intended behavior: Selecting Workshops displays only workshop events.
- Injected behavior: Selecting Workshops also displays Hackathons.

**BUG-07: Incorrect Date Sorting**

- Intended behavior: Sorting by Soonest First displays events in ascending chronological order.
- Injected behavior: Events are displayed from latest to earliest.

**BUG-08: Incorrect Available Places**

- Intended behavior: Available places equal capacity minus active registrations.
- Injected behavior: Cancelled registrations are still counted as occupied places.

**BUG-09: Incorrect Upcoming Events Filter**

- Intended behavior: Upcoming events include all events whose start times are in the future.
- Injected behavior: Events occurring later today are excluded.

**BUG-10: Incorrect Search Reset**

- Intended behavior: Clearing a search restores all events matching the current filters.
- Injected behavior: Clearing the search restores only the results from the previous search.

### Category C: Registration

**BUG-11: Duplicate Registration**

- Intended behavior: A student can have only one active registration per event.
- Injected behavior: Tapping Register twice quickly creates two registrations in mock mode.

**BUG-12: Incorrect Capacity Boundary**

- Intended behavior: Registration is allowed while active registrations are less than capacity.
- Injected behavior: Registration is rejected when the final place is still available.

**BUG-13: Incorrect Cancellation**

- Intended behavior: Cancelling a registration removes it from the student's active registrations.
- Injected behavior: The registration remains visible in My Events as active.

**BUG-14: Registration Deadline Error**

- Intended behavior: Registration closes at the event's configured registration deadline.
- Injected behavior: Registration closes exactly 24 hours before the event starts, regardless of its configured deadline.

**BUG-15: Incorrect Registration Counter**

- Intended behavior: Registration totals reflect the current number of active registrations.
- Injected behavior: Cancelling a registration increases the displayed number of registrations.

**BUG-16: Incorrect My Events Sorting**

- Intended behavior: Registered events are sorted chronologically.
- Injected behavior: Events are sorted alphabetically by title.

### Category D: Attendance and Check-In

**BUG-17: Early Check-In**

- Intended behavior: Check-in opens 15 minutes before the event starts.
- Injected behavior: Check-in opens 60 minutes before the event starts.

**BUG-18: Duplicate Attendance**

- Intended behavior: Each student can check in only once per event.
- Injected behavior: Repeated check-ins create duplicate attendance records in mock mode.

**BUG-19: Incorrect Attendance Percentage**

- Intended behavior: Attendance percentage equals unique checked-in students divided by active registered students, multiplied by 100.
- Injected behavior: The percentage is calculated using total event capacity as the denominator.

**BUG-20: Cancelled Student Can Check In**

- Intended behavior: Students with cancelled registrations cannot check in.
- Injected behavior: The check-in screen checks whether a registration record exists without verifying its active status.

**BUG-21: Incorrect Attendance Status**

- Intended behavior: Students who checked in are marked Present.
- Injected behavior: Students who checked in after the event's scheduled start time are marked Absent.

### Category E: Participation Points

**BUG-22: Points Awarded on Registration**

- Intended behavior: Participation points are awarded only after valid attendance is recorded.
- Injected behavior: Points are awarded immediately after event registration.

**BUG-23: Duplicate Points**

- Intended behavior: Points for an event can be awarded only once per student.
- Injected behavior: Repeated attendance processing adds points multiple times.

**BUG-24: Incorrect Point Calculation**

- Intended behavior: An event worth 50 points awards exactly 50 points.
- Injected behavior: The calculation awards 10 fewer points than configured.

**BUG-25: Incorrect Leaderboard Ordering**

- Intended behavior: Students with the highest point totals appear first.
- Injected behavior: Students are sorted from lowest to highest points.

**BUG-26: Incorrect Leaderboard Rank**

- Intended behavior: Rankings begin at position 1.
- Injected behavior: Rankings begin at position 0.

### Category F: Facilitator Management

**BUG-27: Incorrect Event Editing**

- Intended behavior: Updating an event changes only the selected event.
- Injected behavior: Editing an event's location also updates the location of other events in the same category in mock mode.

**BUG-28: Incorrect Event Capacity Validation**

- Intended behavior: Event capacity must be a positive integer.
- Injected behavior: The event creation form accepts zero as a valid capacity.

**BUG-29: Incorrect Event Cancellation**

- Intended behavior: Cancelled events should no longer accept registrations.
- Injected behavior: Students can still register for cancelled events.

**BUG-30: Incorrect Facilitator Event Count**

- Intended behavior: The facilitator dashboard displays the number of events managed by the logged-in facilitator.
- Injected behavior: It displays the total number of events belonging to all facilitators.

### Category G: Dashboard and Analytics

**BUG-31: Incorrect Upcoming Event Count**

- Intended behavior: The dashboard counts future events with active registrations.
- Injected behavior: Cancelled registrations are included in the upcoming event count.

**BUG-32: Incorrect Completion Rate**

- Intended behavior: Completion rate equals attended events divided by completed registered events, multiplied by 100.
- Injected behavior: The calculation performs integer division before converting the result to a percentage.

**BUG-33: Incorrect Date Grouping**

- Intended behavior: Activity history groups events by their actual calendar dates.
- Injected behavior: Events close to midnight are grouped using UTC rather than the user's local calendar date.

**BUG-34: Incorrect Dashboard Refresh**

- Intended behavior: The dashboard refreshes its statistics after a successful registration or cancellation.
- Injected behavior: Statistics remain unchanged until the user navigates away and returns.

**BUG-35: Incorrect Monthly Activity Summary**

- Intended behavior: The monthly summary includes only activities from the selected calendar month and year.
- Injected behavior: It includes activities from the same month across every year.

## 6. Bug Distribution and Difficulty

| Category | Bugs | Difficulty |
|---|---:|---|
| Authentication and Profiles | 4 | Easy–Medium |
| Event Discovery | 6 | Easy |
| Registration | 6 | Easy–Medium |
| Attendance | 5 | Medium |
| Participation Points | 5 | Easy |
| Facilitator Management | 4 | Medium |
| Dashboard and Analytics | 5 | Easy–Medium |
| **Total** | **35** | |

Target difficulty distribution:

- **15 easy bugs:** Discoverable through ordinary application use.
- **15 medium bugs:** Require testing specific conditions or examining business logic.
- **5 slightly challenging bugs:** Require understanding state management, date handling, or data relationships.

No bug should require advanced reverse engineering or extensive knowledge of obscure Swift APIs.

## 7. Architecture and Code Organization

Use a maintainable MVVM architecture with separate directories for:

- `App/`
- `Models/`
- `Views/`
- `ViewModels/`
- `Services/`
- `Repositories/`
- `Components/`
- `Utilities/`
- `Resources/`

Organize application logic into appropriate services, such as:

- AuthenticationService
- EventService
- RegistrationService
- AttendanceService
- PointsService
- AnalyticsService

Place the intentional bugs naturally within the relevant application logic.

Do not place all defects in one file.

Do not deliberately introduce poor naming, unreadable code, or unnecessary architectural complexity to make debugging difficult.

## 8. Seed Data

Create realistic local data containing at least:

- 20 students
- 3 facilitators
- 25 events
- 50 registrations
- 20 attendance records
- Multiple event categories
- Events with different capacities
- Past, current, and future events
- Cancelled registrations
- Cancelled events
- Students with different participation scores

Use deterministic seed data so the same test scenarios can be reproduced.

Include demo login credentials in the README.

Provide a reset-demo-data action so students can restore the original state after experimenting.

The application must support testing date-sensitive bugs through a configurable clock or deterministic test dates, rather than requiring students to wait for a real event.

## 9. Bug Injection Rules

Follow these requirements strictly:

1. All 35 bugs must be implemented as actual logical defects in executable application code.
2. Do not simulate bugs by displaying random error messages.
3. Do not introduce compilation errors.
4. Do not deliberately crash the application.
5. Do not leave buttons or screens unimplemented.
6. Do not use TODO comments or suspicious variable names that reveal the bugs.
7. Do not include comments such as `// intentional bug`, `// BUG-12`, or `// incorrect logic`.
8. Most application workflows must behave normally until a specific trigger is encountered.
9. Each bug must be independently reproducible.
10. Fixing one bug should not automatically fix several unrelated bugs.
11. Bugs must remain consistent across repeated tests.
12. Avoid security vulnerabilities, exposed secrets, and destructive database behavior.
13. Where bugs involve duplicate records or incorrect permissions, keep those defects within mock-mode business logic and UI behavior; production Supabase constraints and RLS must remain secure.

## 10. Confidential Answer Key

Generate a separate file at:

`instructor/BUG_ANSWER_KEY.md`

For each of the 35 bugs, document:

- Bug ID
- Feature affected
- File and function containing the bug
- Intended behavior
- Actual behavior
- Steps to reproduce
- Root cause
- Suggested correction
- Difficulty level

Also generate:

`instructor/BUG_VERIFICATION.md`

This file must contain a reproducible verification scenario for every bug, including expected correct behavior and observed faulty behavior.

These documents are for hackathon organizers only.

**Do not expose the instructor directory to participants.**

## 11. Testing Requirements

Create an instructor-only verification test suite that confirms all 35 defects are present.

Each test should assert the intended correct behavior and therefore fail against the deliberately buggy implementation.

The tests must be deterministic and should not depend on external network availability.

A defect is considered successfully injected only when:

- Its faulty behavior is present in the running application.
- The relevant verification test detects it.
- The bug can be traced to a specific implementation error.
- The application continues to function normally outside the affected scenario.

Separate these tests from ordinary build and smoke tests.

The normal project should compile and pass smoke tests. The instructor verification suite is expected to fail until the bugs are fixed.

## 12. Deliverables

Generate the following:

1. A complete Xcode project using SwiftUI.
2. A functional application containing all specified screens and workflows.
3. A mock-data mode that works without Supabase credentials.
4. A Supabase schema and integration layer for optional backend use.
5. Realistic seed data and demo accounts.
6. A README explaining setup, demo accounts, and how to run the application.
7. Instructor-only bug answer key.
8. Instructor-only bug verification guide.
9. Instructor-only automated verification tests.

The student-facing README must describe the application's purpose and setup instructions without revealing the number, locations, or nature of the bugs.

## 13. Final Quality Requirements

Before completing the project:

- Verify that the Xcode project is structurally complete.
- Build the application when an appropriate Apple development environment is available.
- Verify that every screen is reachable.
- Confirm that normal navigation works.
- Confirm that demo accounts and mock data are functional.
- Verify each of the 35 intentional defects individually.
- Confirm that the application remains usable despite the defects.
- Ensure no instructor-only material is included in the student distribution.

If Xcode or an iOS simulator is unavailable, do not claim that compilation or runtime verification succeeded. Report which checks were performed and which still require an Apple development environment.

## 14. Expected Final Result

The completed application should feel like a realistic student activity management product that a development team has handed over for maintenance.

Students should initially be able to browse events, navigate between screens, inspect profiles, and interact with the application normally.

As they explore further, they should discover incorrect calculations, inconsistent state updates, unexpected filtering behavior, registration mistakes, attendance discrepancies, and other logical defects.

**The goal is to assess the students' ability to identify, explain, reproduce, and correct software defects—not their ability to recognize intentionally obvious mistakes.**

The final product must be a complete debugging challenge, not a collection of disconnected bug demonstrations.
