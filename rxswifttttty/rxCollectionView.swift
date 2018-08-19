//
//  rxCollectionView.swift
//  rxswifttttty
//
//  Created by mhmohamed on 8/19/18.
//  Copyright © 2018 Mmustafa. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
//extension String : IdentifiableType {
//    public typealias Identity = String
//    public var identity :Identity  { return self}
//}
struct animatedSectionModel {
    let title:String
    var data :[String]
}
extension animatedSectionModel : AnimatableSectionModelType {
    typealias Identity = String
    typealias Item = String
    var identity : Identity {return title}
    var items : [Item] { return data}
    init(original: animatedSectionModel, items: [Item]) {
        self = original
        data = items
    }
}

class customCollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var title : UILabel!
}
class CustomHeader :  UICollectionReusableView {
    @IBOutlet weak var title : UILabel!
}
class RxCollectionView : UIViewController {
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var addNewTabBar : UIBarButtonItem!
    var longPressGesture : UILongPressGestureRecognizer?
    let disposeBag = DisposeBag()
    
    
    let dataSource = RxCollectionViewSectionedAnimatedDataSource<animatedSectionModel>(configureCell: {
        
        a,b,indexPath ,d in
        if let cell =  b.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? customCollectionViewCell {
            cell.title.text = d
            return cell
        }
        return UICollectionViewCell()
        
    }, configureSupplementaryView: {
     ds , cv , str , indexPath  in
        if let header = cv.dequeueReusableSupplementaryView(ofKind: str, withReuseIdentifier: "header", for: indexPath) as? CustomHeader{
            header.title.text = ds.sectionModels[indexPath.section].title
            return header
        }
        return UICollectionReusableView()
    })
    
    let data = Variable([animatedSectionModel (title: "Section 1", data: ["0-0"])])
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data.asObservable().bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        addNewTabBar.rx.tap.asDriver().drive(onNext: {[unowned self] in
            print ("tapped")
             var g = [String]()
            for i in 0 ..< self.data.value.count
            {
                g.append( "\(self.data.value.count)-\(i)")
            }
            self.data.value.append(animatedSectionModel(title: "section \(self.data.value.count)" , data: g ))
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
}
