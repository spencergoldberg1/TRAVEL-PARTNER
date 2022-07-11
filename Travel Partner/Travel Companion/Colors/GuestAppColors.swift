//
//  GuestAppColors.swift
//  TBD GUEST
//
//  Created by Spencer Goldberg on 4/5/22.
//  Copyright © 2022 Cocobolo Group. All rights reserved.
//

import SwiftUI

extension Constants.Colors {
    // General colors that should be defined for all views to use
    static let appBackground = ColorPallete.PureWhite 
    static let defaultText = ColorPallete.Black
    static let navigationBar = Constants.Colors.ColorPallete.PureWhite
    static let navigationBarAccentColor = ColorPallete.DarkBrown
    static let tabBar = ColorPallete.DarkBrown
    static let tabBarUnselected = ColorPallete.LightBrown
    static let tabBarAccent = ColorPallete.PureWhite
    static let notification = ColorPallete.LightGrey
    static let comingSoonText = ColorPallete.DarkBrown
    static let placeholder = ColorPallete.grayText

    /// Need to keep popupBackground defined this way because it is a shared view
    static let popupBackground = ColorPallete.PureWhite

    struct Buttons {

        static let flatButton = Constants.Colors.ColorPallete.DarkBrown

        struct Google {
            static let backgroundColor = Constants.Colors.ColorPallete.Black
            static let textColor = Constants.Colors.ColorPallete.Black
            static let borderColor = Constants.Colors.ColorPallete.Black
        }

        struct Facebook {
            static let backgroundColor = Constants.Colors.ColorPallete.Black
            static let textColor = Constants.Colors.ColorPallete.PureWhite
            static let borderColor = Constants.Colors.ColorPallete.Black
        }

        struct Apple {
            static let backgroundColor = Constants.Colors.ColorPallete.Black
            static let textColor = Constants.Colors.ColorPallete.PureWhite
        }

        struct EmailRegistration {
            static let backgroundColor = Constants.Colors.ColorPallete.DarkBrown
            static let textColor = Constants.Colors.ColorPallete.PureWhite
        }

        struct PickerButton {
            static let backgroundColor = Constants.Colors.ColorPallete.PureWhite
            static let textColor = Constants.Colors.defaultText
        }

        struct Primary {
            static let backgroundColor = Constants.Colors.ColorPallete.DarkBrown
            static let disabledBackgroundColor = Constants.Colors.ColorPallete.Gray9
            static let textColor = Constants.Colors.ColorPallete.PureWhite
        }

        struct MyTableButtons {
            static let textColor = Constants.Colors.ColorPallete.DarkBrown
            static let iconColor = Constants.Colors.ColorPallete.DarkBrown
            static let enabledButtonColor = Constants.Colors.ColorPallete.PureWhite
            static let disabledButtonColor = Constants.Colors.ColorPallete.MediumTan
            static let dividerColor = Constants.Colors.ColorPallete.DarkBrown
        }

        struct Compliment {
            static let enabledBackgroundColor = Constants.Colors.ColorPallete.DarkBrown
            static let disabledBackgroundColor = Constants.Colors.ColorPallete.AshBrown
            static let textColor = Constants.Colors.ColorPallete.PureWhite
        }

        struct ComplimentServerButton {
            static let textColor = Constants.Colors.defaultText
            static let iconColor = Constants.Colors.defaultText
        }

        struct LogoutButton {
            static let textColor = Constants.Colors.ColorPallete.BrightRed
        }
    }

    struct Views {

        struct WelcomeView {
            struct SegmentedLoginControl {
                static let controlBackground = Constants.Colors.ColorPallete.PureWhite
                static let selectedOptionBackground = Constants.Colors.ColorPallete.LightBrown
                static let selectedOptionText = Constants.Colors.ColorPallete.PureWhite
                static let unselectedOptionText = Constants.Colors.ColorPallete.Black
            }

            struct OrDivider {
                static let dividerColor = Constants.Colors.ColorPallete.Black
            }
        }

        struct OptionItemView {
            static let iconColor = Constants.Colors.ColorPallete.DarkBrown
            static let background = Constants.Colors.ColorPallete.PureWhite
            static let divider = Constants.Colors.ColorPallete.MediumTan
            static let buttonColor = Constants.Colors.ColorPallete.Beige4
        }

