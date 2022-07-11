//
//  FirstTimeUserFlowViewModel.swift
//  Shared
//
//  Copyright © 2021 Cocobolo Group. All rights reserved.
//

import SwiftUI
import CoreLocation
import Combine
import FirebaseAuth

protocol FirstTimeUserFlowViewModelProtocol: ObservableObject {
    associatedtype Slide: RawRepresentable & CaseIterable & Equatable where Slide.RawValue == String
    associatedtype User: UserRepresentable
    
    var user: User { get set }
    var currentSlide: Slide { get set }
    var slides: [Slide] { get set }
    var nextSlide: Void { get }
    var prevSlide: Void { get }
    var firstName: String { get set }
    var lastName: String { get set }
    var birthDate: String { get set }
}

protocol FirstTimeUserFlowView: View {
    associatedtype Slide: RawRepresentable & CaseIterable where Slide.RawValue == String
    associatedtype VM: FirstTimeUserFlowViewModelProtocol
}

class FirstTimeUserFlowViewModel<Slide, User>: FirstTimeUserFlowViewModelProtocol where Slide: RawRepresentable & CaseIterable & Equatable, Slide.RawValue == String, User: UserRepresentable {
    
    
    // MARK: - Private Properties
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private let locationManager = CLLocationManager()
    private var bag = Set<AnyCancellable>()
    
    // MARK: - Public properties
    
    @Published var user: User
    @Published var originalImage: UIImage?
    @Published var image: Image?
    @Published var currentSlide: Slide = .init(rawValue: "getStarted")!
    @Published var isSaving: Bool = false
    @Published var circleNum: Int = 0
    var slides: [Slide]
    
    init(user: User) {
        self.user = user
        self.slides = Slide.allCases.map { $0 }
        
        if user.photoURL != nil {
            removeSlide(rawValue: "profilePic")
        }
        
        if user.firstName != nil, user.lastName != nil {
            removeSlide(rawValue: "name")
        }
        
        if slides.contains(where: { $0.rawValue == "notification" }) {
            notificationCenter.getNotificationSettings { [weak self] permission in
                if permission.authorizationStatus == .authorized {
                    self?.removeSlide(rawValue: "notification")
                }
            }
        }
        
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            removeSlide(rawValue: "location")
            
        default:
            break
        }
        
        // if its a social sign in then we remove the profile pic slide
        if let authProvider = Auth.auth().currentUser?.providerData.first?.providerID {
            if !(authProvider == "password" || authProvider == "phone") {
                if let index = slides.firstIndex(where: { $0.rawValue == "profilePic" }) {
                    self.slides.remove(at: index)
                }
            }
        }
        
    }
    
    // MARK: Computed Properties
    
    var nextSlide: Void {
        guard currentSlide != slides.last, let index = slides.firstIndex(of: currentSlide) else {
            save()
            return
        }
        
        withAnimation {
            currentSlide = slides[index.advanced(by: 1)]
        }
    }
    
    var prevSlide: Void {
        guard currentSlide != slides.first else { return }
        guard let index = slides.firstIndex(of: currentSlide) else { return }
        
        withAnimation {
            currentSlide = slides[index.advanced(by: -1)]
        }
    }
    
    var firstName: String {
        get {
            user.firstName ?? ""
        }
        set {
            user.firstName = newValue
        }
    }
    
    var lastName: String {
        get {
            user.lastName ?? ""
        }
        set {
            user.lastName = newValue
        }
    }
    
    var birthDate: String {
        get {
            user.birthDate ?? ""
        }
        set {
            user.birthDate = newValue
        }
    }
    
    // MARK: - Methods
    
    func save(_ completion: @escaping () -> Void = {}) {
        withAnimation {
            isSaving = true
        }
        
        var newUser = user
        newUser.isNewUser = false
        
        if image != nil {
            savePhoto {
                newUser.upsert { [weak self] _ in
                    withAnimation(.easeInOut) {
                        self?.isSaving = false
                        self?.user.isNewUser = false
                    }
                    try? SoundsAndHaptics.playVibration(type: .success)
                    completion()
                }
            }
        }
        else {
            newUser.upsert { [weak self] _ in
                withAnimation(.easeInOut) {
                    self?.isSaving = false
                    self?.user.isNewUser = false
                }
                try? SoundsAndHaptics.playVibration(type: .success)
                completion()
            }
        }
    }
    
    func requestNotificationAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] allowed, error  in
            guard !allowed else {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                    self?.nextSlide
                }
                return
            }
            
            if let bundle = Bundle.main.bundleIdentifier,
               let appSettings = URL(string: UIApplication.openSettingsURLString + bundle) {
                DispatchQueue.main.async { [weak self] in
                    UIApplication.shared.open(appSettings) { [weak self] _ in
                        self?.nextSlide
                    }
                }
            }
            else {
                self?.nextSlide
            }
        }
    }
    
    func requestLocationPermissions() {
        switch locationManager.authorizationStatus {
        case .denied, .restricted:
            if let bundle = Bundle.main.bundleIdentifier,
               let appSettings = URL(string: UIApplication.openSettingsURLString + bundle) {
                UIApplication.shared.open(appSettings)
            }
            
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func savePhoto(_ completion: @escaping () -> Void) {
        if let originalImage = originalImage {
            saveImage(image: originalImage) { url in
                if let url = url {
                    self.user.photoURL = url
                    completion()
                }
            }
        }
    }
    
    private func removeSlide(rawValue: String) {
        guard let index = slides.firstIndex(where: { $0.rawValue == rawValue }) else {
            // Sanity check. Only thrown on simulator
            assertionFailure("Could not find slide with rawValue: \(rawValue)")
            return
        }
        
        slides.remove(at: index)
    }
}
