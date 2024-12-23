# TechnicalTaskLvl2
Technical task Lvl 2

# Ship Management App
## Overview
This iOS app simulates a login and ship management system. It includes email validation, offline mode handling, CoreData integration, and API data synchronization with a reactive approach using Combine.

## Features
### Login Screen

- Basic email validation and simulated login process with a 2-3 seconds delay.
- Displays a loading process with success or failure.

### Ship List Screen

- Displays ships sorted by name.
- Allows deleting ships from the list.
- Fetches ships from the API when the screen is opened or "pull to refresh" is used.

### Ship Information Modal

- Displays ship details in a modal view.

### Offline Mode

- Shows a banner with “No internet connection. You’re in Offline mode” on screens when there is no internet connection.
- Updates from the API are fetched when the connection is restored and execute "pull to refresh"

## Architecture

- CoreData for persistent storage.
- Combine for reactive programming.
- UIKit for the app’s UI.
- iOS 15.0+ targeted.


## Installation:

1. Clone the repository
2. Open the project
3. Build (Cmd + B) and run (Cmd + R) the app
4. App behavior
- On launch, the app will navigate to the login screen.
- Enter a valid email to simulate a login process (with a 2-3 seconds delay).
- Once logged in, you will be directed to the second screen, where the ships are displayed (fetched from CoreData or the API).
- The app will handle offline mode by showing a banner if the internet is unavailable.

## email and password:
email: test@gmail.com
password: password
