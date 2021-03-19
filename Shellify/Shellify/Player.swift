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
    var currentSong: Song
    
    init (list : [Song]) {
        songList = list
        currentSong = songList[0]
    }
    
    func playSong(songName: String?) throws {
        if let player = player, player.isPlaying {
            player.stop()
        }
        else {
            let searchPath = FileManager.default
            
            guard let songName : String = songName else {
                throw ShellifyError.InvalidSongName
            }
            
            for song in songList {
                if song.name.localizedCaseInsensitiveContains(songName) {
                    let fileName = "/Users/diego/Documents/Xcode/Shellify/Shellify/Shellify/resources/" + songName + ".m4a"
            
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
            throw ShellifyError.SongNotFound
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
    
    func searchSong(songName: String?) throws -> Song {
        if let unwrappedName: String = songName {
            for s in songList {
                if s.name == unwrappedName {
                    return s;
                }
            }
            throw ShellifyError.SongNotFound
        }
        throw ShellifyError.InvalidSongName
    }
}
