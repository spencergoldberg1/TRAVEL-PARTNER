import Foundation.NSURL
import Firebase

protocol UserRepresentable: FireBaseRepresentable, LocationRepresentable {
    var firstName: String? { get set }
    var lastName: String? { get set }
    var photoURL: URL? { get set }
    var email: String? { get }
    var phoneNumber: String? { get }
    var isEmailVerified: Bool { get }
    var location: Location? { get set }
    var birthDate: String? { get set }
    var isNewUser: Bool? { get set }
    var isDisabled: Bool? { get }
    
    init?(firebaseUser: Firebase.User?)
    init(id: String, isEmailVerified: Bool, firstName: String?, lastName: String?, email: String?, phoneNumber: String?, photoURL: URL?, location: Location?)
}

extension UserRepresentable {
    
    func add(notificationToken: String) {
        guard let id = self.id else { return }
        let ref = db.collection(Self.resourceName).document(id)
        ref.updateData([
            "notificationTokens": FieldValue.arrayUnion([notificationToken])
        ])
    }
    
    var displayName: String? {
        guard let firstName = firstName else { return nil }
        
        return "\(firstName)"
    }
    
    var firstAndLastInitialName: String? {
        guard let firstName = firstName else { return nil }
        guard let lastName = lastName?.prefix(1) else { return firstName }
        
        return "\(firstName) \(lastName)."
    }
    
    var fullName: String? {
        guard let firstName = firstName else { return nil }
        guard let lastName = lastName else { return firstName }
        
        return "\(firstName) \(lastName)"
    }
    
    /// Local notification will be sent to Server via Notificaton Center to remind them to upload a picture for their profile if they do not have one set
    func schedulePictureReminderNotification(isGuest: Bool) {
        
        let content = UNMutableNotificationContent()
        content.title = "Upload Your Picture!"
        content.body = isGuest ? "Profiles with pictures help your waiter to know who you are." : "Profiles with pictures get better tips."
        content.sound = UNNotificationSound.default
        
        /// Local Notification will be sent to Server every Friday at 5pm local time unless they set up a profile picture.
        var date = DateComponents()
        date.calendar = Calendar.current
        date.weekday = 6
        date.hour = 17
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        let identifier = "pictureSet"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    func scheduleEmailVerificationNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "Please Verify Your Email"
        content.body = "Verify your email address using the link sent to your inbox."
        content.sound = UNNotificationSound.default
        
        /// Local Notification will be sent to Server every Wednesday at 5pm local time unless they verify thier email.
        var date = DateComponents()
        date.calendar = Calendar.current
        date.weekday = 4
        date.hour = 17
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        let identifier = "verifyEmail"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func isGuest() -> Bool {
        Self.resourceName == "guests"
    }

}
//
//extension String {
//    subscript(i: Int) -> String {
//        return String(self[index(startIndex, offsetBy: i)])
//    }
//}
