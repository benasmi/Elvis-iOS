
import Foundation
import UIKit

struct Theme {
    
    static var backgroundColor:UIColor?
    static var buttonTextColor:UIColor?
    static var buttonBackgroundColor:UIColor?
    static var textColor:UIColor?
    
    //Setting color resources for default theme
    static public func defaultTheme() {
        self.backgroundColor = UIColor.white
        self.buttonTextColor = UIColor.black
        //self.buttonBackgroundColor = UIColor.white
        self.textColor = UIColor.black
        updateDisplay()
    }
    
    //Setting color resources for dark theme
    static public func darkTheme() {
        self.backgroundColor = UIColor.black
        self.buttonTextColor = UIColor.white
        //self.buttonBackgroundColor = UIColor.black
        self.textColor = UIColor.white
        updateDisplay()
    }
    
    static public func updateDisplay() {
        //Changing button theme
        let proxyButton = UIButton.appearance()
        proxyButton.setTitleColor(Theme.buttonTextColor, for: .normal)
        
        //Changing background theme
        let proxyView = UIView.appearance()
        proxyView.backgroundColor = backgroundColor
        
        //Changing textviews
        let proxyTextView = UITextView.appearance()
        proxyTextView.textColor = textColor
        
        
        
        
        
    }
}
