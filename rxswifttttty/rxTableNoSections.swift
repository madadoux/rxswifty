//
//  rxTableNoSections.swift
//  rxswifttttty
//
//  Created by Mmustafa on 8/2/18.
//  Copyright © 2018 Mmustafa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class rxTableNoSections: UIViewController , UITableViewDelegate{
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField : UITextField!
    @IBOutlet weak var label : UILabel!
let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = Variable( ["ahmed" , "sally" , "peter" , "nader"])
    
        data.asObservable().bindTo(tableView.rx.items(cellIdentifier: "cell") ){
            _,model,cell in
            cell.textLabel?.text = model
            }.disposed(by: disposeBag)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3 , execute:{
            data.value = ["ahmed" , "ayay"]
            
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 4 , execute:{
            data.value = ["ahmed" , "qweqweqw"]
            
        })
        
        let str = Variable("Hello")
        textField.rx.text.orEmpty.bind(to: str).disposed(by: disposeBag)
        textField.rx.text.orEmpty.subscribe { (s) in
            print(str.value)
        }
        textField.rx.text.asDriver().drive(label.rx.text).disposed(by: disposeBag)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4 , execute:{
            str.value = "eqweqw"
            
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
