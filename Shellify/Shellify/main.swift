//
//  main.swift
//  Shellify
//
//  Created by Marina De Pazzi on 16/03/21.
//

import Foundation
import AVFoundation

func addSong(songName : String) throws -> Song? {
    let searchPath = FileManager.default
    let fileName = "/Users/diego/Documents/Xcode/Shellify/Shellify/Shellify/resources/" + songName + ".m4a"

    if searchPath.fileExists(atPath: fileName) {
        var newSong = Song(name: "", artist: "", albumName: "", duration: 0)
        let urlString = URL(fileURLWithPath: fileName)
        let avpItem = AVPlayerItem(url: urlString)
        let commonMetaData = avpItem.asset.commonMetadata
            for item in commonMetaData {
                if item.commonKey?.rawValue == "title" {
                    guard let songTitle = item.stringValue else {
                        throw ShellifyError.PlaybackError
                    }
                    newSong.name = songTitle
                }
                if item.commonKey?.rawValue == "artist" {
                    guard let songArtist = item.stringValue else {
                        throw ShellifyError.PlaybackError
                    }
                    newSong.artist = songArtist
                }
                if item.commonKey?.rawValue == "albumName" {
                    guard let songAlbum = item.stringValue else {
                        throw ShellifyError.PlaybackError
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
        return newSong
    }
    
    else { throw ShellifyError.SongFileNotFound }
}
        

func startProgram(){
    var str = "    _____  _            _  _  _   __\n"
        str += "   / ____|| |          | || |(_) / _|\n"
        str += "  | (___  | |__    ___ | || | _ | |_  _   _\n"
        str += "   \\___ \\ | '_ \\  / _ \\| || || ||  _|| | | |\n"
        str += "   ____) || | | ||  __/| || || || |  | |_| |\n"
        str += "  |_____/ |_| |_| \\___||_||_||_||_|  \\__,  |\n"
        str += "                                       __/ |\n"
        str += "                                      |___/\n"
        str += " Loading playlist... \n"

        print(str)
    
}

func playMusic(){
    print(" ___________________________________________")
    print("|  _______________________________________  |")
    print("| / .-----------------------------------. \\ |")
    print("| | | /\\ :                        90 min| | |")
    print("| | |/--\\:....................... NR [ ]| | |")
    print("| | `-----------------------------------' | |")
    print("| |      //-\\\\   |         |   //-\\\\      | |")
    print("| |     ||( )||  |_________|  ||( )||     | |")
    print("| |      \\\\-//   :....:....:   \\\\-//      | |")
    print("| |       _ _ ._  _ _ .__|_ _.._  _       | |")
    print("| |      (_(_)| |(_(/_|  |_(_||_)(/_      | |")
    print("| |               low noise   |           | |")
    print("| `______ ____________________ ____ ______' |")
    print("|        /    []             []    \\        |")
    print("|       /  ()                   ()  \\       |")
    print("!______/_____________________________\\______!")
}

func readUserInput() -> String {
    if let unrwrappedAnswer: String = readLine() {
        return unrwrappedAnswer
    }
    return "An error occurred while reading the user input"
}

func showUserLibrary(){
    print("       ____________")
    print("     __|__________|__     Playlist ")
    print("    /    o--▶︎--o    \\     INDIE POP")
    print("   |  ❄︎❄︎   | |   ❄︎❄︎  |")
    print("   |  ❄︎❄︎   | |   ❄︎❄︎  |    The place where you can vibe")
    print("    \\_______________/     Created By: Shellify • 5 Songs, 15 min 57 sec")
    print("                     ")
    print(" ----------------------------------------------------------------------------------------")
    print(" TITLE                   ARTIST                  ALBUM NAME")
    print(" Amsterdam               Imagine Dragons         Night Visions")
    print(" Royals                  Lorde                   Pure Heroine")
    print(" Moves Like Jagger       Maroon 5                Holiday Gift - Single")
    print(" Summertime Sadness      Lana Del Rey            Born to Die")
    print(" Sex on Fire (Live)      Kings of Leon           iTunes Festival: London 2013 - Single")
    print(" ----------------------------------------------------------------------------------------")
    print("\n")
    print("Insert the name of which song you want to hear: ")
}

startProgram()
showUserLibrary()
var songLibrary : [Song] = []
do {
    guard let newSong = try addSong(songName: "amsterdam") else {
        throw (ShellifyError.SongNotFound)
    }
    songLibrary.append(newSong)
    
} catch (ShellifyError.SongNotFound) {
    throw ShellifyError.SongNotFound
   }
    
let player: Player = Player.init(list: songLibrary)
var userAnswer = readUserInput()
print("To exit the program, type: exit")
print("To pause a song, type: pause")

while userAnswer != "exit" {
    do {
        switch userAnswer {
        case "exit":
            break
        case "pause":
            if ((player.player?.isPlaying) != nil) {
                try player.pauseSong()
            }
        case "play":
            if ((player.player?.isPlaying) != nil) {
                try player.continueReproduction()
            }
        default:
            try player.playSong(songName: userAnswer)
        }
    
    } catch (ShellifyError.InvalidSongName) {
        print("Sorry, but it appers you've inserted a strange name for a song 😳")
    } catch (ShellifyError.PlaybackError) {
        print("Sorry, but it appears there is an error with the playback 😰")
    } catch (ShellifyError.SongFileNotFound) {
        print("Sorry, but it appears there was an error while loading the song file 😰")
    } catch (ShellifyError.SongNotFound) {
        print("Sorry, but you've tried to play a song that is unavailable in the album 🤪")
    } catch (ShellifyError.SongParametrizationFailed) {
        print("Sorry, but there was an error adding your song 😰")
    } catch {
        print("Something went wrong 😰")
    }
    
    userAnswer = readUserInput()
}

startProgram()
