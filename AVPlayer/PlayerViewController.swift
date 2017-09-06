//
//  PlayerViewController.swift
//  AVPlayer
//
//  Created by Francis Tseng on 2017/9/6.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

private var playerViewControllerKVOContext = 0

class PlayerViewController: UIViewController, UISearchBarDelegate {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let searchBarView = UIView()

    let searchController = UISearchController(searchResultsController: nil)

    var videoURL = ""

    let bottomView = UIView()

    let playPauseButton = UIButton()

    let muteButton = UIButton()
    
    static let assetKeysRequiredToPlay = [
        "playable",
        "hasProtectedContent"
    ]
    
    let player = AVPlayer()

    let playerView = PlayerView()

    private var playerLayer: AVPlayerLayer? {
        return playerView.playerLayer
    }

    private var playerItem: AVPlayerItem? = nil {
        didSet {
            player.replaceCurrentItem(with: self.playerItem)
        }
    }

    var asset: AVURLAsset? {
        didSet {
            guard let newAsset = asset else { return }
            asynchronouslyLoadURLAsset(newAsset)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(playerView)
        self.view.addSubview(searchController.searchBar)
        self.view.addSubview(bottomView)

        setUpPlayerView()
        setupSearchBarView()
        setUpBottomView()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        addObserver(self, forKeyPath: #keyPath(PlayerViewController.player.currentItem.status), options: [.new, .initial], context: &playerViewControllerKVOContext)
        playerView.playerLayer.player = player

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        player.pause()

        removeObserver(self, forKeyPath: #keyPath(PlayerViewController.player.currentItem.status), context: &playerViewControllerKVOContext)
    }

    func setUpPlayPauseButton() {
        playPauseButton.backgroundColor = .clear
        playPauseButton.tintColor = .white
        playPauseButton.setTitle("Play", for: .normal)
        playPauseButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
        playPauseButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
        playPauseButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        playPauseButton.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.addTarget(self, action: #selector(playPausePressed), for: .touchUpInside)
    }

    func setUpMuteButton() {
        muteButton.backgroundColor = .clear
        muteButton.tintColor = .white
        muteButton.setTitle("Mute", for: .normal)
        muteButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0).isActive = true
        muteButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
        muteButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        muteButton.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        muteButton.translatesAutoresizingMaskIntoConstraints = false
        muteButton.addTarget(self, action: #selector(muteButtonPressed), for: .touchUpInside)
        
    }
    
    func setupSearchBarView() {
        self.view.addSubview(searchBarView)
        self.searchBarView.addSubview(self.searchController.searchBar)
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = UIColor(red: 8.0/255.0, green: 21.0/255.0, blue: 35.0/255.0, alpha: 1.0)
        searchBarView.backgroundColor = UIColor(red: 8.0/255.0, green: 21.0/255.0, blue: 35.0/255.0, alpha: 1.0)
        searchBarView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIApplication.shared.statusBarFrame.size.height).isActive = true
        searchBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        searchBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        searchBarView.heightAnchor.constraint(equalToConstant: self.searchController.searchBar.frame.height).isActive = true
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
    }

    func setUpPlayerView() {
        playerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
        playerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true
        playerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0).isActive = true
        playerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.backgroundColor = UIColor(red: 8/255.0, green: 21/255.0, blue: 35/255.0, alpha: 1)
        playerView.frame = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }

    func playPausePressed() {

        if player.rate != 1.0 {
            playPauseButton.setTitle("Pause", for: .normal)
            player.play()
        }
        else {
            player.pause()
            playPauseButton.setTitle("Play", for: .normal)
        }
    }

    func muteButtonPressed() {
        if player.volume != 0.0 {
            muteButton.setTitle("UnMute", for: .normal)
            player.volume = 0.0
        }
        else {
            muteButton.setTitle("Mute", for: .normal)
            player.volume = 1.0
        }
    }

    func setUpBottomView() {

        bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        bottomView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.layer.shadowOpacity = 1
        bottomView.layer.shadowColor = UIColor(red: 169/255.0, green: 169/255.0, blue: 169/255.0, alpha: 0.2).cgColor
        bottomView.layer.shadowOffset = CGSize(width: 0, height: -0.5)

    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)

    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)

        searchBar.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        videoURL = searchBar.text ?? ""
        searchBar.text = nil
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)

        self.bottomView.addSubview(playPauseButton)

