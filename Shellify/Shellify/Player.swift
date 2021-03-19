//
//  Player.swift
//  Shellify
//
//  Created by Marina De Pazzi on 17/03/21.
//

import Foundation

import AVFoundation

class Player {
    var player: AVAudioPlayer?
    var songList: [Song]
    
    init () {
        songList = []
    }
    
    func loadPlaylist() throws {
        try addSong(songName: "amsterdam")
        try addSong(songName: "royals")
        try addSong(songName: "Summertime Sadness")
        try addSong(songName: "Sex on Fire (Live)")

    }
    
    func addSong(songName : String) throws {
        let searchPath = FileManager.default
        let fileName = "/Users/marinadepazzi/Desktop/Xcode-ADA/NanoChallenge-Shellify/Shellify/Shellify/resources/" + songName + ".m4a"

        if searchPath.fileExists(atPath: fileName) {
            var newSong = Song(name: "", artist: "", albumName: "", duration: 0)
            let urlString = URL(fileURLWithPath: fileName)
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
            print(newSong.name)
            songList.append(newSong)
        }
        else {
            throw ShellifyError.SongFileNotFound
        }
    }
    
    func playSong(songName: String?) throws {
        if let player = player, player.isPlaying {
            player.stop()
        }
        else {
            if try !isSongValid(songName: songName){
                throw ShellifyError.SongNotFound
            }
            
            let searchPath = FileManager.default
            
            guard let songName : String = songName else {
                throw ShellifyError.InvalidSongName
            }
            
            let fileName = "/Users/marinadepazzi/Desktop/Xcode-ADA/NanoChallenge-Shellify/Shellify/Shellify/resources/" + songName + ".m4a"
    
                if searchPath.fileExists(atPath: fileName) {
                    let urlString = URL(fileURLWithPath: fileName)
                    do {
                        player = try AVAudioPlayer(contentsOf: urlString)
            
                        guard let player = player else {
                            throw ShellifyError.PlaybackError
                        }
            
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

    func continueReproduction() throws {
        do {
            if try !isPlaying() {
                player?.play()
            }
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
    
    func isSongValid(songName: String?) throws -> Bool {
        if let unwrappedName: String = songName {
            for s in songList {
                if s.name.localizedCaseInsensitiveContains(unwrappedName){
                    return true
                }
            }
            return false
        }
        
        throw ShellifyError.InvalidSongName
    }
}
