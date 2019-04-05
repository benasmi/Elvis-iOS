
import Foundation
import UIKit


struct Theme {
    
    static var backgroundColor:UIColor?
    static var buttonTextColor:UIColor?
    static var buttonBackgroundColor:UIColor?
    static var textFieldBackground: UIColor?
    static var labelColor:UIColor?
    static var textFieldtextColor:UIColor?
    
    static var secondaryButtonTextColor:UIColor?
    static var secondaryButtonBackgroundColor:UIColor?
    
    static let colorAccent:UIColor = Utils.hexStringToUIColor(hex: "#F39C12")
    static let colorAccentDark:UIColor = Utils.hexStringToUIColor(hex: "#535C68")
    
    static public func toggleTheme(viewController: UIViewController){
        
        let isDarkModeEnabled = Utils.readFromSharedPreferences(key: "isDarkModeEnabled") as? Bool ?? false
        
        
        if(isDarkModeEnabled){
            print("Switching to default theme...")
            Theme.darkTheme()
            
        }else{
            print("Switching to dark theme...")
            Theme.defaultTheme()
        }
        
        //viewController.loadView()
        DispatchQueue.main.async {
            for window in UIApplication.shared.windows {
                for view in window.subviews {
                    view.removeFromSuperview()
                    window.addSubview(view)
                }
                // update the status bar if you change the appearance of it.
                window.rootViewController?.setNeedsStatusBarAppearanceUpdate()
            }
            
            
            
        }
        
        
        Utils.writeToSharedPreferences(key: "isDarkModeEnabled", value: !isDarkModeEnabled)
    }
    
    static public func setUp(){
        let isDarkModeEnabled = Utils.readFromSharedPreferences(key: "isDarkModeEnabled") as? Bool ?? false
        DispatchQueue.main.async {
            if(isDarkModeEnabled){
                Theme.defaultTheme()
            }else{
                Theme.darkTheme()
            }
        }
    }
    
    static public func defaultTheme() {
        self.backgroundColor = UIColor.white
        self.buttonTextColor = UIColor.black
        self.buttonBackgroundColor = UIColor.clear
        self.labelColor = UIColor.black;
        self.textFieldBackground = UIColor.white
        self.textFieldtextColor = UIColor.black
        self.secondaryButtonTextColor = UIColor.white
        self.secondaryButtonBackgroundColor = UIColor.black
        updateDisplay()
    }
    
    static public func darkTheme() {
        self.backgroundColor = UIColor.black
        self.buttonTextColor = UIColor.white
        self.buttonBackgroundColor = UIColor.clear
        self.labelColor = UIColor.white
        self.secondaryButtonTextColor = UIColor.black
        self.secondaryButtonBackgroundColor = UIColor.white
        self.textFieldtextColor = UIColor.black
        self.textFieldBackground = UIColor.white
        updateDisplay()
    }
    
    
    
    static public func updateDisplay() {
        let buttonDefault = UIButtonDefault.appearance()
        buttonDefault.setTitleColor(Theme.buttonTextColor, for: .normal)
        buttonDefault.backgroundColor = Theme.buttonBackgroundColor
        
        
        let background = UIBackground.appearance()
        background.backgroundColor = backgroundColor
        
        let topBar = UITopBar.appearance()
        topBar.backgroundColor = colorAccent
        
        let buttonSecondary = UIButtonSecondary.appearance()
        buttonSecondary.backgroundColor = secondaryButtonBackgroundColor
        buttonSecondary.setTitleColor(secondaryButtonTextColor, for: .normal)
        
        let tableViewBackground = UITableViewBackground.appearance()
        tableViewBackground.backgroundColor = backgroundColor
        
        let uiCell = UICell.appearance()
        uiCell.backgroundColor = backgroundColor
        
        let labelPrimary = UILabelPrimary.appearance()
        labelPrimary.textColor = labelColor
        
        let textFieldPrimary = UITextFieldPrimary.appearance()
        textFieldPrimary.textColor = textFieldtextColor
        textFieldPrimary.backgroundColor = textFieldBackground
        
    }
}
