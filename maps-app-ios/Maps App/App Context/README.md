# AppContext

The AppContext is the central component of the app. It is a singleton instance created by the UIApplicationDelegate which is iOS's main application component.

There are multiple properties that track the state of the app, such as what the current Portal is, and whether the user is currently logged in.

It also provides methods and logic to log in and log out of the current portal. These methods can be called from the app's UI.

