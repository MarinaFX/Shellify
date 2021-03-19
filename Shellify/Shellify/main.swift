//
//  main.swift
//  Shellify
//
//  Created by Marina De Pazzi on 16/03/21.
//

import Foundation
import AVFoundation

let player: Player = Player.init()
do {
    try player.loadPlaylist()
} catch (ShellifyError.SongParametrizationFailed) {
    print("There was a problem while loading the playlist 😢")
} catch (ShellifyError.SongFileNotFound) {
    print("There was a problem while loading the playlist 😢")
}

var userAnswer:String = ""

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

func endProgram() {
    var str = "    _____  _            _  _  _   __\n"
        str += "   / ____|| |          | || |(_) / _|\n"
        str += "  | (___  | |__    ___ | || | _ | |_  _   _\n"
        str += "   \\___ \\ | '_ \\  / _ \\| || || ||  _|| | | |\n"
        str += "   ____) || | | ||  __/| || || || |  | |_| |\n"
        str += "  |_____/ |_| |_| \\___||_||_||_||_|  \\__,  |\n"
        str += "                                       __/ |\n"
        str += "                                      |___/\n"

        print(str)}

func playMusic(song: String){
    print(" ___________________________________________")
    print("|  _______________________________________  |")
    print("| / .-----------------------------------. \\ |")
    
    if song.count == 18 { print("| | | /\\ : \(song)     90 min| | |") }
    if song.count == 9 { print("| | | /\\ : \(song)              4:01  | | |") }
    if song.count == 6{ print("| | | /\\ : \(song)               3:10    | | |") }
    
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
    print(" Summertime Sadness      Lana Del Rey            Born to Die")
    print(" Sex On Fire (Live)      Kings of Leon           iTunes Festival: London 2013 - Single")
    print(" ----------------------------------------------------------------------------------------")
    print("\n")
    print("Insert the name of which song you want to hear: ")
}

startProgram()
showUserLibrary()

userAnswer = readUserInput()
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
            playMusic(song: userAnswer)
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

endProgram()