        struct OnboardingView {
            static let textColor = Constants.Colors.defaultText
            static let buttonColor = Constants.Colors.ColorPallete.DarkBrown
            static let selectedTabColor = Constants.Colors.ColorPallete.DarkBrown
            static let unselectedTablColor = Constants.Colors.ColorPallete.Beige3
            static let flatButtonText = Constants.Colors.ColorPallete.LightGreen
        }

        struct FirstTimeGuestFlow {
            static let buttonColor = Constants.Colors.ColorPallete.DarkBrown
            static let textColor = Constants.Colors.ColorPallete.DarkBrown
            static let secondaryTextColor = Constants.Colors.ColorPallete.PureWhite
            static let placeholderColor = Constants.Colors.ColorPallete.Grey
            static let textFieldColor = Constants.Colors.ColorPallete.LightGrey
            static let subtitleColor = Constants.Colors.ColorPallete.DarkBrown
            static let slideBackground = Constants.Colors.ColorPallete.PureWhite
            static let diningProfileBackground = Constants.Colors.ColorPallete.PureWhite
            static let warningText = Constants.Colors.ColorPallete.BrightRed
        }

        struct SignUpView {
            static let background = Constants.Colors.appBackground
            static let defaultText = Constants.Colors.defaultText
            static let textFieldBackground = Constants.Colors.ColorPallete.LightGrey
            static let placeholderText = Constants.Colors.placeholder
            static let textFieldText = Constants.Colors.ColorPallete.Black
            static let signUpButtonText = Constants.Colors.ColorPallete.PureWhite
            static let signUpButtonBackground = Constants.Colors.ColorPallete.DarkBrown
            static let divider = Constants.Colors.ColorPallete.Black
            static let flatButtonText = Constants.Colors.ColorPallete.LightGreen
            static let showPasswordButton = Constants.Colors.ColorPallete.Black
            static let errorColor = Constants.Colors.ColorPallete.BrightRed
            static let validColor = Constants.Colors.ColorPallete.LightGreen
            static let textfieldBorder = Constants.Colors.ColorPallete.Beige
        }

        struct SignInView {
            static let background = Constants.Colors.appBackground
            static let defaultText = Constants.Colors.defaultText
            static let textFieldBackground = Constants.Colors.ColorPallete.LightGrey
            static let placeholderText = Constants.Colors.placeholder
            static let textFieldText = Constants.Colors.ColorPallete.Black
            static let signInButtonText = Constants.Colors.ColorPallete.PureWhite
            static let signInButtonBackground = Constants.Colors.ColorPallete.DarkBrown
            static let divider = Constants.Colors.ColorPallete.Black
            static let flatButtonText = Constants.Colors.ColorPallete.LightGreen
            static let forgotPasswordText = Constants.Colors.ColorPallete.BrightRed
            static let showPasswordButton = Constants.Colors.ColorPallete.Black
            static let errorColor = Constants.Colors.ColorPallete.BrightRed
            static let validColor = Constants.Colors.ColorPallete.LightGreen
            static let textfieldBorder = Constants.Colors.ColorPallete.Beige
        }

        struct FriendsView {
            static let background = Constants.Colors.ColorPallete.PureWhite
            static let defaultText = Constants.Colors.defaultText
            static let textFieldBackground = Constants.Colors.ColorPallete.LightGrey
            static let placeholderText = Constants.Colors.ColorPallete.DarkestGrey
            static let textFieldText = Constants.Colors.ColorPallete.Black
            static let AddButton = Constants.Colors.ColorPallete.DarkBrown
            static let AddText = Constants.Colors.ColorPallete.PureWhite
            static let divider = Constants.Colors.ColorPallete.AshBrown
            static let chevron = Constants.Colors.ColorPallete.DarkBrown
            static let requestBackground = Constants.Colors.ColorPallete.AshBrown
            static let requestForeground = Constants.Colors.ColorPallete.DarkBrown
            static let imageColor = Constants.Colors.ColorPallete.Grey
            static let subtitleText = Constants.Colors.ColorPallete.Grey
        }

        struct FriendCard {
            static let background = Constants.Colors.ColorPallete.MediumTan
            static let defaultText = Constants.Colors.defaultText
            static let AddButton = Constants.Colors.ColorPallete.DarkBrown

        }

