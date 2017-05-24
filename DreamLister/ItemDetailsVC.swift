//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Munene Kaumbutho on 2017-05-23.
//  Copyright © 2017 Munene Kaumbutho. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    
    var stores = [Store]()
    var itemToEdit: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        
        storePicker.delegate = self
        storePicker.dataSource = self
        /* 
        let store = Store(context: context)
        store.name = "Apple Store"
        
        let store2 = Store(context: context)
        store2.name = "Microsoft Store"
        
        let store3 = Store(context: context)
        store3.name = "Amazon"
        
        let store4 = Store(context: context)
        store4.name = "Ikea"
        
        let store5 = Store(context: context)
        store5.name = "Banana Republic"
        
        ad.saveContext()
         */
        getStores()
        
        if itemToEdit != nil {
            loadItemData()
        }
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
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // update when selected:
    }
    
    func getStores(){
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            // handle error:
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
        var item: Item!
        
        if itemToEdit == nil {
        
            item = Item(context: context)
            
        } else {
            
            item = itemToEdit
        }
        
        
        if let title = titleField.text {
            
            item.title = title
        }
        
        if let price = priceField.text {
            
            item.price = (price as NSString).doubleValue
        }
        
        if let details = detailsField.text {
            
            item.details = details
        }
        
        // recall that an Item has a store and a store has many items as created in the DB: - therefore we can give an item a srore by doing the following:
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)] // user storePicer to get the store we want. We only have one of them so we use 0.
        
        ad.saveContext()
        
        // how to go to the previous controller:
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    // going to create a function below that loads item data for editting:
    func loadItemData(){
        
        if let item = itemToEdit {
            
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            
            // an item will have many stores. Therefore we need to pick the correct store for the item we choose to edit - we want the picker to take this value. the reeat while loop below will find this value for us, by comparing the store that the current item has matches one the sotres in the list of them: - if so then the storePicker can retreive the correct row.
            if let store = item.toStore {
                var index = 0
                repeat {
                    let s = stores[index]
                    if s.name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                } while (index < stores.count)
            }
        }
    }
    

}
