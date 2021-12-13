//
//  ListViewController.swift
//  TravelBook
//
//  Created by Hüseyin BAKAR on 13.12.2021.
//

import UIKit
import CoreData

 class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var titleArray = [String]()
    var idArray = [UUID]()
    
    var chosenTitle = ""
    var chosenTitleID : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(gotoDetail))
        
         getData()
    
    }
    
    @objc func gotoDetail()
    {
        chosenTitle = ""
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
    }
    
    
  
   @objc func getData()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
         let results = try context.fetch(fetchRequest)
            if results.count > 0
            {
                self.titleArray.removeAll(keepingCapacity: false)
                self.idArray.removeAll(keepingCapacity: false)
                
                
                for result in results as! [NSManagedObject]
                {
                   if let title = result.value(forKey: "title") as? String
                   {
                    self.titleArray.append(title)
                   }
                    
                    if let id = result.value(forKey: "id") as? UUID
                    {
                        self.idArray.append(id)
                    }
                }
            }
        }
        catch
        {
            print("Hata")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        chosenTitle = titleArray[indexPath.row]
        chosenTitleID = idArray[indexPath.row]
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toViewController"
        {
            let vc = segue.destination as! ViewController
            vc.selectedTitle = chosenTitle
            vc.selectedTitleID = chosenTitleID
        }
    }

}