        struct AddFriends {
            static let background = Constants.Colors.ColorPallete.PureWhite
            static let searchBar = Constants.Colors.ColorPallete.VeryLightGrey
            static let magnifyingGlass = Constants.Colors.ColorPallete.DarkBrown
            static let defaultText = Constants.Colors.defaultText
            static let placeholderColor = Constants.Colors.ColorPallete.Grey
            static let divider = Constants.Colors.ColorPallete.AshBrown
            static let buttonBackground = Constants.Colors.ColorPallete.DarkBrown
        }

        struct PhoneVerificationComponent {
            static let textColor = Constants.Colors.ColorPallete.Black
            static let codeUnfilled = Constants.Colors.ColorPallete.LightGrey
            static let codeFilled = Constants.Colors.ColorPallete.LightGreen
            static let didntRecieveText = Constants.Colors.ColorPallete.Grey
            static let resendCodeColor = Constants.Colors.ColorPallete.LightGreen
            static let errorColor = Constants.Colors.ColorPallete.BrightRed
        }
        struct DeleteAccountView {
            static let titleTextColor = Constants.Colors.ColorPallete.Black
            static let subTextColor = Constants.Colors.ColorPallete.Black
            static let listTextColor = Constants.Colors.ColorPallete.Black
            static let buttonTextColor = Constants.Colors.ColorPallete.MediumTan
            static let buttonBackgroundColor = Constants.Colors.ColorPallete.BrightRed
        }

        struct CreateOrJoinTableView {
            static let background = Constants.Colors.appBackground
            static let joinTable = Constants.Colors.ColorPallete.DarkBrown
            static let createTable = Constants.Colors.ColorPallete.DarkBrown
            static let joiningTableLoading = Constants.Colors.ColorPallete.DarkBrown
            static let waitingTableLoading = Constants.Colors.ColorPallete.DarkBrown
            static let searchingTableLoading = Constants.Colors.ColorPallete.DarkBrown
            static let defaultText = Constants.Colors.defaultText

            static let searchBarForeground = Constants.Colors.ColorPallete.LightBrown
            static let searchBarBackground = Constants.Colors.ColorPallete.Grey.opacity(0.37)
            
            struct RestaurantFilters {
                static let background = Constants.Colors.ColorPallete.DarkBrown
                static let foreground = Constants.Colors.ColorPallete.PureWhite
            }
            struct EnterCodeView {
                static let background = Constants.Colors.ColorPallete.PureWhite
                static let text = Constants.Colors.ColorPallete.DarkBrown
                static let codeBackground = Constants.Colors.ColorPallete.AshBrown
                static let codeText = Constants.Colors.ColorPallete.PureWhite
            }
        }

        struct GuestView {
            static let placeholderTextColor = Constants.Colors.ColorPallete.DarkestGrey
            static let textColor = Constants.Colors.defaultText
            static let infoIcon = Constants.Colors.ColorPallete.LightBrown
        }

