//
//  EventInfoViewController.swift
//  FetchRewardsCodingExercise
//
//  Created by David Mompoint on 8/4/21.
//

import UIKit
import CoreData

class EventInfoViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var eventImgView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var returnButton: UIButton!
    
    var eventPassedTitle: String!
    var eventPassedID: Int!
    var eventPassedImg: String!
    var eventPassedDate: String!
    var eventPassedLocation: String!
    
    var likedEventsCoreData: [UserEntity]?
    var likedEventList = [Int]()

    // reference to managed object context global constant
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bodyContentSettings()
        navigationSettings()
        passedData()
        
        heartButton.addTarget(self, action: #selector(heartpressedAction), for: .touchUpInside)
        returnButton.addTarget(self, action: #selector(returnPressed), for: .touchUpInside)
        likedStatus()
    }
    
    //MARK: - DISPLAY SETTINGS & PASSING DATA
    
    func navigationSettings() {
        
        heartButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        
    }
    
    func passedURLImg(converting imageData: String) {
        let url = URL(string: imageData)

        if let data = try? Data(contentsOf: url!) {
            eventImgView.image = UIImage(data: data)
        }
    }
    
    func passedData() {
        
        titleLabel.text = eventPassedTitle
        locationLabel.text = eventPassedLocation
        dateLabel.text = eventPassedDate
        passedURLImg(converting: eventPassedImg)
        
    }
    
    func bodyContentSettings() {
        
        eventImgView.layer.cornerRadius = 15
        eventImgView.contentMode = .scaleAspectFill
        dateLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        locationLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        locationLabel.textColor = .systemGray

    }
    
    // Checks liked status of current event
    
    func likedStatus() {
    
        getItems()
      
        likedEventList = likedEventsCoreData?.isEmpty == true ? [] : likedEventsCoreData![0].savedLikedEvents!
        
        if likedEventList.contains(eventPassedID) {
            heartButton.isSelected = true
            heartButton.tintColor = UIColor.systemRed
            print("TRUE LIKED STATUS")
        }
    }
    
    @objc func heartpressedAction() {
        
        if heartButton.isSelected == true {
            // removing
            heartButton.tintColor = UIColor.black
            heartButton.isSelected = false
            deleteItem()
            
        } else {
            // adding
            heartButton.tintColor = UIColor.systemRed
            heartButton.isSelected = true
            manageCoreData()
        }
    }
    
    @objc func returnPressed() {
        self.dismiss(animated: true, completion: nil)
        
        // call function on here to reset tableView Data
        if let vc = presentingViewController as? ViewController {
            dismiss(animated: true, completion: {vc.resetTableView()})
        }
    }
    
    //MARK: - Core Data Section
    
    // MANAGE CORE DATA
    
    func manageCoreData() {
        getItems()
        
        if likedEventsCoreData?.isEmpty == true {
            setFirstLike()
        } else {
            self.updateItem()
        }
    }
    
    // SET & CREATE FIRST ITEM
    
    func setFirstLike() {
        self.createLikedItems(itemLiked: eventPassedID)
    }
    
    // GET ITEMS
    
    func getItems() {

        do {
            likedEventsCoreData = try context.fetch(UserEntity.fetchRequest())
        }
        catch {
            print("error fetching itms from core data \(error)")
        }
    }
    
    // CREATE
    
    // core data create new list
    func createLikedItems(itemLiked: Int) {
        // only used once if core data is empty
        
        let newItem = UserEntity(context: context)
        likedEventList.append(itemLiked)
        newItem.savedLikedEvents = likedEventList
        
        do {
            try context.save()
        }
        catch {
            print("Could not save newItem \(error)")
        }
    }
    
    // UPDATE
    
    // appending new values being passed in
    func updateItem() {
        
        likedEventList = likedEventsCoreData![0].savedLikedEvents!
        likedEventList.append(eventPassedID)
        
        // passing updated list to function for core Data
        fetchItems(likedList: likedEventList)

        do {
            try context.save()
        }
        catch {
            
            print("error saving item \(error)")
        }
    }

    // DELETE
    
    func deleteItem() {
        
        likedEventList = likedEventsCoreData![0].savedLikedEvents!
        if let indexPath = likedEventList.firstIndex(of: eventPassedID) {
            likedEventList.remove(at: indexPath)
        }
        
        // passing updated list to function for core Data
        fetchItems(likedList: likedEventList)
        
        do {
            try context.save()
        }
        catch {
            
            print("error saving item \(error)")
        }
    }
    
    // FETCH REQUEST & MANIPULATE
    
    // fetch and set new value to core data
    func fetchItems(likedList: [Int]) {
        
        
        let fetchedData = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
        
        do {
            let fetchedResults = try context.fetch(fetchedData) as? [NSManagedObject]
            
            if fetchedResults?.count != 0 {
                fetchedResults![0].setValue(likedEventList, forKey: "savedLikedEvents")
            }
        } catch {
            print("Error in Fetching Data: \(error)")
        }
    }
    
}
