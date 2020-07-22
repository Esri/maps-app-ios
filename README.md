# Maps App iOS

The [Maps App for iOS](https://developers.arcgis.com/example-apps/maps-app-ios/?utm_source=github&utm_medium=web&utm_campaign=example_apps_maps_app_ios) shows how a robust application can be built around the ArcGIS Platform using the [ArcGIS Runtime SDK for iOS](https://developers.arcgis.com/ios/) and Swift. It demonstrates best practices around some simple but key functionality of the ArcGIS Runtime. You can use the Maps App as is, or extend it to meet your specific needs.

![Maps App for iOS](/docs/images/app-screenshots.png)

<!-- MDTOC maxdepth:6 firsth1:0 numbering:0 flatten:0 bullets:1 updateOnSave:1 -->

- [Features](#features)   
- [Detailed Documentation](#detailed-documentation)   
- [Best Practices](#best-practices)   
- [Get Started](#get-started)   
   - [Fork the repo](#fork-the-repo)   
   - [Clone the repo](#clone-the-repo)   
      - [Command line Git](#command-line-git)   
   - [Configuring a Remote for a Fork](#configuring-a-remote-for-a-fork)   
   - [Configure the app](#configure-the-app)   
      - [1. Register an Application](#1-register-an-application)   
      - [2. Configuring the project](#2-configuring-the-project)   
      - [3. License the app for deployment](#3-license-the-app-for-deployment)   
- [Learn More](#learn-more)   
- [Requirements](#requirements)   
- [Contributing](#contributing)   
- [MDTOC](#mdtoc)   
- [Licensing](#licensing)   
   - [3rd Party Component Licensing](#3rd-party-component-licensing)   

<!-- /MDTOC -->
---

## Features
* Place Search
* Geocode addresses
* Reverse Geocode
* Turn-by-turn Directions
* Dynamically switch basemaps
* Open Web Maps
* Work with ArcGIS Online or an on-premise ArcGIS Portal
* OAuth authentication

## Detailed Documentation
Read the [docs](./docs/README.md) for a detailed explanation of the application, including its architecture and how it leverages the ArcGIS platform, as well as how you can begin using the app right away.

## Best Practices
The project also demonstrates some patterns for building real-world apps around the ArcGIS Runtime SDK.

* Defining a modular, decoupled UI that operates alongside a map view
* Asynchronous service and UI coding patterns
* Internal application communication patterns

## Get Started
You will need [Xcode](https://itunes.apple.com/us/app/xcode/id497799835?mt=12) and the [ArcGIS Runtime SDK](https://developers.arcgis.com/ios/latest/swift/guide/install.htm#ESRI_SECTION1_D57435A2BEBC4D29AFA3A4CAA722506A) (v100.1 or later) installed locally.

### Fork the repo
**Fork** the [Maps App](https://github.com/Esri/maps-app-ios/fork) repo

### Clone the repo
Once you have forked the repo, you can make a clone and open `maps-app-ios.xcodeproj` in Xcode.

#### Command line Git
1. [Clone the Maps App](https://help.github.com/articles/fork-a-repo/#step-2-create-a-local-clone-of-your-fork)
2. `cd` into the `maps-app-ios` folder
3. Make your changes and create a [pull request](https://help.github.com/articles/creating-a-pull-request)

### Configuring a Remote for a Fork
If you make changes in the fork and would like to [sync](https://help.github.com/articles/syncing-a-fork/) those changes with the upstream repository, you must first [configure the remote](https://help.github.com/articles/configuring-a-remote-for-a-fork/). This will be required when you have created local branches and would like to make a [pull request](https://help.github.com/articles/creating-a-pull-request) to your upstream branch.

1. In the Terminal (for Mac users) or command prompt (for Windows and Linux users) type `git remote -v` to list the current configured remote repo for your fork.
2. `git remote add upstream https://github.com/Esri/maps-app-ios.git` to specify new remote upstream repository that will be synced with the fork. You can type `git remote -v` to verify the new upstream.

If there are changes made in the Original repository, you can sync the fork to keep it updated with upstream repository.

1. In the terminal, change the current working directory to your local project
2. Type `git fetch upstream` to fetch the commits from the upstream repository
3. `git checkout master` to checkout your fork's local master branch.
4. `git merge upstream/master` to sync your local `master` branch with `upstream/master`. **Note**: Your local changes will be retained and your fork's master branch will be in sync with the upstream repository.

### Configure the app
The app can be run as is, but it's recommended you do some configuration to set up OAuth to be relevant to your users (certainly it should not be deployed without these changes):

1. Register an ArcGIS Portal Application.
2. Configure the Maps App project to reference that application.
3. License the app to remove the Developer Mode watermark.

#### 1. Register an Application
For OAuth configuration, create a new Application in your ArcGIS Portal to obtain a `Client ID` and configure a `Redirect URL`. The **Client ID** configures the ArcGIS Runtime to show your users, during the log in process, that the application was built by you and can be trusted. The **Redirect URL** configures the OAuth process to then return to your app once authentication is complete.

1. Log in to [https://developers.arcgis.com](https://developers.arcgis.com) with either your ArcGIS Organizational Account or an ArcGIS Developer Account.
2. Register a new Application. ![Register new application](/docs/images/create-application.png)
3. In the Authentication tab, note the **Client ID** and add a **Redirect URL**, e.g. `my-maps-app://auth`. We will use this URL in the **Configuring the project** section below. ![Configure new application](/docs/images/configure-application.png)

#### 2. Configuring the project

**Configure Redirect URL**

1. Open the project in Xcode and browse to the `maps-app-ios` target's `Info` panel and expand the `AGSConfiguration` dictionary (see steps 1-4 in the screenshot below).
2. Set the `AppURLScheme` value to match the **Redirect URL** scheme (the part *before* the `://`, e.g. `my-maps-app`) configured in "Register an Application" above. Note how the `AppURLScheme` and `AuthURLPath` combine to construct the **Redirect URL**. ![Configure the App URL Scheme](/docs/images/configure-xcode-url-scheme.png)
3. Expand the **URL Types** section and modify the existing entry.
    1. The **Identifier** doesn't matter, but should be unique (e.g. `com.my-org.my-maps-app`).
    2. The **URL Scheme** should match the **Redirect URL** scheme (the part *before* the `://`, e.g. `my-maps-app`) configured in "Register an Application" above.

**Configure Client ID**

1. In the Navigator pane, click to expand the group `maps-app-ios/Maps App` to reveal a file named `AppSettings.swift`.
2. Within `AppSettings.swift` set the value of the static variable `clientID` to the application's **Client ID** noted above.

![Configure the License Key](/docs/images/configure-app-settings.png)

#### 3. License the app for deployment
Remove the _Licensed for Developer Use Only_ watermark on the map view by setting the Runtime License Key.

This step is optional during development, but required for deployment.

1. Get your Runtime Lite License Key by clicking the `Show my ArcGIS Runtime Lite license key` at the top-right of the [Licensing Your ArcGIS Runtime App](https://developers.arcgis.com/arcgis-runtime/licensing/) page (you must be logged in).
2. Open the project in Xcode and navigate to `AppSettings.swift`, the same file used to configure your applications client id.
3. Set the value of the static variable `licenseKey` to the value from step 1.

## Learn More
Learn more about ArcGIS open source apps [here](https://developers.arcgis.com/example-apps).

## Requirements
* [Xcode](https://itunes.apple.com/us/app/xcode/id497799835?mt=12)
* [ArcGIS Runtime SDK for iOS](https://developers.arcgis.com/ios/)
* For directions and to browse Web Maps you will also need an ArcGIS Online Organizational account or an ArcGIS Online Developer account.

**Note:** Starting from the 100.8 release, the *ArcGIS Runtime SDK for iOS* uses Apple's [Metal](https://developer.apple.com/metal/) framework to render maps and scenes. In order to run your app in a simulator you must be developing on **macOS Catalina**, using **Xcode 11**, and simulating **iOS 13**.

## Contributing
Anyone and everyone is welcome to [contribute](CONTRIBUTING.md). We do accept pull requests.

1. Get involved
2. Report issues
3. Contribute code
4. Improve documentation

## MDTOC
Generation of this and other document's table of contents in this repository was performed using the [MDTOC package for Atom](https://atom.io/packages/atom-mdtoc).

## Licensing
Copyright 2017 Esri

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

A copy of the license is available in the repository's [LICENSE](LICENSE) file.

For information about licensing your deployed app, see [License your app](https://developers.arcgis.com/ios/latest/swift/guide/license-your-app.htm).

### 3rd Party Component Licensing
Some great open source components are available out there for iOS developers. The following have been used in this project, with much gratitude to their authors.
* [SVProgressHUD](https://github.com/SVProgressHUD/SVProgressHUD) is licensed under the MIT License.
* [FlexiblePageControl](https://github.com/shima11/FlexiblePageControl) is licensed under the MIT License.