        /// These colors have to be defined this way because it is a shared view, should be refactored out later.
        struct AlertView {
            static let blurViewBackground = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4))
            static let text = Constants.Colors.ColorPallete.Black
            static let background = Color(#colorLiteral(red: 0.9960784314, green: 0.9960784314, blue: 0.9960784314, alpha: 1))
            static let buttonText = Color(#colorLiteral(red: 0.1529411765, green: 0.6666666667, blue: 0.8823529412, alpha: 1))
        }

        struct CreateTableView {
            static let defaultText = Constants.Colors.ColorPallete.DarkBrown
            static let occasionButton = Constants.Colors.ColorPallete.Beige4
            static let cancelButton = Constants.Colors.ColorPallete.BrightRed
            static let divider = Constants.Colors.ColorPallete.Gray1

            struct OccasionView {
                static let occasionHeader = Constants.Colors.ColorPallete.DarkBrown
                static let occasionText = Constants.Colors.ColorPallete.DarkBrown
                static let selectedOccasion = Constants.Colors.ColorPallete.Tan
                static let unselectedOccasion = Constants.Colors.ColorPallete.PureWhite
                static let cellBorder = Constants.Colors.ColorPallete.Beige
                static let shadowColor = Constants.Colors.ColorPallete.DarkBrown.opacity(0.10)
                
            }

            struct PaymentPreferencesView {
                static let paymentPreferencesHeaderTextColor = Constants.Colors.ColorPallete.DarkBrown
                static let selectedPaymentPreferenceTextColor = Constants.Colors.ColorPallete.PureWhite
                static let unselectedPaymentPreferenceTextColor = Constants.Colors.ColorPallete.Black
                static let selectedCellColor = Constants.Colors.ColorPallete.Tan
                static let deselectedCellColor = Constants.Colors.appBackground
                static let borderColor = Constants.Colors.ColorPallete.PureWhite
            }
        }

        struct OccasionPersonView {
            static let headerText = Constants.Colors.ColorPallete.DarkBrown
            static let sendButton = Constants.Colors.ColorPallete.DarkBrown
            static let sendButtonText = Constants.Colors.ColorPallete.PureWhite
            static let sendButtonDisabled = Constants.Colors.ColorPallete.DarkBrown.opacity(0.18)
            static let searchBarBackground = Constants.Colors.ColorPallete.White4
            static let searchBarTextColor = Constants.Colors.ColorPallete.DarkBrown
            static let cancel = Constants.Colors.ColorPallete.BrightRed

        }

        struct FriendCellView {
            static let imageOutline = Constants.Colors.ColorPallete.PureWhite
            static let textColor = Constants.Colors.ColorPallete.DarkBrown
            static let friendCellDeselectedBackground = Constants.Colors.ColorPallete.PureWhite
            static let friendCellSelectedBackground = Constants.Colors.ColorPallete.Beige4
            static let dividerColor = Constants.Colors.ColorPallete.Beige
        }

        struct MyTableView {
            static let background = Constants.Colors.appBackground
            static let textColor = Constants.Colors.ColorPallete.DarkBrown
            static let defaultText = Constants.Colors.defaultText
            static let complimentServerButton = Constants.Colors.ColorPallete.Black
            static let viewMenuButton = Constants.Colors.ColorPallete.LightBrown
            static let dividerColor = Constants.Colors.ColorPallete.Black
            static let plusIconcolor = Constants.Colors.ColorPallete.DarkBrown
            static let tableContainer = Constants.Colors.ColorPallete.Black.opacity(0.36)
            static let shadow = Constants.Colors.ColorPallete.Black.opacity(0.08)
            static let tableContainerBackground = Constants.Colors.ColorPallete.PureWhite

            static let qrcode = Constants.Colors.ColorPallete.Black
            static let qrcodeBackground = Constants.Colors.ColorPallete.MediumTan
            struct RequestButton {
                static let primaryColor = Constants.Colors.ColorPallete.AshBrown
                static let secondaryColor = Constants.Colors.ColorPallete.DarkBrown
                static let iconColor = Constants.Colors.ColorPallete.PureWhite
                static let disabledColor = Constants.Colors.ColorPallete.Beige4
            }

            struct TableMembersView {
                static let backgroundColor = Constants.Colors.ColorPallete.PureWhite
                static let textColor = Constants.Colors.ColorPallete.DarkBrown
                static let iconColor = Constants.Colors.ColorPallete.LightBrown
                static let leaveTableTextColor = Constants.Colors.ColorPallete.BrightRed
            }

            struct TableCodeView {
                static let background = Constants.Colors.ColorPallete.PureWhite
                static let code = Constants.Colors.ColorPallete.Black
                static let text = Constants.Colors.ColorPallete.DarkBrown
            }
        }

        struct MyProfileView {
            static let defaultText = Constants.Colors.defaultText
            static let rowTextColor = Constants.Colors.ColorPallete.Grey
            static let dividerColor = Constants.Colors.ColorPallete.DarkBrown.opacity(0.25)
            static let sectionDividerColor = Constants.Colors.ColorPallete.AshBrown
            static let allergiesTextColor = Constants.Colors.ColorPallete.BrightRed
            static let sectionBackgroundColor = Constants.Colors.ColorPallete.AshBrown
            static let editButtonColor = Constants.Colors.ColorPallete.DarkBrown
        }
        struct CompactTableMembersView {
            static let arrowColor = Constants.Colors.ColorPallete.DarkBrown
            static let textColor = Constants.Colors.ColorPallete.DarkBrown
            static let addButtonColor = Constants.Colors.ColorPallete.LightBrown
            static let leaveButtonColor = Constants.Colors.ColorPallete.AshBrown
        }

        struct ServerCard {
            static let defaultText = Constants.Colors.ColorPallete.DarkBrown
        }


        struct ComplimentServerView {
            static let background = Constants.Colors.appBackground
            static let text = Constants.Colors.defaultText
            static let qualitiesBackground = Constants.Colors.ColorPallete.PureWhite
            static let heartIcon = Constants.Colors.ColorPallete.DarkBrown
        }

        struct DiningProfileView {
            static let foodPreferenceSectionBackgroundColor = Constants.Colors.ColorPallete.PureWhite
            static let textColor = Constants.Colors.ColorPallete.DarkBrown
            static let requiredColor = Constants.Colors.ColorPallete.BrightRed
            static let bulletPointColor = Constants.Colors.ColorPallete.AshBrown
            static let infoColor = Constants.Colors.ColorPallete.AshBrown
            static let disclosureButtonColor = Constants.Colors.ColorPallete.GoldenBrown
            static let selectedOptionColor = Constants.Colors.ColorPallete.LightBrown
            static let selectedTextColor = Constants.Colors.ColorPallete.DarkBrown
            static let unselectedOptionColor = Constants.Colors.ColorPallete.White4
            static let unselectedTextColor = Constants.Colors.ColorPallete.Grey
            static let subtitleHeaderTextColor = Constants.Colors.ColorPallete.DarkestGrey

            struct DiningProfileAskMeTextField {
                static let backgroundColor = DiningProfileView.foodPreferenceSectionBackgroundColor
                static let requiredBulletPoint = DiningProfileView.bulletPointColor
                static let textColor = DiningProfileView.textColor
                static let tintColor = Constants.Colors.ColorPallete.GoldenBrown
                static let characterCountTextColor = Constants.Colors.ColorPallete.Grey
                static let suggestionsTextColor = Constants.Colors.ColorPallete.PureWhite
                static let suggestionIconBackground = Constants.Colors.ColorPallete.GoldenBrown
                static let closeButtonColor = Constants.Colors.ColorPallete.GoldenBrown
            }
        }

        struct FeedbackView {
            static let backgroundColor = Constants.Colors.ColorPallete.PureWhite
            static let titleTextColor = Constants.Colors.ColorPallete.Black
            static let textColor = Constants.Colors.defaultText
            static let activeButtonColor = Constants.Colors.ColorPallete.DarkBrown
            static let inactiveButtonColor = Constants.Colors.ColorPallete.AshBrown
            static let tabBarBackButtonColor = Constants.Colors.navigationBarAccentColor
            static let borderColor = Constants.Colors.ColorPallete.VeryLightGrey
            static let inActiveIconColor = Constants.Colors.ColorPallete.White4
            static let activeIconColor = Constants.Colors.ColorPallete.LightBrown
            static let feedbackTextColor = Constants.Colors.ColorPallete.Beige4

            struct WaiterIconView {
                static let backgroundColor = Constants.Colors.ColorPallete.PureWhite
                static let textColor = Constants.Colors.ColorPallete.Black
                static let tabBarBackButtonColor = Constants.Colors.ColorPallete.DarkBrown
            }
        }

        struct ShareAppView {
            static let shareAppButtonBackground = Constants.Colors.ColorPallete.Beige4
            static let textBackgroundColor = Constants.Colors.ColorPallete.Tan
            static let textColor = Constants.Colors.ColorPallete.PureWhite
            static let shareAppModalBackground = Constants.Colors.ColorPallete.PureWhite
            static let shareAppModalTextColor = Constants.Colors.ColorPallete.Black
            static let shareAppModalCloseButtonColor = Constants.Colors.ColorPallete.Tan
            static let shareAppHeaderTextColorGuest = Constants.Colors.ColorPallete.DarkBrown
            static let shareAppHeaderTextColorServer = Constants.Colors.ColorPallete.DarkBrown
        }

        struct UserProfileView {
            static let backgroundColor = Constants.Colors.ColorPallete.PureWhite
            struct UserProfileRow {
                static let rowColor = Constants.Colors.ColorPallete.DarkBrown
                static let dividerColor = Constants.Colors.ColorPallete.LightBrown
                static let pressedColor = Constants.Colors.ColorPallete.AshBrown
            }

            struct ProfileHeader {
                static let nameTextColor = Constants.Colors.ColorPallete.Black
                static let viewProfileTextColor = Constants.Colors.ColorPallete.MediumTan
                static let viewProfileBackground = Constants.Colors.ColorPallete.DarkBrown
                static let editTextColor = Constants.Colors.ColorPallete.DarkBrown
                static let editBackgroundColor = Constants.Colors.ColorPallete.MediumTan
                static let editBorderColor = Constants.Colors.ColorPallete.DarkBrown
            }
            
            struct Widgets {
                static let favoriteRest = Constants.Colors.ColorPallete.DarkBrown
                static let dining = Constants.Colors.ColorPallete.LightBrown
                static let groups = Constants.Colors.ColorPallete.GoldenBrown
                static let friends = Constants.Colors.ColorPallete.LightGray
                static let servers = Constants.Colors.ColorPallete.DarkBrown
                static let badges = Constants.Colors.ColorPallete.AshBrown
                static let text = Constants.Colors.ColorPallete.PureWhite
            }
        }
        struct DonationRow {
            static let headerText = Constants.Colors.ColorPallete.DarkBrown
            static let aboutHeaderColor = Constants.Colors.ColorPallete.Black
            static let textColor = Constants.Colors.ColorPallete.Black
            static let chevronColor = Constants.Colors.ColorPallete.DarkBrown
            static let backgroundColor = Constants.Colors.ColorPallete.Gray22
            static let buttonBackgroundColor = Constants.Colors.ColorPallete.Beige4
            static let buttonTextColor = Constants.Colors.ColorPallete.PureWhite
            static let readMoreLink = Constants.Colors.ColorPallete.BrightRed
            static let DonateButton = Constants.Colors.ColorPallete.DarkBrown
        }

        struct ServerProfileView {
            static let textColor = Constants.Colors.ColorPallete.Black
            static let secondaryColor = Constants.Colors.ColorPallete.DarkBrown
            static let buttonBorderCOlor = Constants.Colors.ColorPallete.DarkBrown
            static let removeTextColor = Constants.Colors.ColorPallete.MediumTan

            struct TopQualities {
                static let iconColor = Constants.Colors.ColorPallete.DarkBrown
                static let background = Constants.Colors.ColorPallete.PureWhite
            }
        }
        
        struct FavoriteServersView {
            static let textColor = Constants.Colors.defaultText
            static let background = Constants.Colors.ColorPallete.PureWhite
            static let divider = Constants.Colors.ColorPallete.DarkBrown.opacity(0.25)
            

            struct FavoriteServersCard {
                static let text = Constants.Colors.defaultText
                static let background = Constants.Colors.ColorPallete.PureWhite
            }
            
            struct FavoriteServerDetail {
                static let text = Constants.Colors.defaultText
                static let background = Constants.Colors.ColorPallete.PureWhite
                static let heart = Constants.Colors.ColorPallete.BrightRed
                static let favoriteButton = Constants.Colors.ColorPallete.DarkBrown
                static let divider = Constants.Colors.ColorPallete.DarkBrown.opacity(0.25)
                static let interestTagBackground = Constants.Colors.ColorPallete.LightBrown
                static let interestTagBorder = Constants.Colors.ColorPallete.DarkBrown
                static let interestTagForegroundColor = Constants.Colors.ColorPallete.PureWhite
            }
        }

        struct SettingsView {
            static let chevronColor = Constants.Colors.ColorPallete.DarkBrown
            static let dividerColor = Constants.Colors.ColorPallete.LightBrown
            static let textColor = Constants.Colors.ColorPallete.Black
            static let pressedCellColor = Constants.Colors.ColorPallete.Beige4
        }

        struct PasswordView {
            static let boxColor = Constants.Colors.ColorPallete.AshBrown
            static let dividerColor = Constants.Colors.ColorPallete.DarkBrown.opacity(0.25)
            static let green = Constants.Colors.ColorPallete.LightGreen
            static let placeholderText = Constants.Colors.ColorPallete.PureWhite
            static let red = Constants.Colors.ColorPallete.BrightRed
        }

        struct AboutView {
            static let chevronColor = Constants.Colors.ColorPallete.DarkBrown
            static let dividerColor = Constants.Colors.ColorPallete.LightBrown
            static let textColor = Constants.Colors.ColorPallete.Black
            static let pressedCellColor = Constants.Colors.ColorPallete.Tan
        }

        struct NotificationsView {
            static let titleColor = Constants.Colors.ColorPallete.OffBlack
            static let subtitleColor = Constants.Colors.ColorPallete.Grey
            static let descriptionColor = Constants.Colors.ColorPallete.OffBlack
            static let cellBackgroundColor = Constants.Colors.ColorPallete.PureWhite
            static let imageBackgroundColor = Constants.Colors.ColorPallete.Tan
            static let timestampColor = Constants.Colors.ColorPallete.LightGrey
            static let deleteButtonColor = Constants.Colors.ColorPallete.BrightRed
            static let clearAllColor = Constants.Colors.ColorPallete.DarkBrown
        }

        struct eTipView {
            static let guestTipAmount = Constants.Colors.ColorPallete.DarkBrown
            static let boxOutline = Constants.Colors.ColorPallete.LightBrown
            static let dividerColor = Constants.Colors.ColorPallete.DarkBrown.opacity(0.25)
            static let placeholder = Constants.Colors.placeholder
            static let appleForeground = Color.white
            static let appleBackground = Color.black
        }
        
        struct Toast {
            static let shadow = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.15))

