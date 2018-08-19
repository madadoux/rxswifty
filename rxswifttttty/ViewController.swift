//
//  ViewController.swift
//  rxswifttttty
//
//  Created by Mmustafa on 7/22/18.
//  Copyright © 2018 Mmustafa. All rights reserved.
//

import UIKit
import RxSwift
import PopupDialog

class ViewController: UIViewController {
    @IBOutlet weak var  boolRender : UIImageView!
    fileprivate func toggle(_ x: Variable<Bool>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1 , execute:{
            x.value = !x.value
            self.toggle(x)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let names = Variable(["ahmed"])
           self.boolRender.image =  #imageLiteral(resourceName: "b_grean")
        names.asObservable()
            .filter({ (value) -> Bool in
                return value.count > 0
            })
         
            .subscribe(onNext: { (value) in
            print (value)
        }).disposed(by: DisposeBag())
        names.value = ["halo", "beda"]
        names.value = ["halo"]
       let x = Variable(false)
        x.asObservable().subscribe(onNext: { b in
            print(b)
            DispatchQueue.main.async{
            self.boolRender.image = (b) ? #imageLiteral(resourceName: "b_grean") : #imageLiteral(resourceName: "b_gray")
            }
         }).disposed(by: DisposeBag())
        x.value = false
        x.value = true
        toggle(x)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super
        .viewDidAppear(true)
      
        // Prepare the popup assets
        let title = "THIS IS THE DIALOG TITLE"
        let message = "This is the message section of the popup dialog default view"
        let image = UIImage(named: "img")
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image)
        
        // Create buttons
        let buttonOne = CancelButton(title: "CANCEL") {
            print("You canceled the car dialog.")
        }
        
        // This button will not the dismiss the dialog
        let buttonTwo = DefaultButton(title: "ADMIRE CAR", dismissOnTap: false) {
            print("What a beauty!")
        }
        
        let buttonThree = DefaultButton(title: "BUY CAR", height: 60) {
            print("Ah, maybe next time :)")
        }
        
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([buttonOne, buttonTwo, buttonThree])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
}

