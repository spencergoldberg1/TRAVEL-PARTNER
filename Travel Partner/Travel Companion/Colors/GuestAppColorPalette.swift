//
//  GuestAppColorPalette.swift
//  TBD GUEST
//
//  Created by Spencer Goldberg on 5/3/22.
//  Copyright © 2022 Cocobolo Group. All rights reserved.
//
import SwiftUI

extension Constants.Colors {
    /// Defined color pallete for the iOS Apps
    struct ColorPallete {
        
        static let DarkBrown = Color(#colorLiteral(red: 0.3215686275, green: 0.1568627451, blue: 0.04705882353, alpha: 1)) // #52280C
        static let LightBrown = Color(#colorLiteral(red: 0.6784313725, green: 0.3960784314, blue: 0.2235294118, alpha: 1)) // #AD6539
        static let GoldenBrown = Color(#colorLiteral(red: 0.8431372549, green: 0.462745098, blue: 0.2470588235, alpha: 1)) // #D7763F
        static let Tan = Color(#colorLiteral(red: 0.7450980392, green: 0.6196078431, blue: 0.5490196078, alpha: 1)) // #BE9E8C
        static let AshBrown = Color(#colorLiteral(red: 0.7490196078, green: 0.5843137255, blue: 0.4862745098, alpha: 1)) // #BF957C
        static let MediumTan = Color(#colorLiteral(red: 0.7490196078, green: 0.5843137255, blue: 0.4862745098, alpha: 0.8)) // #BF957C 80%
        static let Brown7 = Color(#colorLiteral(red: 0.3215686275, green: 0.1568627451, blue: 0.04705882353, alpha: 0.5)) // #52280C 50%
        static let Gray1 = Color(#colorLiteral(red: 0.3215686275, green: 0.1568627451, blue: 0.04705882353, alpha: 0.25)) // #52280C 25%
        static let Gray2 = Color(#colorLiteral(red: 0.4039215686, green: 0.3490196078, blue: 0.2980392157, alpha: 1)) // #67594C
        static let grayText = Color(#colorLiteral(red: 0.3411764706, green: 0.3411764706, blue: 0.3411764706, alpha: 1)) // #575757
        
        static let Beige1 = Color(#colorLiteral(red: 0.7490196078, green: 0.5843137255, blue: 0.4862745098, alpha: 0.4)) // #BF957C 40%
        static let Beige2 = Color(#colorLiteral(red: 0.3215686275, green: 0.1568627451, blue: 0.04705882353, alpha: 0.25)) // #52280C 25%
        static let Gray3 = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.36)) // #000000 36%
        static let Blue1 = Color(#colorLiteral(red: 0.6784313725, green: 0.7019607843, blue: 0.737254902, alpha: 1)) // #ADB3BC
        static let Beige = Color(#colorLiteral(red: 0.662745098, green: 0.662745098, blue: 0.662745098, alpha: 1)) // #A9A9A9
        static let Beige3 = Color(#colorLiteral(red: 0.7294117647, green: 0.6784313725, blue: 0.6470588235, alpha: 1)) // #BAADA5
        static let Beige4 = Color(#colorLiteral(red: 0.937254902, green: 0.8901960784, blue: 0.8352941176, alpha: 1)) // #EFE3D5
        static let PureWhite = Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)) // #FFFFFF
        static let Red = Color(#colorLiteral(red: 1, green: 0.2666666667, blue: 0.2666666667, alpha: 1)) // #FF4444
        
        static let Blue = Color(#colorLiteral(red: 0.2588235294, green: 0.5215686275, blue: 0.9568627451, alpha: 1)) // #4285F4
        static let White2 = Color(#colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)) // #F5F5F5
        static let Blue3 = Color(#colorLiteral(red: 0.1333333333, green: 0.1568627451, blue: 0.3098039216, alpha: 1)) // #22284F
        static let Gray5 = Color(#colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 0.25)) // #F5F5F5 25%
        static let LightGreen = Color(#colorLiteral(red: 0.2039215686, green: 0.6588235294, blue: 0.3254901961, alpha: 1)) // #34A853
        static let OffBlack = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.74)) // #000000 74%
        static let Gray6 = Color(#colorLiteral(red: 0.8549019608, green: 0.8549019608, blue: 0.8549019608, alpha: 1)) // #DADADA
        static let Blue4 = Color(#colorLiteral(red: 0.6392156863, green: 0.768627451, blue: 0.9137254902, alpha: 1)) // #A3C4E9
        static let White3 = Color(#colorLiteral(red: 0.862745098, green: 0.9019607843, blue: 0.9450980392, alpha: 1)) // #DCE6F1
        
        static let Pink1 = Color(#colorLiteral(red: 0.8784313725, green: 0.6901960784, blue: 0.7411764706, alpha: 1)) // #E0B0BD
        static let LightGrey = Color(#colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)) // #CCCCCC
        static let Blue5 = Color(#colorLiteral(red: 0.2862745098, green: 0, blue: 0.7568627451, alpha: 1)) // #4900C1
        static let Green2 = Color(#colorLiteral(red: 0.2470588235, green: 0.4392156863, blue: 0.3019607843, alpha: 1)) // #3F704D
        static let Green3 = Color(#colorLiteral(red: 0.2705882353, green: 0.3607843137, blue: 0, alpha: 1)) // #455C00
        static let Green4 = Color(#colorLiteral(red: 0, green: 0.8196078431, blue: 0.2666666667, alpha: 1)) // #00D144
        static let Green5 = Color(#colorLiteral(red: 0.6274509804, green: 0.8705882353, blue: 0, alpha: 1)) // #A0DE00
        static let Orange1 = Color(#colorLiteral(red: 1, green: 0.462745098, blue: 0, alpha: 1)) // #FF7600
        static let Blue6 = Color(#colorLiteral(red: 0.1607843137, green: 0.5607843137, blue: 0.7607843137, alpha: 1)) // #298FC2
        
        static let White4 = Color(#colorLiteral(red: 1, green: 0.9764705882, blue: 0.9333333333, alpha: 1)) // #FFF9EE
        static let VeryLightGrey = Color(#colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)) // #F5F5F5 70%
        static let Gray9 = Color(#colorLiteral(red: 0.7252838016, green: 0.6808145046, blue: 0.6513645649, alpha: 1)) // #52280C 18%
        static let Red2 = Color(#colorLiteral(red: 0.8470588235, green: 0.3019607843, blue: 0.3019607843, alpha: 1)) // #D84D4D
        static let BrightRed = Color(#colorLiteral(red: 0.9176470588, green: 0.262745098, blue: 0.2078431373, alpha: 1)) // #EA4335
        static let Gray10 = Color(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 0.1)) // #007AFF 10%
        static let Blue7 = Color(#colorLiteral(red: 0.1568627451, green: 0.2078431373, blue: 0.4156862745, alpha: 1)) // #28356A
        static let Green6 = Color(#colorLiteral(red: 0.7568627451, green: 0.8392156863, blue: 0.6823529412, alpha: 1)) // #C1D6AE
        static let Gray11 = Color(#colorLiteral(red: 0.3137254902, green: 0.3333333333, blue: 0.3607843137, alpha: 1)) // #50555C
        
        static let LightGray = Color(#colorLiteral(red: 0.7333333333, green: 0.7294117647, blue: 0.7294117647, alpha: 1)) // #BBBABA
        static let Grey13 = Color(#colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)) // #F5F5F5 50%
        static let Gray14 = Color(#colorLiteral(red: 0.4549019608, green: 0.4549019608, blue: 0.4549019608, alpha: 1)) // #747474
        static let White5 = Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7)) // #FFFFFF 70%
        static let Grey = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4)) // #000000 40%
        static let Beige5 = Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)) // #FFFFFF 40%
        static let DarkB = Color(#colorLiteral(red: 0.937254902, green: 0.8901960784, blue: 0.8352941176, alpha: 1)) // #EFE3D5
        static let White6 = Color(#colorLiteral(red: 0.8941176471, green: 0.8941176471, blue: 0.8941176471, alpha: 1)) // #E4E4E4
        static let Gray16 = Color(#colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 0.25)) // #F5F5F5 25%
        
        static let Red4 = Color(#colorLiteral(red: 0.7333333333, green: 0, blue: 0.02352941176, alpha: 1)) // #BB0006
        static let Red5 = Color(#colorLiteral(red: 0.8980392157, green: 0.07843137255, blue: 0.05490196078, alpha: 1)) // #E5140E
        static let White7 = Color(#colorLiteral(red: 0.9450980392, green: 0.9333333333, blue: 0.9294117647, alpha: 1)) // #F1EEED
        static let White8 = Color(#colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)) // #F2F2F2
        static let White9 = Color(#colorLiteral(red: 0.9607843137, green: 0.7490196078, blue: 0.4156862745, alpha: 1)) // #F1EEED
        static let Gray17 = Color(#colorLiteral(red: 0.7647058824, green: 0.737254902, blue: 0.7137254902, alpha: 1)) // #C3BCB6
        static let DarkestGrey = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)) // #000000 50%
        static let Gray19 = Color(#colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)) // #E5E5E5
        static let Gray20 = Color(#colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.262745098, alpha: 0.36)) // #3C3C43
        
        static let Gray21 = Color(#colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 0.5)) // #969696 50%
        static let Gray22 = Color(#colorLiteral(red: 0.937254902, green: 0.8901960784, blue: 0.8352941176, alpha: 0.4)) // #EFE3D5 40%
        static let Black = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)) // #000000
        
     
        


        
    }
}




