//
//  ViewController.swift
//  DreamLister
//
//  Created by Munene Kaumbutho on 2017-05-22.
//  Copyright © 2017 Munene Kaumbutho. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var controller: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        
        attemptFetch()
        //generateTestData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // All the data comes in batches and we want to know how many rows should appear per batch:
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // all data is recieved in batches - so we need to find the no. of sections from it:
        if let sections = controller.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 154
    }
    
    // secondary configureCell method for handling core data
    func configureCell(cell: ItemCell, indexPath: NSIndexPath){
        // we use our controller to get an object that we set as our item. we can then give this to the ItemCell view:
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    }
    
    func attemptFetch(){
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        // sort results by date: We give it a key in order to sort the result with and a boolean determining DESC or ASC
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        
        fetchRequest.sortDescriptors = [dateSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        // need to give controller a delegate so that all controllerWillChangeContext, controllerDidChangeContent methods know which controller they are supposed to deal with:
        controller.delegate = self
        
        // set controller on outside to the one here:
        self.controller = controller
        
        // a fetch request may fail so let us place it in a do-catch:
        do {
            
            try controller.performFetch()
            
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        // have to deal with all different cases: insert, delete, move, update, when interacting with the DB:
        switch(type) {
            
            // when creating a new item - add it to the new index path for the table view that is used here:
            case.insert:
                if let indexPath = newIndexPath {
                    tableView.insertRows(at: [indexPath], with: .fade)
                }
                break
            
            // when item is deleted, remove it from the table view at that indexPath
            case.delete:
                if let indexPath = indexPath {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                break
            
            // when an existing item is clicked on and we want it to be updated:
            case.update:
                if let indexPath = indexPath {
                    let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                    // Once we have the correct cell, we can pass it to our configureCell method that can pass then pass in everything to the view.
                    configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
                }
                break
            // when cell item is being dragged from place to place - we want the old item to be placed at the new index path
            case.move:
                if let indexPath = indexPath {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                if let indexPath = newIndexPath {
                   tableView.insertRows(at: [indexPath], with: .fade)
                }
                break
        }
    }
    
    func generateTestData() {
        let item = Item(context: context)
        item.title = "Macbook Pro"
        item.price = 1800
        item.details = "I cant wait until the september event."
        
        let item2 = Item(context: context)
        item2.title = "Bose Headphones"
        item2.price = 300
        item2.details = "Need some of that noise cancelling stuff."
        
        let item3 = Item(context: context)
        item3.title = "Audi S5"
        item3.price = 180000
        item3.details = "this is my car!!!"
        
        // calling this will add the above to the database when we run the app the first time. If we run the app again it will save everything again!
        ad.saveContext()
        
        
    }
    
    
}

