//
//  SimpleReorderTVC.swift
//  Dragon Drop
//
//  Created by Demo on 6/13/17.
//  Copyright © 2017 Illuminated Bits LLC. All rights reserved.
//

import UIKit

extension SimpleReorderTVC:UITableViewDragDelegate{
    
    //Being Drag
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.data[indexPath.row]
        let itemProvider = NSItemProvider(object: NSString(string: item))
       
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }
    
}

extension SimpleReorderTVC:UITableViewDropDelegate{
    
    //Move the rows around
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        
    return UITableViewDropProposal(dropOperation: .move, intent: .insertAtDestinationIndexPath)
        
    }
    

    //Begin Drop
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0) //If the path is out of bounds add it to the top
        
        
        guard let item =  coordinator.session.localDragSession?.items.first else {return}
        
        for coordinatorItem in coordinator.items{
            
            let itemProvder = coordinatorItem.dragItem.itemProvider
            
            if itemProvder.canLoadObject(ofClass: TrayIcon.self){
                
                
                itemProvder.loadObject(ofClass: TrayIcon.self, completionHandler: { (object, error) in
                    print (error?.localizedDescription)
                    DispatchQueue.main.async {
                        
                        if let source =  coordinatorItem.sourceIndexPath {
                            let value = self.data[source.row]
                            self.data.remove(at: source.row)
                            self.data.insert(value, at: destinationIndexPath.row)
                        }
                        else if let icon = object as? TrayIcon{
                            if let title = icon.title{
                            self.data.insert(title as String, at: destinationIndexPath.row)
                            coordinator.drop(coordinatorItem.dragItem, toRowAt: destinationIndexPath)
                                tableView.reloadSections(IndexSet(integer: 0),with:.automatic)
                            }
                        }
                        
                        coordinator.drop(item, toRowAt: destinationIndexPath)
                        tableView.reloadData()
                        
                        
                    }
                })
            }
        }
        
       
        
  
    }
    
    
    
}

class SimpleReorderTVC: UITableViewController {
    
    var data = ["Viserion","Saphira","Smaug"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dragDelegate = self
        self.tableView.dropDelegate = self
        self.tableView.dragInteractionEnabled = true   //This is for iPhone Support
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = data[indexPath.row]

        return cell
    }
 
    
    
}
