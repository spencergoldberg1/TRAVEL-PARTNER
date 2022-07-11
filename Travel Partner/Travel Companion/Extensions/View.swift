import SwiftUI

extension View {
    /// Combines the `PresentModifier` and a `View` and returns a new view.
    ///
    /// Use this to easily present a modal or popup over the current view. The example
    /// below shows how to present a `AlertView`:
    ///
    ///     struct PresentExample: View {
    ///         @State var isPresented: Bool = false
    ///         var body: some View {
    ///             Button("Toggle PopUp") {
    ///                 self.isPresented.toggle()
    ///             }
    ///             .present(isPresented: $isPresented) {
    ///                 AlertView(image: "submit_feedback_icon",
    ///                       title: "No Table Found",
    ///                       text: "Waiting to join a table timed out!") {
    ///                     AlertButton(role: .default("Confirm")) {
    ///                         // Press action...
    ///                     }
    ///                     AlertButton(role: .destructive("Dismiss")) {
    ///                         // Press action...
    ///                     }
    ///                 }
    ///            }
    ///        }
    ///   }
    ///
    /// - Parameters:
    ///     - isPresented: A binding to a Boolean value that determines whether
    ///     to present the modal that you create in the modifier's `modal` closure. When the
    ///     user presses or taps OK the system sets `isPresented` to `false`
    ///     which dismisses the alert.
    ///     - modal: A `View`
    func present<Modal: View>(style: UIModalPresentationStyle = .overFullScreen, transitionStyle: UIModalTransitionStyle = .crossDissolve,isPresented: Binding<Bool>, modal: @escaping () -> Modal) -> some View {
        self.modifier(PresentModifier(style: style, transitionStyle: transitionStyle, isPresented: isPresented, modal: modal()))
    }
}

extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        }
        else {
            self
        }
    }
    
    @ViewBuilder
    func slideOver<view: View>(navTitle: String? = nil, _ slideOverView: @escaping () -> view) -> some View {
        modifier(MenuSlideOver(slideOverView: slideOverView, navTitle: navTitle))
    }
}

struct ModalView<T: View>: UIViewControllerRepresentable {
  let view: T
  @Binding var isModal: Bool
  let onDismissalAttempt: (()->())?
  func makeUIViewController(context: Context) -> UIHostingController<T> {
    UIHostingController(rootView: view)
  }
  func updateUIViewController(_ uiViewController: UIHostingController<T>, context: Context) {
    uiViewController.parent?.presentationController?.delegate = context.coordinator
  }
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
    let modalView: ModalView
    init(_ modalView: ModalView) {
      self.modalView = modalView
    }
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
      !modalView.isModal
    }
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
      modalView.onDismissalAttempt?()
    }
  }
}

extension View {
    func presentation(isModal: Binding<Bool>, onDismissalAttempt: (()->())? = nil) -> some View {
        ModalView(view: self, isModal: isModal, onDismissalAttempt: onDismissalAttempt)
    }
}

extension View {
    func SFProDisplayText43(color: Color?) -> some View {
        self.foregroundColor(color)
            .font(.system(size: 43, weight: .bold))
    }
    
    func SFProDisplayText36(color: Color?) -> some View {
        self.foregroundColor(color)
            .font(.system(size: 36, weight: .medium))
    }
    
    func subheader(color: Color?) -> some View {
        self.foregroundColor(color)
            .font(.system(size: 30, weight: .medium))
    }
    
    func body(color: Color?) -> some View {
        self.foregroundColor(color)
            .font(.system(size: 25, weight: .regular))
    }
    
    func body2(color: Color?) -> some View {
        self.foregroundColor(color)
            .font(.system(size: 20, weight: .regular))
    }
    
    func body3(color: Color?) -> some View {
        self.foregroundColor(color)
            .font(.system(size: 17, weight: .semibold))
    }
    
    func buttons(color: Color?) -> some View {
        self.foregroundColor(color)
            .font(.system(size: 17, weight: .regular))
    }
}

extension View {
    /// Define the corner radius of a view and set which specific corners you want
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func swipeActions(deleteActivationOffset: CGFloat, buttons: AnyView) -> some View {
        self.modifier(SwipeActions(deleteActivationOffset: deleteActivationOffset, buttons: buttons))
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct SwipeActions: ViewModifier {
    @State var offset: CGFloat = .zero
    let deleteActivationOffset: CGFloat
    let buttons: AnyView
    
    func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            HStack {
                buttons
                
            }
            .padding(.horizontal)
            content
                .offset(x: offset)
                .gesture(
                    // Defines a drag gesture for the cell
                    DragGesture()
                        .onChanged { gesture in
                            // If the gesture is a swipe left gesture, meaning that the translation width is less than 0
                            if gesture.translation.width < 0 {
                                withAnimation(.spring()) {
                                    self.offset = gesture.translation.width
                                }
                            // Else only allow a swipe right gesture if the cell is already offset left showing the delete button
                            } else if gesture.translation.width > 0 && offset < 0 {
                                withAnimation(.spring()) {
                                    self.offset = gesture.translation.width
                                }
                            }
                        }
                        .onEnded { gesture in
                            // When the gesture ends if the gesture offset is greater than the delete button offset,
                            // set it to the delete button offset which makes the cell stick its offset and allows the delete button to be shown
                            if self.offset <= deleteActivationOffset {
                                withAnimation(.spring()) {
                                    self.offset = deleteActivationOffset
                                }
                            } else {
                            // Else if gesture ended and never reached the delete button offset, set it back to zero.
                                withAnimation(.spring()) {
                                    self.offset = .zero
                                }
                            }
                        }
                )
        }
    }
}

