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
        x.asObservable().observeOn(MainScheduler.instance).subscribe(onNext: { b in
            print(b)
            self.boolRender.image = (b) ? #imageLiteral(resourceName: "b_grean") : #imageLiteral(resourceName: "b_gray")
         }).disposed(by: bag)
        x.value = false
        x.value = true
        toggle(x)
        let imv = UIImageView()
        imv.image = #imageLiteral(resourceName: "img")
        let cs = UIActivityIndicatorView()
    cs.activityIndicatorViewStyle = .whiteLarge
        cs.color = UIColor.blue
        cs.frame = CGRect(x: 200, y: 100, width: 100, height: 100)
        cs.hidesWhenStopped = true
        view.addSubview(imv)
        view.addSubview(cs)
        imv.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        x.asObservable().debounce(1, scheduler: MainScheduler.instance)
            .bind(to:imv.rx.isHidden)
            .disposed(by: bag)
        x.asObservable()
            .bind(to:cs.rx.isAnimating)
            .disposed(by: bag)
    }
let bag = DisposeBag()
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

