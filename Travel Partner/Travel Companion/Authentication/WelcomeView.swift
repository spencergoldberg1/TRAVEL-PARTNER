
import SwiftUI
import Firebase
import GoogleSignIn
import AuthenticationServices

/// First view that is show to the user when they are signed out or new to the app
struct WelcomeView<User: UserRepresentable>: View {
    
    private let vm = SocialRegistrationViewModel()


    @State private var navigated = false
    @State private var selectedOption = 0
    
    @State var signInType: SignInType = .email
    
    // Upon initialization of the view configure the navigation bar
    init() {
        Utils.configureNavBar(with: Constants.Colors.navigationBar)
    }

    var body: some View {
        ZStack(alignment: .top) {
            Constants.Colors.appBackground.ignoresSafeArea()

            // This is needed to prevent auto dismissal when exiting the app or accessing social sign ins from SignInView
            NavigationLink(destination: EmptyView()) {
                EmptyView()
            }
            
            VStack(spacing: 0) {
                SegmentedLoginControl(
                    options: ["Log In", "Sign Up"],
                    selectedOption: $selectedOption
                )
                .padding(.horizontal, 36)
                .padding(.bottom, 3)
                
                TabView(selection: $selectedOption) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            VStack(spacing: 10) {
                                AppleSignIn<User>()
                                
                             
                            
                            }
                            .padding(.bottom, 26)
                            
                            
                    
                    
                        }
                        .padding(.top, 30)
                        .padding(.horizontal, 36)
                    }
                    .tag(0)
                    // Used to block swipe left and right gesture in this Page Tab View
                    .gesture(DragGesture())
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            VStack(spacing: 10) {
                                AppleSignIn<User>()
                                
                               
                                
                               
                            }
                            .padding(.bottom, 26)
                            
                            OrDivider()
                                .padding(.bottom, 30)
                            
                            //SignUpView<User>(guestApp: $guestApp)
                        }
                        .padding(.top, 30)
                        .padding(.horizontal, 36)
                    }
                    // Used to block swipe left and right gesture in this Page Tab View
                    .gesture(DragGesture())
                    .tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// Segmented control that allows a user to switch between Login and Sign Up Views
fileprivate struct SegmentedLoginControl: View {
      
    typealias Colors = Constants.Colors.Views.WelcomeView.SegmentedLoginControl
    
    let options: [String]
    @Binding var selectedOption: Int

    var body: some View {
        HStack {
            ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                Button(action: {
                    withAnimation {
                        selectedOption = index
                    }
                }) {
                    Text(option)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(selectedOption == index ? Colors.selectedOptionText : Colors.unselectedOptionText)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 7, style: .continuous)
                                .foregroundColor(
                                    selectedOption == index ? Colors.selectedOptionBackground : Colors.controlBackground))
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding(2)
        .background(Colors.controlBackground)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

fileprivate struct OrDivider: View {
    typealias Colors = Constants.Colors.Views.WelcomeView.OrDivider

    var body: some View {
        HStack(spacing: 16) {
            horizontalDivider
            
            Text("Or")
                .foregroundColor(Colors.dividerColor)
            
            horizontalDivider
        }
    }
    
    private var horizontalDivider: some View {
        VStack {
            Divider()
                .frame(height: 2)
        }
        .background(Colors.dividerColor)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WelcomeView<Guest>()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
