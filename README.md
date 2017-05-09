# react-native-sdk-onboarding
App link: https://github.com/hypertrack/react-native-sdk-onboarding

# Install the SDK - 1

> **Compatibility**
> The module works with React Native 0.41.+

In your project directory, run the bash commands to install the React Native module and link it to your project files.

```bash
npm install react-native-hypertrack --save
react-native link react-native-hypertrack
```

# Install the SDK - 2
For the Android SDK, edit the `build.gradle` file in your app directory to add a custom repository address where the SDK is available.

* https://github.com/hypertrack/react-native-sdk-onboarding/blob/master/android/build.gradle
* L23-24

# Install the SDK - 3
Configure your publishable key and initialise the SDK in the `constructor` method of your Component class. This needs to be done only once in the app lifecycle.

* https://github.com/hypertrack/react-native-sdk-onboarding/blob/master/app/index.js
* L22-23

> **Account keys**
> Sign up to get account keys if you haven't already.

# Identify device
The SDK needs a **User** object to identify the device. The SDK has a convenience method `getOrCreateUser()` to lookup an existing user using a unique identifier (called `lookupId`) or create one if necessary.

Method parameters

* userName - Name of the user entity
* phone - Phone number of the user entity
* lookupId - Unique identifier for your user

Use this API in conjunction to your app's login flow, and call `getOrCreate` at the end of a successful login flow. This API is a network call, and needs to be done only once in the user session lifecycle.

> Waiting for your app to run

* https://github.com/hypertrack/react-native-sdk-onboarding/blob/master/app/index.js
* L29-32

# Start tracking
Use the `startTracking()` method to start tracking. Once the user starts tracking, you can see **Trips** and **Stops** of the user.

This is a non-blocking API call, and will also work when the device is offline. 

> Waiting for your app to run

* https://github.com/hypertrack/react-native-sdk-onboarding/blob/master/app/index.js
* L39-44

> **View on the dashboard**
> View the user's trips and stops here.

# Stop tracking
Use the `stopTracking()` method to stop tracking. This can be done when the user logs out.

* https://github.com/hypertrack/react-native-sdk-onboarding/blob/master/app/index.js
* L51-52

> **Ready to deploy!**
> Your React Native app is all set to be deployed. As your users update and log in, their live location will be visualized on this dashboard.

## Next steps
* Add team members to the HyperTrack dashboard
* Follow one of our use-case tutorials to build your live location feature
