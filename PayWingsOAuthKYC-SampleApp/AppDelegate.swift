//
//  AppDelegate.swift
//  PayWingsKYC-SampleApp
//
//  Created by Tjasa Jan on 29/08/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        AppData.destroy()
        registerDefaultsFromSettingsBundle()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


    func registerDefaultsFromSettingsBundle() {
        let settingsName                    = "Settings"
        let settingsExtension               = "bundle"
        let settingsRootPlist               = "Root.plist"
        let settingsPreferencesItems        = "PreferenceSpecifiers"
        let settingsPreferenceKey           = "Key"
        let settingsPreferenceDefaultValue  = "DefaultValue"

        guard let settingsBundleURL = Bundle.main.url(forResource: settingsName, withExtension: settingsExtension),
            let settingsData = try? Data(contentsOf: settingsBundleURL.appendingPathComponent(settingsRootPlist)),
            let settingsPlist = try? PropertyListSerialization.propertyList(
                from: settingsData,
                options: [],
                format: nil) as? [String: Any],
            let settingsPreferences = settingsPlist[settingsPreferencesItems] as? [[String: Any]] else {
                return
        }

        var defaultsToRegister = [String: Any]()

        settingsPreferences.forEach { preference in
            if let key = preference[settingsPreferenceKey] as? String {
                defaultsToRegister[key] = preference[settingsPreferenceDefaultValue]
            }
        }

        UserDefaults.standard.register(defaults: defaultsToRegister)
    }
    
}

