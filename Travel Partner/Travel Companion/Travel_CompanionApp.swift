//
//  Travel_CompanionApp.swift
//  Travel Companion
//
//  Created by Spencer Goldberg on 6/30/22.
//

import SwiftUI
import Firebase
import FBSDKLoginKit
import GoogleSignIn
import UIKit
import UserNotifications
import FirebaseMessaging
import Combine
import FirebaseAppCheck


@main
struct YourApp: App {
    let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
  // register app delegate for Firebase setup
    @AppStorage ("stopProfileNotification") var stopProfileNotification = false
    @State var showVerifyEmail = false
    @AppStorage ("stopEmailNotification") var stopEmailNotification = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    typealias User = Guest
    @State var showProfilePic = false
    
    @AppStorage("onboardingDone") var onboardingDone = false
    @Environment(\.scenePhase) var scenePhase

    @StateObject var authenticationManager = AuthenticationManager<User>()
    @State private var currentTab = 0
    
    @State private var tappedTwice: Bool = false

    @State private var rootView = UUID()
    
    var handler: Binding<Int> { Binding(
            get: { self.currentTab },
            set: {
                if $0 == self.currentTab {
                    // Lands here if user tapped more than once
                    tappedTwice = true
                }
                self.currentTab = $0
            }
    )}
    
    
@State private var bag: [AnyCancellable] = []

  var body: some Scene {
      WindowGroup {
          ZStack {
              
              ZStack {
                  if authenticationManager.isLaunching {
                      Image("splash_screen")
                          .resizable()
                          .scaledToFill()
                          .position(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
                          .edgesIgnoringSafeArea(.all)
                  }
                  else if authenticationManager.isLoading {
                     
                  }
              }
              .zIndex(.greatestFiniteMagnitude)
              .animation(.easeInOut(duration: 0.3))
              
              // If the user is not onboarded, then show the onboarding. Uses the @AppStorage property which acts like user defaults
              // If they are onboarded, their preferences are not nil, and the createOrJoinTableVM exists, then show the main tabs of the app
             if let guest = authenticationManager.user {
                 
                  TabView(selection: handler) {
                     Text("1")
                          .tag(0)
                          .tabItem {
                              Label {
                                  Text("Tables")
                              } icon: {
                                  if #available(iOS 15.0, *) {
                                      Image(systemName: "fork.knife")
//                                            .removeFill()
                                  } else {
                                      Image("table_tab_icon")
                                          .renderingMode(.template)
                                  }
                              }
                          }
                      NavigationView {
                          Text("2")
                      }
                      .tabItem {
                          Label("Friends", systemImage: "person.2")
//                                .removeFill()
                      }
                      .accentColor(Constants.Colors.navigationBarAccentColor)
                      .navigationViewStyle(StackNavigationViewStyle())
                      .tag(1)
                      NavigationView {
                         Text("3")
                              
                      }
                      .tabItem {
                          Label("Share", systemImage: "square.and.arrow.up")
//                                .removeFill()
                      }
                      .accentColor(Constants.Colors.navigationBarAccentColor)
                      .navigationViewStyle(StackNavigationViewStyle())
                      .tag(2)
                      
                      
                      NavigationView {
                         Text("4")
                              .id("4")
                      }
                      .tabItem {
                          Label("e-Tip", systemImage: "banknote")
                      }
                      .accentColor(Constants.Colors.navigationBarAccentColor)
                      .navigationViewStyle(StackNavigationViewStyle())
                      .tag(3)

                      
                      NavigationView {
                          Text("5")
                              .onChange(of: tappedTwice, perform: { tappedTwice in
                                  guard tappedTwice else { return }
                                  rootView = UUID()
                                  self.tappedTwice = false
                              })
                             
                      }
                      .accentColor(Constants.Colors.navigationBarAccentColor)
                      .navigationViewStyle(StackNavigationViewStyle())
                      .tag(4)
                      .tabItem {
                          Label {
                              Text("Profile")
                          } icon: {
                              if #available(iOS 15.0, *) {
                                  Image(systemName: "person.text.rectangle")
                              } else {
                                  Image(systemName: "person.crop.rectangle")
                                      .renderingMode(.template)
                                  
                              }
                          }
                      }
                  }
                  .accentColor(Constants.Colors.navigationBarAccentColor)
//                    .overlay(
//                        CBGTabBar(
//                            selectedIndex: $currentTab,
//                            tabs: [
//                                .init(title: "Table", image: Image("table_tab_icon"), badgeValue: nil),
//                                .init(title: "Notifications", image: Image(systemName: "bell"), badgeValue: notificationCount == 0 ? nil : "\(notificationCount)"),
//                                .init(title: "Share App", image: Image(systemName: "square.and.arrow.up"), badgeValue: nil),
//                                .init(title: "Profile", image: Image(systemName: "person"), badgeValue: nil)
//                            ],
//                            barTintColor: Constants.Colors.tabBar,
//                            tintColor: Constants.Colors.tabBarAccent,
//                            unselectedItemTintColor: Constants.Colors.tabBarUnselected
//                        ), alignment: .bottom)
//                        .ignoresSafeArea(.keyboard, edges: .bottom)
                  .onAppear {
//                        Utils.configureTabBar(with: Constants.Colors.tabBar, unselectedColor: Constants.Colors.tabBarUnselected)
//                        friendsVM.guest = guest
                    
                      Utils.requestNotificationAuthorization { granted in
                          if granted {
                              print("The user who logged in granted push notification authorization")
                          } else {
                              print("The user who logged in did not grant push notification authorization")
                          }
                      }
                      // If a user logs out of the app and then logs back in, we will reset the state of the initial screen back to default
                      currentTab = 0
                      
                  }
              }
              // If they aren't authenticated, show the social registration view
              else {
                  NavigationView {
                      //WelcomeView<User>()
                      AuthenticationMainView<User>()
                  }
                  .navigationViewStyle(StackNavigationViewStyle())
                  .accentColor(Constants.Colors.navigationBarAccentColor)
              }
              
          }
          .environmentObject(quickActionSettings)
          
          // for phone auth
          .onOpenURL { url in
              print("Received URL: \(url)")
              Auth.auth().canHandle(url)
          }
          .onAppear {
              /// Observe the authenticated user for existence of profile picture
              authenticationManager
                  .$user
                  .compactMap { $0 }
                  .sink { user  in
                      /// Everytime the app is launched, check if the Guest has set their profile picture.
                      if user.photoURL == nil && !stopProfileNotification {
                          self.showProfilePic = true
                          user.schedulePictureReminderNotification(isGuest: true)
                      }
                      else {
                          /// If a Guest has their profile picture set, cancel any pending notifications that may be queued up to be sent.
                          let current = UNUserNotificationCenter.current()
                          current.removePendingNotificationRequests(withIdentifiers: ["pictureSet"])
                      }
                  }
                  .store(in: &bag)
                  
          }
          .preferredColorScheme(.light)
      }
  }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    @Published private(set) var notificationToken: String? = nil
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        if let shortcutItem = options.shortcutItem {
            shortcutItemToProcess = shortcutItem
        }
        
        let sceneConfiguration = UISceneConfiguration(name: "Custom Configuration", sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = CustomSceneDelegate.self
        
        return sceneConfiguration
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // get current number of times app has been launched
        var currentCount = UserDefaults.standard.integer(forKey: "launchCount")
        // increment received number by one
        UserDefaults.standard.set(currentCount+1, forKey:"launchCount")
        print("App Launch Count: ", currentCount)
        
        // Configuring the firebase app should be called in app delegate and before configuring the messaging delegate
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)

        
        FirebaseApp.configure()
        
        //MARK: - Initilize Functions Emulator here
