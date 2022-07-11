import SwiftUI

protocol SocialRegistrationViewModelProtocol {
    var viewTitle: String { get }
    var introductionContent: [(imageName: String, title: String)] { get }
    
    var backgroundColor: Color { get }
    var textColor: Color { get }
}
