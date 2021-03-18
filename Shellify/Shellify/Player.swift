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
    
    init () {
        songList = [Song.init(name: "Daydreamers", artist: "Pala", albumName: "Daydreamers", duration: 122.00)]
        currentSong = Song.init(name: "current song", artist: "teste", albumName: "teste", duration: 122.00)
    }
    
    func playSong(songName: String?) throws {
        if let player = player, player.isPlaying {
            player.stop()
        }
        else {
            let urlString = URL(fileURLWithPath: "/Users/marinadepazzi/Desktop/Xcode-ADA/NanoChallenge-Shellify/Shellify/Shellify/resources/amsterdam.m4a")
            do {
                
                player = try AVAudioPlayer(contentsOf: urlString)
                
                guard let player = player else {
                    return
                }
                
                player.play()
            } catch {
                print("something went wrong")
            }
        }
    }
    
    func continueReproduction() throws {
        do {
            if try !isPlaying() {
                player?.play()
            }
        } catch (SpotifyError.PlaybackError){
            throw SpotifyError.PlaybackError
        }
    }
    
    func pauseSong() throws {
        do {
            if try isPlaying() {
                player?.stop()
            }
        } catch (SpotifyError.PlaybackError){
            throw SpotifyError.PlaybackError
        }
    }
    
    func isPlaying() throws -> Bool {
        if let unwrappedPlayer: AVAudioPlayer = player {
            return unwrappedPlayer.isPlaying
        }
        throw SpotifyError.PlaybackError
    }
    
    func searchSong(songName: String?) throws -> Song {
        if let unwrappedName: String = songName {
            for s in songList {
                if s.name == unwrappedName {
                    return s;
                }
            }
            throw SpotifyError.SongNotFound
        }
        throw SpotifyError.InvalidSongName
    }
}