        setUpPlayPauseButton()

        self.bottomView.addSubview(muteButton)
        
        setUpMuteButton()
        
        let movieURL = URL(string: videoURL)

        guard let url = movieURL else { return }

        asset = AVURLAsset(url: url, options: nil)

        player.play()

        playPauseButton.setTitle("Pause", for: .normal)
    }

    func asynchronouslyLoadURLAsset(_ newAsset: AVURLAsset) {
        /*
         Using AVAsset now runs the risk of blocking the current thread (the
         main UI thread) whilst I/O happens to populate the properties. It's
         prudent to defer our work until the properties we need have been loaded.
         */
        newAsset.loadValuesAsynchronously(forKeys: PlayerViewController.assetKeysRequiredToPlay) {
            /*
             The asset invokes its completion handler on an arbitrary queue.
             To avoid multiple threads using our internal state at the same time
             we'll elect to use the main thread at all times, let's dispatch
             our handler to the main queue.
             */
            DispatchQueue.main.async {
                /*
                 `self.asset` has already changed! No point continuing because
                 another `newAsset` will come along in a moment.
                 */
                guard newAsset == self.asset else { return }
                
                /*
                 Test whether the values of each of the keys we need have been
                 successfully loaded.
                 */
                for key in PlayerViewController.assetKeysRequiredToPlay {
                    var error: NSError?
                    
                    if newAsset.statusOfValue(forKey: key, error: &error) == .failed {
                        let stringFormat = NSLocalizedString("error.asset_key_%@_failed.description", comment: "Can't use this AVAsset because one of it's keys failed to load")
                        
                        let message = String.localizedStringWithFormat(stringFormat, key)
                        
                        self.handleErrorWithMessage(message, error: error)

                        return
                    }
                }

                // We can't play this asset.
                if !newAsset.isPlayable || newAsset.hasProtectedContent {
                    let message = NSLocalizedString("error.asset_not_playable.description", comment: "Can't use this AVAsset because it isn't playable or has protected content")

                    self.handleErrorWithMessage(message)

                    return
                }

                /*
                 We can play this asset. Create a new `AVPlayerItem` and make
                 it our player's current item.
                 */
                self.playerItem = AVPlayerItem(asset: newAsset)
            }
        }
    }

    // MARK: - KVO Observation

    // Update our UI when player or `player.currentItem` changes.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        // Make sure the this KVO callback was intended for this view controller.
        guard context == &playerViewControllerKVOContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }

        if keyPath == #keyPath(PlayerViewController.player.currentItem.status) {
            // Display an error if status becomes `.Failed`.

            /*
             Handle `NSNull` value for `NSKeyValueChangeNewKey`, i.e. when
             `player.currentItem` is nil.
             */
            let newStatus: AVPlayerItemStatus

            if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                newStatus = AVPlayerItemStatus(rawValue: newStatusAsNumber.intValue)!
            }
            else {
                newStatus = .unknown
            }

            if newStatus == .failed {
                handleErrorWithMessage(player.currentItem?.error?.localizedDescription, error:player.currentItem?.error)
            }
        }
    }

    // Trigger KVO for anyone observing our properties affected by player and player.currentItem
    override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        let affectedKeyPathsMappingByKey: [String: Set<String>] = [
            "duration": [#keyPath(PlayerViewController.player.currentItem.duration)],
            "rate": [#keyPath(PlayerViewController.player.rate)]
        ]

        return affectedKeyPathsMappingByKey[key] ?? super.keyPathsForValuesAffectingValue(forKey: key)
    }

    func handleErrorWithMessage(_ message: String?, error: Error? = nil) {
        NSLog("Error occured with message: \(message), error: \(error).")

        let alertTitle = NSLocalizedString("alert.error.title", comment: "Alert title for errors")
        let defaultAlertMessage = NSLocalizedString("error.default.description", comment: "Default error message when no NSError provided")

        let alert = UIAlertController(title: alertTitle, message: message == nil ? defaultAlertMessage : message, preferredStyle: UIAlertControllerStyle.alert)

        let alertActionTitle = NSLocalizedString("alert.error.actions.OK", comment: "OK on error alert")

        let alertAction = UIAlertAction(title: alertActionTitle, style: .default, handler: nil)

        alert.addAction(alertAction)

        present(alert, animated: true, completion: nil)
    }

}
