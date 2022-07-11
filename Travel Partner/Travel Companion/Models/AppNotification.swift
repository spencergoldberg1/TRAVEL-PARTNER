import FirebaseFirestoreSwift
import Firebase
import SwiftUI
import UIKit

protocol AcknowledgeableNotification: AppNotification {
    var acknowledgedAt: Timestamp? { get set }
    var cancelled: Bool { get set }
    func acknowledge(serverId: String, completionHandler: @escaping () -> ()) throws
    func cancel(serverId: String) throws
    static func acknowledge(in notificationId: String, for serverId: String)
}

/// Protocol that defines a notificaiton that can appear in a list
protocol ReadableNotification: AppNotification {
    var isRead: Bool { get set }
    var title: String { get }
    var tableId: String { get }
    var description: String { get }
    var imageURL: URL? { get }
    func markRead(guestId: String) throws
}

protocol DialogNotification: AppNotification {
    associatedtype Dialog: View
    
    /// If the notifcation has been viewed by the user
    var isViewed: Bool { get set }
    /// The id of the table
    var tableId: String { get }

    /// Presents the dialog
    func present(dialog: Dialog)
    /// Mark as viewed for a `DialogNotification` object
    func markViewed(userId: String) throws
}

extension ReadableNotification {
    func markRead(guestId: String) throws {
        guard let id = self.id else { return }
        
        isRead = true
        
        let ref = db
            .collection(Guest.resourceName)
            .document(guestId)
            .collection(AppNotification.resourceName)
            .document(id)
        
        
        try? ref.setData(from: self, merge: true)
    }
    
    func uploadServerNotification(serverId: String, completion: @escaping (Error?) -> Void = { _ in }) {
        let ref = db
            .collection(Server.resourceName)
            .document(serverId)
            .collection(Self.resourceName)
            .document()
        
        try? ref.setData(from: self, merge: false) { error in
            completion(error)
        }
    }
    
    func uploadGuestNotification(guestId: String, completion: @escaping (Error?) -> Void = { _ in }) {
        let ref = db
            .collection(Guest.resourceName)
            .document(guestId)
            .collection(Self.resourceName)
            .document()
        
        try? ref.setData(from: self, merge: false) { error in
            completion(error)
        }
    }
}

extension DialogNotification {
    func present(dialog: Dialog) {
        // Fetch the root window scene
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        
        // Get the root window scene's viewcontroller
        var presentingVC = windowScene?.windows.first?.rootViewController
        
        // Get the vc to present over. If a modal is already being
        // presented over the root vc then present the modal on the
        // already presented modal. This allows for multiple modals to
        // be presented at once.
        while presentingVC?.presentedViewController != nil {
            presentingVC = presentingVC?.presentedViewController
        }
        
        // Now present the modal
        presentingVC?.present(
            style: .overCurrentContext,
            transitionStyle: .coverVertical,
            builder: { dialog }
        )
    }
    
    func markViewed(userId: String) throws {
        guard let id = self.id else { return }

        isViewed = true
        
        // TODO: Develop a way to separate dialog notifications without compiler directives
        #if IS_GUEST
        let ref = db
            .collection(Guest.resourceName)
            .document(userId)
            .collection(AppNotification.resourceName)
            .document(id)
        #else
        let ref = db
            .collection(Server.resourceName)
            .document(userId)
            .collection(AppNotification.resourceName)
            .document(id)
        #endif
        
        
        try? ref.setData(from: self, merge: true)
    }
}


extension AcknowledgeableNotification {
    func acknowledge(serverId: String, completionHandler: @escaping () -> () = {}) throws {
        guard let id = self.id else { return }
        
        let ref = db
            .collection(Server.resourceName)
            .document(serverId)
            .collection(AppNotification.resourceName)
            .document(id)
        
        ref.updateData([
            :
        ]) { error in
            if error == nil {
                completionHandler()
            }
        }
    }
    
    func cancel(serverId: String) throws {
        guard let id = self.id else { return }
        
        cancelled = true
        
        let ref = db
            .collection(Server.resourceName)
            .document(serverId)
            .collection(AppNotification.resourceName)
            .document(id)
        
        try? ref.setData(from: self, merge: true)
    }

}
