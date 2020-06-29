# SoundCloud Player

### General
iOS-client for listening and storage music from SoundCloud. User need to login with their login/password (using OAuth2), and can watch their library from SoundCloud, search all tracks from SoundCloud, listening tracks (also in background application mode), and save favorite music on the device for listening without internet connection.

### Technology stack
Language - Swift 5. IDE - Xcode 11.5.  
Minimum supported iOS version - 13.4.  
OAuth2 token storage - Keychain  
Local storage for music - Core Data + File Manager  
Technology stack for music playing - AVPlayer, system Media Player  
Using frameworks - [SwiftLint](https://github.com/realm/SwiftLint), [Alamofire](https://github.com/Alamofire/Alamofire)  
Has been tested - on device (iPhone X) and simulators (iPhone SE,iPhone 11 Pro Max, iPad 12.9, iPad 9.7)

### Project structure

**Applcation architectures** - VIPER (for Login module), MVP (for Track List and Cached Tracks modules), Clean Swift (for Player).  
**Application based on:** TabBarController with two screens: track list and cached tracks. Also available screen for player with ability to roll up it on top of tab bar.  
**Application modules:** Login screen; Track list and cached tracks screens based on Table View and Navigation Controller with search bar; Player screen based on View Controller with player buttons and animation for rolling up.  
**Work with storages:** Downloaded tracks saves on the device using Core Data and File Manager. Database has entity for track, which include links to the audio and image files on the device application folder and another meta information.  
____

### Application Demo


![](https://imgur.com/cxU4hc2.png)