//        let settings = Firestore.firestore().settings
//        settings.host = "localhost:4000"
//        settings.isPersistenceEnabled = false
//        settings.isSSLEnabled = false
//        Firestore.firestore().settings = settings
//
//        try? Auth.auth().signOut()
//
//        Auth.auth().useEmulator(withHost: "localhost", port: 9099)
//        Firestore.firestore().useEmulator(withHost: "localhost", port: 8080)

        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        UserDefaults.standard.register(defaults: [
            "play_sound": true,
            "allow_haptic": true,
            "isOnboardingDone": false
        ])
        
        application.registerForRemoteNotifications()
        
        // Configuring the actionable notifications
        // Must be performed on app launch
        let acceptFriendRequestAction = UNNotificationAction(identifier: "ACCEPT_REQUEST", title: "Accept", options: .foreground)
        let denyFriendRequestAction = UNNotificationAction(identifier: "DENY_REQUEST", title: "Deny", options: .destructive)
        let friendRequestCategory = UNNotificationCategory(
            identifier: "FRIEND_REQUEST",
            actions: [acceptFriendRequestAction, denyFriendRequestAction],
            intentIdentifiers: [],
            options: .customDismissAction
        )
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([friendRequestCategory])
        
        /* Firebase keeps users logged in even after reinstalling
         * the app. If the user is still signed in after they launch
         * the app for the first time after reinstalling, then we
         * log out them out.
         */
        if Auth.auth().currentUser != nil, !UserDefaults.getUserDefaultAsBool(forKey: .isNotFirstRun) {
            GIDSignIn.sharedInstance().signOut()
            try? Auth.auth().signOut()
            UserDefaults.setUserDefault(true, forKey: .isNotFirstRun)
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        // For phone auth
        Auth.auth().setAPNSToken(deviceToken, type: .unknown)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification notification: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      print("\(#function)")
        if Auth.auth().canHandleNotification(notification) {
            completionHandler(.noData)
            return
        }
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      print("\(#function)")
        if Auth.auth().canHandle(url) {
            return true
        }
        return false
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("\(#file): \(#function)")
        
        // Get notification categroy from JSON payload
        let category = response.notification.request.content.categoryIdentifier
        
        // Get JSON payload from response
        let payload = response.notification.request.content.userInfo
        
        switch category {
        case "FRIEND_REQUEST":
            let friendshipId = payload["friendshipId"] as! String
            let friendshipRef = Firestore.firestore().collection("friendships").document(friendshipId)
            
            switch response.actionIdentifier {
            case "ACCEPT_REQUEST":
                friendshipRef.updateData(["isPending": false])
                
            case "DENY_REQUEST":
                friendshipRef.delete()
                
            default:
                break
            }
            
        default:
            break
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("\(#file): \(#function)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        print("\(#file): \(#function)")
    }
    
}


extension AppDelegate: MessagingDelegate {
    
    // Once the FCM token is received, then we set the published property notificationToken
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        notificationToken = fcmToken
    }
    
}
