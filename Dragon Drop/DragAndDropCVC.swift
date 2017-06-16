//
//  DragAndDropCVC.swift
//  Dragon Drop
//
//  Created by Ish on 6/13/17.
//  Copyright © 2017 Illuminated Bits LLC. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"


extension DragAndDropCVC:UICollectionViewDragDelegate{
    
    //Being Drag
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let item = self.data[indexPath.row]
        let itemProvider = NSItemProvider(object:item)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }

}

extension DragAndDropCVC:UICollectionViewDropDelegate{
    
    
    
    //Move the rows around
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(dropOperation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    
    //Begin Drop
    
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0) //If the path is out of bounds add it to the top
        
        
        for coordinatorItem in coordinator.items{
            
            let itemProvder = coordinatorItem.dragItem.itemProvider
            
            if itemProvder.canLoadObject(ofClass: TrayIcon.self){
                
                
                itemProvder.loadObject(ofClass: TrayIcon.self, completionHandler: { (object, error) in
                    
                    DispatchQueue.main.async {
                        
                        if let source =  coordinatorItem.sourceIndexPath {
                            if source.row != destinationIndexPath.row{
                            let value = self.data[source.row]
                            self.data.remove(at: source.row)
                            self.data.insert(value, at: destinationIndexPath.row)
                                coordinator.drop(coordinatorItem.dragItem, toItemAt: destinationIndexPath)
                                collectionView.reloadSections(IndexSet(integer: 0))
                            }
                            
                        }
                       else if let icon = object as? TrayIcon{
                            collectionView.performBatchUpdates({
                                self.data.insert(icon, at: destinationIndexPath.row)
                                collectionView.insertItems(at: [destinationIndexPath])
                            }, completion: nil)
                            coordinator.drop(coordinatorItem.dragItem, toItemAt: destinationIndexPath)
                            collectionView.reloadSections(IndexSet(integer: 0))
                        }
                        
                        
                        
                    }
                })
            }
        }
        
        
//        guard let item =  coordinator.session.localDragSession?.items.first else {return}
//
//
//
//        collectionView.performBatchUpdates({
//            for i in  coordinator.items{
//
//                if let source =  i.sourceIndexPath {
//                    let value = self.data[source.row]
//                    self.data.remove(at: source.row)
//                    self.data.insert(value, at: destinationIndexPath.row)
//                }
//
//            }
//        }, completion: nil)
    }
    
    
    
    
    
}


class DragAndDropCVC: UICollectionViewController {
    
    let dragon1 = TrayIcon(image: UIImage(named:"dragon1"), name: "Dragon 1")
    let dragon2 = TrayIcon(image: UIImage(named:"dragon2"), name: "Dragon 2")
    let dragon3 = TrayIcon(image: UIImage(named:"dragon3"), name: "Dragon 3")
    let dragon4 = TrayIcon(image: UIImage(named:"dragon4"), name: "Dragon 4")
    
    
    var data:[TrayIcon] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = [dragon1,dragon2,dragon3,dragon4]
        self.collectionView?.reorderingCadence = .slow
        self.collectionView?.dragDelegate = self
        self.collectionView?.dropDelegate = self
        self.collectionView?.dragInteractionEnabled = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
       // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

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
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return data.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? DragAndDropCell else {return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)}
    
        // Configure the cell
        let item = data[indexPath.row]
        
        cell.imageView.image = item.image
        
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
