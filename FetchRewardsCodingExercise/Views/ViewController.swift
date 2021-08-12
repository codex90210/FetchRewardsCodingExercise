//
//  ViewController.swift
//  FetchRewardsCodingExercise
//
//  Created by David Mompoint on 8/3/21.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var managerGeekAPI = seatGeekManager()
    
    //array of sets
    
    var filteredEvents = [seatGeekData]()
    var eventArray: [(seatGeekData)] = []
    var eventTitle: String?
    
    var likedEvents: [UserEntity]?
    var likedList = [Int]()
    
    var alertController: UIAlertController!
    var count = 0
    
    // func to reset tableView data
    
    func resetTableView() {
        getItems()
        likedList = likedEvents?.isEmpty == true ? [] : likedEvents![0].savedLikedEvents!
        print("LIKED LIST \(likedList)")
        tableView.reloadData()
    }

    // reference to managed object context global constant
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.rowHeight = 190
        managerGeekAPI.delegate = self
        searchBar.delegate = self
        
        managerGeekAPI.fetchEventURL()
        searchBarSetting()
        getItems()
      
        // setting up liked list
        likedList = likedEvents?.isEmpty == true ? [] : likedEvents![0].savedLikedEvents!
    
    }
  
//MARK: - Refresh Page
    
    func refreshPage() {
        let alert = UIAlertController(title: "Page Not Found", message: "An error occurred when loading this page. Please Refresh", preferredStyle: .alert)
        let refresh = UIAlertAction(title: "Refresh", style: .default) {
            UIAlertAction in self.tableView.reloadData()
        }
        
        alert.addAction(refresh)
        
        self.present(alert, animated: true, completion: nil)
    }

    //MARK: - Core Data Section
    
    func getItems() {

        do {
            likedEvents = try context.fetch(UserEntity.fetchRequest())
        }
        catch {
            print("error fetching itms from core data \(error)")
        }
    }

    //MARK: - Date Format Settings
    
    func dateDisplay(from Event: String) -> String {
        
        let dateTime = Event
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "local") as TimeZone?
        let date = dateFormatter.date(from: dateTime)
        
        dateFormatter.dateFormat = "EEEE, d MMM yyyy\nh:mm a"
        let timeDisplay = dateFormatter.string(from: date!)
        
        return timeDisplay
        
    }
        
    //MARK: - Search Bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // event Array will have data
        var tempData: [(seatGeekData)] = []
        
        for e in 0...eventArray.count - 1 {
            tempData.append(seatGeekData(eventID: eventArray[e].eventID, eventTitle: eventArray[e].eventTitle, eventLocation: eventArray[e].eventLocation, eventDate: eventArray[e].eventDate, eventImg: eventArray[e].eventImg, tbdStatus: eventArray[e].tbdStatus))
            
        }
        
        // update the position of the elements when filtered
        filteredEvents = eventArray
        if searchText.isEmpty == false {
            
            filteredEvents = tempData.filter({ (data) -> Bool in
                let tmp: NSString = NSString(string: data.eventTitle)
                // let range = tmp.rangeOfCharacter(of: searchText, options: .caseInsensitive)
                let range = tmp.range(of: searchText, options: .caseInsensitive)
                return range.location != NSNotFound
            })
            
        }
        tableView.reloadData()
    }
    
    //MARK: - SEARCH BAR SETTINGS
    
    func searchBarSetting() {
        
        // show cancel button
        searchBar.showsCancelButton = true
        
        // creating attribute for search bar color for white color appearance for cancel button
        let attributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        
        // magnifying glass white color appearance
        searchBar.searchTextField.leftView?.tintColor = .white
        
        searchBar.searchTextField.textColor = .white
        
        // tint and background color for search view and search bar
        searchView.backgroundColor = UIColor(red: 37.0/255.0, green: 53.0/255.0, blue: 68.0/255.0, alpha: 1.0)
        searchBar.barTintColor = UIColor(red: 44.0/255.0, green: 63.0/255.0, blue: 79.0/255.0, alpha: 1.0)
    }
    
    func isLoaded() {
       if eventArray.isEmpty == true {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - TABLE VIEW SETTINGS
    
    // return number of cells based off api List
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // temporary fix
        
        if filteredEvents.isEmpty == false {
            return filteredEvents.count
        } else if eventArray.isEmpty == false {
            return eventArray.count
        }
        else {
            // this gets returned
          // pop up alert to handle request...
            refreshPage()
            return 0
        }
    }
    
    // loading data for cell at index path
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! eventCustomCell
        
        // set heart fill default
        cell.heartFill.isHidden = true
        
        // cell heart filled filtering list
        if filteredEvents.isEmpty == false {

            let filteredLikes = filteredEvents[indexPath.row].eventID

            if likedList.contains(filteredLikes) {
                cell.heartFill.isHidden = false
            }
        } else {
            let likedEventID = eventArray[indexPath.row].eventID

            //let num = indexPath.row
            // core data
            if likedList.contains(likedEventID) {
                cell.heartFill.isHidden = false
            }
        }
        
        // setting data type for display
        let title: String
        var image: String
        let location: String
        
        // date inside tableView function
        let date: String
        
        // set date for filtered cells
        if filteredEvents.isEmpty == false {
            
            title = filteredEvents[indexPath.row].eventTitle
            image = filteredEvents[indexPath.row].eventImg
            location = filteredEvents[indexPath.row].eventLocation
            date = filteredEvents[indexPath.row].eventDate
            
            if filteredEvents[indexPath.row].tbdStatus == true {
                cell.dateLabel.text = "TBD"
            } else {
                cell.dateLabel.text = dateDisplay(from: filteredEvents[indexPath.row].eventDate)
            }
            
            // url conversion of filtered image data
            let url = URL(string: image)
            
            if let data = try? Data(contentsOf: url!) {
                cell.eventImage.image = UIImage(data: data)
            }
            
            // set date for unfiltered cells
        } else {
            
            title = eventArray[indexPath.row].eventTitle
            image = eventArray[indexPath.row].eventImg
            location = eventArray[indexPath.row].eventLocation
            date = eventArray[indexPath.row].eventDate
            
            if eventArray[indexPath.row].tbdStatus == true {
                cell.dateLabel.text = "TBD"
            } else {
                cell.dateLabel.text = dateDisplay(from: eventArray[indexPath.row].eventDate)
            }
            
            // url conversion of unfiltered image data
            let url = URL(string: image)
            
            if let data = try? Data(contentsOf: url!) {
                cell.eventImage.image = UIImage(data: data)
            }
        }
        // title & location
        cell.titleLabel.text = title
        cell.locationLabel.text = location
        
        return cell
    }
    
    // passing data when cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nextView = (storyboard?.instantiateViewController(withIdentifier: "nextVC")) as! EventInfoViewController
        
        // funcion based on tbd status condition returns tbd or event date
        func eventDate() -> String {
            
            if filteredEvents.isEmpty == false {
                
                // passing ternary filtered date to next view
                let value = filteredEvents[indexPath.row].tbdStatus == true ? "TBD" : dateDisplay(from: filteredEvents[indexPath.row].eventDate)
                return value
                
            } else {
                
                // passing ternary unfiltered date to next view
                let value = eventArray[indexPath.row].tbdStatus == true ? "TBD" : dateDisplay(from: eventArray[indexPath.row].eventDate)
                return value
            }

        }
        
        // preparing data to pass to next view
        if filteredEvents.isEmpty == false {
            
            nextView.eventPassedTitle = filteredEvents[indexPath.row].eventTitle
            nextView.eventPassedID = filteredEvents[indexPath.row].eventID
            nextView.eventPassedDate = eventDate()
            nextView.eventPassedLocation = filteredEvents[indexPath.row].eventLocation
            nextView.eventPassedImg = filteredEvents[indexPath.row].eventImg
            
        } else {
            
            nextView.eventPassedTitle = eventArray[indexPath.row].eventTitle
            nextView.eventPassedID = eventArray[indexPath.row].eventID
            nextView.eventPassedDate = eventDate()
            nextView.eventPassedLocation = eventArray[indexPath.row].eventLocation
            nextView.eventPassedImg = eventArray[indexPath.row].eventImg
        }
        show(nextView, sender: self)
    }
    
}

extension ViewController: seatGeekManagerDelegate {
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateEvent(_ eventsManager: seatGeekManager, eventData: seatGeekData) {
        for e in allEvents {
            eventArray.append(e)
        }
    }
}
