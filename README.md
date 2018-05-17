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
## Getting Started Android 

1. Upgrade compileSdkVersion, buildToolsVersion, support library version
For the Android SDK, edit the `build.gradle` file in your `android/app` directory 
* https://github.com/hypertrack/react-native-sdk-onboarding/blob/master/android/app/build.gradle
* L86, L87, L131

    ```groovy
    android {
        compileSdkVersion 26
        buildToolsVersion "26.0.3"
        ...
    }
    ```

    ```groovy
    dependencies {
        ...
        compile project(':react-native-hypertrack')
        compile fileTree(dir: "libs", include: ["*.jar"])
        compile "com.android.support:appcompat-v7:26.1.0"
        compile "com.facebook.react:react-native:+"  // From node_modules
        ...
    }
    ```

2. Adds maven dependency for Google Libraries
For the Android SDK, edit the `build.gradle` file in your `android` directory 

    ```groovy
    // Top-level build file where you can add configuration options common to all sub-projects/modules.
    buildscript {
        repositories {
            jcenter()
            maven {
                url 'https://maven.google.com/'
                name 'Google'
            }
        }
        dependencies {
            classpath 'com.android.tools.build:gradle:3.0.1'
            classpath 'com.google.gms:google-services:3.1.0'

            // NOTE: Do not place your application dependencies here; they belong
            // in the individual module build.gradle files
        }
    }

    allprojects {
        repositories {
            mavenLocal()
            jcenter()
            maven {
                // All of React Native (JS, Obj-C sources, Android binaries) is installed from npm
                url "$rootDir/../node_modules/react-native/android"
            }
            maven {
                url 'https://maven.google.com/'
                name 'Google'
            }
        }
    }
    ```

# Install the SDK - 3
Configure your publishable key and initialise the SDK in the `constructor` method of your Component class. This needs to be done only once in the app lifecycle.

* https://github.com/hypertrack/react-native-sdk-onboarding/blob/master/app/index.js
* L31-32

> **Account keys**
> [Sign up](https://www.hypertrack.com/signup) to get account keys if you haven't already.

# Identify device
The SDK needs a **User** object to identify the device. The SDK has a convenience method `getOrCreateUser()` to lookup an existing user using a unique identifier (called `uniqueId`) or create one if necessary.

Method parameters

* userName - Name of the user entity
* phone - Phone number of the user entity
* uniqueId - Unique identifier for your user

Use this API in conjunction to your app's login flow, and call `getOrCreate` at the end of a successful login flow. This API is a network call, and needs to be done only once in the user session lifecycle.

> Waiting for your app to run

* https://github.com/hypertrack/react-native-sdk-onboarding/blob/master/app/index.js
* L61-68

# Create an Action
Create and assign an Action object to the user. The createAction method accepts a js dictionary object with expected_place_id, type, unique_id and expected_at keys.

* https://github.com/hypertrack/react-native-sdk-onboarding/blob/master/app/index.js
* L119-131

> **View on the dashboard**
> View the user's trips and stops here.

> **Ready to deploy!**
> Your React Native app is all set to be deployed. As your users update and log in, their live location will be visualized on this dashboard.

## Next steps
* Add team members to the HyperTrack dashboard
* Follow one of our use-case tutorials to build your live location feature