struct WithBadgeModifier: ViewModifier {
    var count: Int

    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .badge(count)
        } else {
            content
        }
    }
}

struct unFillSfSymbol: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .environment(\.symbolVariants, .none)
        } else {
            content
        }
    }
}

extension View {
    func withBadge(count: Int) -> some View {
        modifier(WithBadgeModifier(count: count))
    }
    func removeFill() -> some View {
        modifier(unFillSfSymbol())
    }
}


struct MenuSlideOver<view: View>: ViewModifier {
    @ViewBuilder var slideOverView: view
    
    @State var slideOver = false
    
    var navTitle: String? = nil
    func body(content: Content) -> some View {
        GeometryReader { geo in
            ZStack {
                content
                    .disabled(slideOver)
                    .gesture(
                        DragGesture()
                            .onChanged { swipe in
                                if swipe.translation.width > 0 && !slideOver {
                                    slideOver = true
                                }
                            }
                    )
                    .zIndex(0)
                
                Group {
                    if slideOver {
                        Color.black.opacity(0.65)
                            .onTapGesture {
                                slideOver.toggle()
                            }
                            .ignoresSafeArea()
                            .zIndex(1)
                    }
                    if slideOver {
                        HStack {
                            slideOverView
                                .frame(width: geo.size.width * 0.75)
                            Spacer()
                        }
                        .zIndex(2)
                        .transition(.move(edge: .leading))
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged { swipe in
                            if swipe.translation.width < 0 {
                                slideOver = false
                            }
                        }
                )
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    if slideOver {
                        Text(navTitle ?? "Menu")
                            .font(.system(size: 23, weight: .medium))
                            .foregroundColor(Constants.Colors.defaultText)
                            .padding(.trailing, geo.size.width * 0.25)
                    }
                }
                
            }
        }
        .animation(.default, value: slideOver)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button(action: {
                    slideOver.toggle()
                }) {
                    Image(systemName: "line.3.horizontal")
                        .foregroundColor(Constants.Colors.navigationBarAccentColor)
                }
            }
        }

    }
}

extension View {
    func readSize(size: Binding<CGSize>) -> some View {
        self.modifier(ReadSize(size: size))
    }
    func pushToTheLeft() -> some View {
        HStack {
            self
            Spacer()
        }
    }
    func pushToTheRight() -> some View {
        HStack {
            Spacer()
            self
        }
    }
    func pushUp() -> some View {
        VStack {
            self
            Spacer()
        }
    }
    func pushDown() -> some View {
        VStack {
            Spacer()
            self
        }
    }
    
    func spacing(edges: [Edge.Set] = [.all], _ space: CGFloat = 10) -> some View {
        HStack {
            if edges.contains{ [.all, .horizontal, .leading].contains($0) } {
                Spacer().frame(width: space)
            }
            VStack {
                if edges.contains{ [.all, .vertical, .top].contains($0) } {
                    Spacer().frame(height: space)
                }
                self
                if edges.contains{ [.all, .vertical, .bottom].contains($0) } {
                    Spacer().frame(height: space)
                }
            }
            if edges.contains{ [.all, .horizontal, .trailing].contains($0) } {
                Spacer().frame(width: space)
            }
        }
    }
    
    func fractionalSize(widthFraction: CGFloat? = nil, heightFraction: CGFloat? = nil) -> some View {
        self.modifier(FractionalSize(widthFraction: widthFraction, heightFraction: heightFraction))
    }
    
    func center(horizontal: Bool = true, vertical: Bool = true) -> some View {
        VStack {
            if vertical { Spacer() }
            HStack {
                if horizontal { Spacer() }
                self
                if horizontal { Spacer() }
            }
            if vertical { Spacer() }
        }
    }
    
    func appNavigationBar(_ title: String) -> some View {
        self
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.system(size: 23, weight: .medium))
                        .foregroundColor(Constants.Colors.defaultText)
                }
            }
    }

}

struct ReadSize: ViewModifier {
    @Binding var size: CGSize
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometryProxy in
                    Color.clear
                        .onAppear {
                            size = geometryProxy.size
                        }
                        .onChange(of: geometryProxy.size) { newValue in
                            size = newValue
                        }
                }
            )
    }
}

struct FractionalSize: ViewModifier {
    @State var sizeOfView: CGSize = .zero
    var widthFraction: CGFloat?
    var heightFraction: CGFloat?
    func body(content: Content) -> some View {
        
        let _ = content
            .foregroundColor(.clear)
            .readSize(size: $sizeOfView)
        return content
            .frame(width: widthFraction ?? 1 * sizeOfView.width, height: heightFraction ?? 1 * sizeOfView.height)

    }
}

// For the notifications navigation link tool bar item
struct NotificationTab<view: View>: ViewModifier {
    @ViewBuilder var notificationsView: view
    let notificationsCount: Int
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: notificationsView) {
                        ZStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(Constants.Colors.navigationBarAccentColor)
                            if notificationsCount != 0 {
                                Image(systemName: "\(notificationsCount).circle.fill")
                                    .padding(-2)
                                    .background(Circle().foregroundColor(.white))
                                    .padding(2)
                                    .foregroundColor(.red)
                                    .font(.system(size: 12))
                                    .offset(x: 10, y: -10)
                            }
                        }
                    }
                }
            }
    }
}

