//
//  Player.swift
//  Shellify
//
//  Created by Marina De Pazzi and Diego Henrique on 17/03/21.
//

import Foundation
import AVFoundation

class Player {
    var player: AVAudioPlayer?
    var songList: [Song]
    
    init () {
        songList = []
    }
    
    func loadPlaylist(userPath: String) throws {
        let searchPath = FileManager.default
        do {
            let songsURLs = try searchPath.contentsOfDirectory(atPath: userPath)
            for paths in songsURLs {
                try addSong(songName: userPath + "/" + paths)
            }
        } catch (ShellifyError.UnknownPath) {
        throw ShellifyError.UnknownPath
        }
    }

    
    func addSong(songName : String) throws {
        let searchPath = FileManager.default

        if searchPath.fileExists(atPath: songName) {
            var newSong = Song(name: "", artist: "", albumName: "", duration: 0, URL: songName)
            let urlString = URL(fileURLWithPath: songName)
            let avpItem = AVPlayerItem(url: urlString)
            let commonMetaData = avpItem.asset.commonMetadata
                for item in commonMetaData {
                    if item.commonKey?.rawValue == "title" {
                        guard let songTitle = item.stringValue else {
                            throw ShellifyError.SongParametrizationFailed
                        }
                        newSong.name = songTitle
                    }
                    if item.commonKey?.rawValue == "artist" {
                        guard let songArtist = item.stringValue else {
                            throw ShellifyError.SongParametrizationFailed
                        }
                        newSong.artist = songArtist
                    }
                    if item.commonKey?.rawValue == "albumName" {
                        guard let songAlbum = item.stringValue else {
                            throw ShellifyError.SongParametrizationFailed
                        }
                        newSong.albumName = songAlbum
                    }
                }
            do {
                let player = try AVAudioPlayer(contentsOf: urlString)
                newSong.duration = player.duration
            } catch (ShellifyError.SongParametrizationFailed) {
                throw ShellifyError.SongParametrizationFailed
               }
            songList.append(newSong)
        }
        else {
            throw ShellifyError.SongFileNotFound
        }
    }
    
    func playSong(songName: String?) throws {
        if let player = player, player.isPlaying {
            player.stop()
            try playSong(songName: songName)
        }
        else {
            
            do {
                guard let songPath = try isSongValid(songName: songName) else {
                    throw ShellifyError.SongNotFound
                }
            
                let searchPath = FileManager.default
    
                if searchPath.fileExists(atPath: songPath) {
                    let urlString = URL(fileURLWithPath: songPath)
                    do {
                        player = try AVAudioPlayer(contentsOf: urlString)
                        
                        guard let player = player else {
                            throw ShellifyError.PlaybackError
                        }
                        player.prepareToPlay()
                        player.play()
                        return
                    } catch (ShellifyError.SongFileNotFound) {
                        throw ShellifyError.SongFileNotFound
                    }
                }
                else {
                    throw ShellifyError.SongNotFound
                }
            }
        }
    }

    func continueReproduction() throws {
        do {
            if try !isPlaying() {
                player?.play()
            }
        } catch (ShellifyError.PlaybackError){
            throw ShellifyError.PlaybackError
        }
    }
    
    func skipSong() throws -> Song? {
        do {
            if try isPlaying() {
                player?.stop()
                for i in songList.indices {
                    let stringURL = player!.url!.relativePath
                    if stringURL == songList[i].URL {
                        if i == songList.count-1 {
                            let urlString = URL(fileURLWithPath: songList[0].URL)
                            player = try AVAudioPlayer(contentsOf: urlString)
                            guard let player = player else {
                                throw ShellifyError.PlaybackError
                            }
                            player.prepareToPlay()
                            player.play()
                            return songList[0]
                        }
                        else {
                            let urlString = URL(fileURLWithPath: songList[i+1].URL)
                            player = try AVAudioPlayer(contentsOf: urlString)
                            guard let player = player else {
                                throw ShellifyError.PlaybackError
                            }
                            player.prepareToPlay()
                            player.play()
                            return songList[i+1]
                        }
                    }
                }
                return nil
            }
            return nil
        } catch (ShellifyError.PlaybackError){
            throw ShellifyError.PlaybackError
        }
    }
    
    func pauseSong() throws {
        do {
            if try isPlaying() {
                player?.stop()
            }
        } catch (ShellifyError.PlaybackError){
            throw ShellifyError.PlaybackError
        }
    }
    
    
    func isPlaying() throws -> Bool {
        if let unwrappedPlayer: AVAudioPlayer = player {
            return unwrappedPlayer.isPlaying
        }
        throw ShellifyError.PlaybackError
    }
    
    func isSongValid(songName: String?) throws -> String? {
        if let unwrappedName: String = songName {
            for s in songList {
                if s.name.localizedCaseInsensitiveContains(unwrappedName){
                    return s.URL
                }
            }
            return nil
        }
        
        throw ShellifyError.InvalidSongName
    }
}
