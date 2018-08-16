//
//  rxTableViewSections.swift
//  rxswifttttty
//
//  Created by mhmohamed on 8/15/18.
//  Copyright © 2018 Mmustafa. All rights reserved.
//

import Foundation
import  UIKit
import  RxCocoa
import RxSwift
import RxDataSources
struct CustomData {
    var anInt: Int
    var aString: String
    var aCGPoint: CGPoint
}
struct SectionOfCustomData {
    var header: String
    var items: [CustomData]
}
//typealias Item = CustomData

extension SectionOfCustomData: SectionModelType {
    
    init(original: SectionOfCustomData, items: [CustomData]) {
        self = original
        self.items = items
    }
}
class rxTableViewSections : UIViewController {
    @IBOutlet weak var tableView:UITableView!
//    Start by defining your sections with a struct that conforms to the SectionModelType protocol:
//    define the Item typealias: equal to the type of items that the section will contain
//    declare an items property: of type array of Item
    
    //Create a dataSource object and pass it your SectionOfCustomData type:
    let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCustomData>(configureCell: { a,b,c,item in
         let cell = b.dequeueReusableCell(withIdentifier: "cell", for: c)
        cell.textLabel?.text = "Item \(item.anInt): \(item.aString) - \(item.aCGPoint.x):\(item.aCGPoint.y)"

        return cell
    })
    let disposeBag = DisposeBag()
   /* Customize closures on the dataSource as needed:
    configureCell (required)
    titleForHeaderInSection
    titleForFooterInSection
    etc*/
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.titleForHeaderInSection = { ds, index in
            if ds.sectionModels[index].items.count == 0
            {
                return nil
            }
            return ds.sectionModels[index].header
        }
        dataSource.canEditRowAtIndexPath = { a,b in
            return true
        }
        
    
        tableView.rx.setDelegate(self)
        //Define the actual data as an Observable sequence of CustomData objects and bind it to the tableView
        var sections = Variable([
            SectionOfCustomData(header: "First section", items: [] /*[CustomData(anInt: 0, aString: "zero", aCGPoint: CGPoint.zero), CustomData(anInt: 1, aString: "one", aCGPoint: CGPoint(x: 1, y: 1)) ]*/),
            SectionOfCustomData(header: "Second section", items: [CustomData(anInt: 2, aString: "two", aCGPoint: CGPoint(x: 2, y: 2)), CustomData(anInt: 3, aString: "three", aCGPoint: CGPoint(x: 3, y: 3)) ])
        ])
        tableView.rx.modelSelected(CustomData.self).subscribe( { a in
            print(a.element?.anInt)
        }).disposed(by: disposeBag)
        
          (sections).asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3 , execute:{
            sections.value[0].items.append(CustomData(anInt: 1, aString: "one", aCGPoint: CGPoint(x: 1, y: 1)))
            
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 6 , execute:{
            sections.value[1].items.removeAll()
            
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 8 , execute:{
             sections.value = [
                SectionOfCustomData(header: "First section", items: [CustomData(anInt: 0, aString: "zero", aCGPoint: CGPoint.zero), CustomData(anInt: 1, aString: "one", aCGPoint: CGPoint(x: 1, y: 1)) ]),
                SectionOfCustomData(header: "Second section", items: [CustomData(anInt: 2, aString: "two", aCGPoint: CGPoint(x: 2, y: 2)), CustomData(anInt: 3, aString: "three", aCGPoint: CGPoint(x: 3, y: 3)) ])
                ]
        })
    }
   
}

extension rxTableViewSections : UITableViewDelegate {
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UIButton(type: .infoDark)
//    }
}
