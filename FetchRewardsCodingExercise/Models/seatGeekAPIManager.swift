//
//  seatGeekAPIManager.swift
//  FetchRewardsCodingExercise
//
//  Created by David Mompoint on 8/6/21.
//

// API Managed Requests

import Foundation

var allEvents = [(seatGeekData)]()

protocol seatGeekManagerDelegate {
    
    func didUpdateEvent(_ eventsManager: seatGeekManager, eventData: seatGeekData)
    
    // function to catch any API failure requests
    func didFailWithError(error: Error)
}

struct seatGeekManager {
    
    // API ID
    let idAPI = ""
    
    // SECRET KEY
    
    let sKey = ""
    
    // URL
    let seatGeekURL = "https://api.seatgeek.com/2/events"
    
    var delegate: seatGeekManagerDelegate?
    
    // fetching data utilizing string interpolation
    
    func fetchEventURL() {
        
        let eventURL = "\(seatGeekURL)?\(idAPI)&\(sKey)"
        print(eventURL)
        
        // calling perform request
        performRequest(with: eventURL)
        
    }
    
    //MARK: - Five Day Forecast Data
    // performs URL Request obtaining data from SeatGeek API
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let eventsData = self.parseJSON(safeData){
                        self.delegate?.didUpdateEvent(self, eventData: eventsData)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ dataEvents: Data) -> seatGeekData? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(eventData.self, from: dataEvents)
            
            for events in 0...decodedData.events.count - 1 {

                let id = (decodedData.events[events].id)
                let title = (decodedData.events[events].title)
                let location = (decodedData.events[events].venue.display_location)
                let date = (decodedData.events[events].datetime_local)
                let image = (decodedData.events[events].performers[0].image)
                let tbdStatus = (decodedData.events[events].time_tbd)
                
                // appending values into allEvents array which will be used in main view for iteration
                
                allEvents.append(seatGeekData(eventID: id, eventTitle: title, eventLocation: location, eventDate: date, eventImg: image, tbdStatus: tbdStatus))
                
            }
            // to test if first value has returned properly from API.
            
            let id = (decodedData.events[0].id)
            let title = (decodedData.events[0].title)
            let location = (decodedData.events[0].venue.display_location)
            let date = (decodedData.events[0].datetime_local)
            let image = (decodedData.events[0].performers[0].image)
            let tbdStatus = (decodedData.events[0].time_tbd)
            
            let eventInfo = seatGeekData(eventID: id, eventTitle: title, eventLocation: location, eventDate: date, eventImg: image, tbdStatus: tbdStatus)
            
            //print(eventInfo)
            return eventInfo
            
        } catch {
            delegate?.didFailWithError(error: error)
            print("error getting data")
            return nil
        }
    }
}