            struct Default {
                static let backgroundColor = Constants.Colors.ColorPallete.PureWhite
                static let textColor = Constants.Colors.ColorPallete.Black
            }

            struct Success {
                static let backgroundColor = Constants.Colors.ColorPallete.LightGreen
                static let textColor = Constants.Colors.ColorPallete.PureWhite
            }

            struct Warning {
                static let backgroundColor = Constants.Colors.ColorPallete.PureWhite
                static let textColor = Constants.Colors.ColorPallete.PureWhite
            }

            struct Error {
                static let backgroundColor  = Constants.Colors.ColorPallete.BrightRed
                static let textColor = Constants.Colors.ColorPallete.PureWhite
            }
        }

        struct iPhoneNumberTextField {
            static let backgroundColor = Constants.Colors.ColorPallete.LightGrey
            static let textColor = Constants.Colors.ColorPallete.Black
            static let placeholderColor = Constants.Colors.ColorPallete.LightGrey

            struct FlagButton {
                static let backgroundColor = Constants.Colors.ColorPallete.Grey
                static let chevronIconColor = Constants.Colors.ColorPallete.Grey
            }

            struct RegionPicker {
                static let backgroundColor = Constants.Colors.ColorPallete.PureWhite
                static let textColor = Constants.Colors.ColorPallete.Black
                static let cellBackgroundColor = Constants.Colors.ColorPallete.VeryLightGrey
                static let sectionTextColor = Constants.Colors.ColorPallete.Black
                static let currentLocationTextColor = Constants.Colors.ColorPallete.LightGrey

                struct SearchField {
                    static let textColor = Constants.Colors.ColorPallete.Black
                    static let placeholderColor = Constants.Colors.ColorPallete.LightGrey
                }
            }
        }
        
        struct VerifyEmailModal {
            static let backgroundColor = Constants.Colors.ColorPallete.PureWhite
            static let textColor = Constants.Colors.ColorPallete.Black
            static let disabledColor = Constants.Colors.ColorPallete.Grey
            
            struct ModalButton {
                static let destructiveColor = Constants.Colors.ColorPallete.BrightRed
                static let defaultColor = Constants.Colors.ColorPallete.Blue
            }
        }

        struct ThankYouForDiningModal {
            static let backgroundColor = Constants.Colors.popupBackground
            static let headerTextColor = Constants.Colors.ColorPallete.LightBrown
            static let textColor = Constants.Colors.defaultText
            static let complimentBackground = Constants.Colors.ColorPallete.Beige4
            static let selectedComplimentBackground = Constants.Colors.ColorPallete.Beige4
        }
    }

    struct PageViewIndexIndicator {
        static let selected = Constants.Colors.ColorPallete.BrightRed
        static let deselected = Constants.Colors.ColorPallete.LightBrown
    }

    struct ProgressBar {
        static let title = Constants.Colors.defaultText
        static let staticColor = Constants.Colors.ColorPallete.DarkBrown
        static let progressColor = Constants.Colors.ColorPallete.LightGreen
    }
    
    struct AccessibilityView {
        static let backgroundColor = Constants.Colors.ColorPallete.PureWhite
        static let generalTextColor = Constants.Colors.ColorPallete.Black
        static let textOnSelectedColor = Constants.Colors.ColorPallete.PureWhite
        static let saveButtonColor = Constants.Colors.ColorPallete.DarkBrown
        static let textFieldColor = Constants.Colors.ColorPallete.LightBrown
        static let toggleSelectedColor = Constants.Colors.ColorPallete.DarkBrown
        static let selectedButtonColor = Constants.Colors.ColorPallete.LightBrown
        static let nonSelectedButtonColor = Constants.Colors.ColorPallete.White4
    }
    
    struct ProfileTabView {
        static let backgroundColor = Constants.Colors.ColorPallete.PureWhite
    }
    
}
