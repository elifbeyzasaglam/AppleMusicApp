//
//  MainVC.swift
//  AppleMusicApp
//
//  Created by ELİF BEYZA SAĞLAM on 5.03.2024.
//
import UIKit

final class MainVC: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private var musicList: [MusicResultsResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        fetchMusic()
    }
    
    private func registerCell() {
        let musicItemCellName = String(describing: MusicItemCell.self)
        let musicItemCellNib = UINib(nibName: musicItemCellName, bundle: nil)
        tableView.register(musicItemCellNib, forCellReuseIdentifier: musicItemCellName)
    }
    
    private func fetchMusic() {
        guard let url = URL(string: "https://rss.applemarketingtools.com/api/v2/tr/music/most-played/50/songs.json") else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                print("error: \(error)")
                return
            }
            
            guard let data else { return }
            
            do {
                let decoder = JSONDecoder()
                let decodedMusicList = try decoder.decode(MusicResponse.self, from: data)
                self.musicList = decodedMusicList.feed?.results ?? []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print(error)
            }
        }
        .resume()
    }
}

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MusicItemCell.self)) as? MusicItemCell {
            cell.prepareCell(with: musicList[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

struct MusicResponse: Decodable {
    let feed: MusicFeedResponse?
}

struct MusicFeedResponse: Decodable {
    let results: [MusicResultsResponse]?
}

struct MusicResultsResponse: Decodable {
    let artistName: String?
    let name: String?
    let artworkUrl100: URL?
}
