import Combine

struct SignUpViewModelAlert: Identifiable {
    var id: String { "\(title):\(message)" }
    let title: String
    let message: String
}

protocol SignUpViewModelProtocol: ObservableObject {
    var firstName: String { get set }
    var lastName: String { get set }
    var emailOrPhone: String { get set }
    var password: String { get set }
        
    var isFirstNameValid: Bool { get }
    var isLastNameValid: Bool { get }
    var isEmailValid: Bool { get set }
    var isPhoneValid: Bool { get set }
    var isPasswordValid: Bool { get }
    var isFormValid: Bool { get }
    var isLoading: Bool { get }
    var passwordErrorMessage: String? { get }
    
    var signInType: SignInType { get set }
    var emailOrPhoneErrorMessage: String? { get set }
    var alert: SignUpViewModelAlert? { get set }
    
    func signUp()
}
