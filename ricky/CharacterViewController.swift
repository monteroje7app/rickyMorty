//
//  CharacterViewController.swift
//  ricky
//
//  Created by Jose Montero on 5/10/22.
//

import Foundation
import Alamofire
import UIKit

class CharacterViewController: BaseViewController {
    
    var character_: Character?
    private var episodes: [Episode] = []
    var sections : [ String : [Episode] ] = [:]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let character = character_, character.episode != [] else { return }
        var urls : [String] = []
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "episodeCell")

        urls.append(contentsOf: character.episode)
        fetchAllEpisode(urls: urls, completionHandler:{
            print("TERMINO 1--\(self.episodes.count)")
            let grouped = Dictionary(grouping: self.episodes, by: { $0.episode?.prefix(3)})
            grouped.forEach({(key, value) in
                let s = key.map({
                    return String($0)
                })
                self.sections[s!] = value
            })
             
            self.tableView.reloadData()
        })
       // fetchEpisode(url: character.episode.first)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let character = character_ else { return }
           self.title = character.name
    }
    
    
    private func fetchAllEpisode(urls: [String],  completionHandler: @escaping () -> Void) {
        var pendingURLs = urls
        
        func startNext() {
            guard let url = pendingURLs.first else {
                completionHandler()
                return
            }
            pendingURLs.removeFirst()
            fetchEpisode(url: url, completionHandler: {
                startNext()
            })
        }
        startNext()
    }
    private func fetchEpisode(url: String?, completionHandler: @escaping () -> Void) {
        showSpinner()
        guard let url = url else {return}
        AF.request(url).validate().responseDecodable(of: Episode.self) { [self] (response) in
                guard let ep = response.value else { return }
                self.episodes.append(ep)
                DispatchQueue.main.async {
                    completionHandler()
                    hideSpinner()
                    print(episodes)
                }
    }
    
    }
}

extension CharacterViewController: UITableViewDelegate {
    
}

extension CharacterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionKey : [String] = self.sections.keys.map({$0})
        return self.sections[sectionKey[section]]?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.sections.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView .dequeueReusableCell(withIdentifier: "episodeCell", for: indexPath)
        if cell == nil || cell.detailTextLabel == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "episodeCell")
        }
        
        let sectionKey : [String] = self.sections.keys.map({$0})
        let section =  self.sections[sectionKey[indexPath.section]]
        if let s = section {
        cell.textLabel!.text = s[indexPath.row].name
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_EN")
            dateFormatter.dateFormat = "MMMM dd, yyyy"
            let date = dateFormatter.date(from: s[indexPath.row].airDate!)
            let dateFormatter_es = DateFormatter()
            dateFormatter_es.locale = Locale(identifier: "es_ES")
            dateFormatter_es.dateFormat = "dd' de 'MMMM' de 'yyyy"
            cell.detailTextLabel!.text = dateFormatter_es.string(from: date!)
        }
        return cell
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         let sectionKey : [String] = self.sections.keys.map({$0})
         
        return sectionKey[section]
    }
    
    
}
