//
//  main.swift
//  Shellify
//
//  Created by Marina De Pazzi and Diego Henrique on 16/03/21.
//

import Foundation
import AVFoundation

func startProgram(){
    var str = "    _____  _            _  _  _   __\n"
        str += "   / ____|| |          | || |(_) / _|\n"
        str += "  | (___  | |__    ___ | || | _ | |_  _   _\n"
        str += "   \\___ \\ | '_ \\  / _ \\| || || ||  _|| | | |\n"
        str += "   ____) || | | ||  __/| || || || |  | |_| |\n"
        str += "  |_____/ |_| |_| \\___||_||_||_||_|  \\__,  |\n"
        str += "                                       __/ |\n"
        str += "                                      |___/\n"
        str += "                                              \n"
        str += "Please paste the directory where your songs are:"

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

func playMusic(song: Song) {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .positional
    formatter.allowedUnits = [ .minute, .second ]
    formatter.zeroFormattingBehavior = [ .pad ]

    print(" ___________________________________________________________")
    print("|  ______________________________________________________   |")
    print("| / .--------------------------------------------------. \\  |")
    if song.name.count < 37 {
        print("| | | /\\ : \(song.name)", terminator:"")
        for _ in song.name.count ... 37 {
            print(" ", terminator:"")
        }
        print("\(formatter.string(from: song.duration)!) |  | |")
    }
    if song.artist.count < 35 {
        print("| | |/--\\: \(song.artist) ", terminator:"")
        for _ in song.artist.count ... 35 {
            print(".", terminator:"")
        }
        print(" NR [ ]|  | |")
    }
    print("| | `--------------------------------------------------'  | |")
    print("| |              //-\\\\   |         |   //-\\\\              | |")
    print("| |             ||( )||  |_________|  ||( )||             | |")
    print("| |              \\\\-//   :....:....:   \\\\-//              | |")
    print("| |              _ _ ._  _ _ .__|_ _.._  _                | |")
    print("| |             (_(_)| |(_(/_|  |_(_||_)(/_               | |")
    print("| |                                  |                    | |")
    print("| `_____ ____________________________________ ____ _______' |")
    print("|       /    []                             []    \\         |")
    print("|      /  ()                                   ()  \\        |")
    print("!_____/_____________________________________________\\_______!")
}



func readUserInput() -> String {
    if let unrwrappedAnswer: String = readLine() {
        return unrwrappedAnswer
    }
    return "An error occurred while reading the user input"
}

func showUserLibrary(library : [Song]){
    var totalDuration : TimeInterval = 0
    var calendar = Calendar.current
    calendar.locale = Locale(identifier: "en-UK")
    let formatter = DateComponentsFormatter()
    formatter.calendar = calendar
    formatter.unitsStyle = .abbreviated
    formatter.allowedUnits = [ .minute, .second ]
    formatter.zeroFormattingBehavior = [ .pad ]
    
    for song in library {
        totalDuration += song.duration
    }
    print("       ____________")
    print("     __|__________|__     Playlist ")
    print("    /    o--▶︎--o    \\     INDIE POP")
    print("   |  ❄︎❄︎   | |   ❄︎❄︎  |")
    print("   |  ❄︎❄︎   | |   ❄︎❄︎  |    The place where you can vibe")
    print("    \\_______________/     Created By: Shellify • \(library.count) Songs, \(formatter.string(from:totalDuration)!)")
    print("                     ")
    print(" ----------------------------------------------------------------------------------------------------------")
    print(" TITLE                                ARTIST                               ALBUM NAME")
    for song in library {
        if song.name.count < 36 {
            print(" \(song.name)", terminator:"")
            for _ in song.name.count ... 36 {
                print(" ", terminator:"")
            }
        }
        if song.artist.count < 36 {
            print("\(song.artist)", terminator:"")
            for _ in song.artist.count ... 36 {
                print(" ", terminator:"")
            }
        }
        print("\(song.albumName)")
    }
    print(" ----------------------------------------------------------------------------------------------------------")
    print("\n")
    print("Insert the name of which song you want to hear: ")
}

startProgram()

let player: Player = Player.init()
var userAnswer:String = ""

userAnswer = readUserInput()

do {
    try player.loadPlaylist(userPath : userAnswer)
} catch {
    print("\nThere was a problem finding your song folder 😥\n")
    endProgram()
    exit(0)
}

print("\nLoading playlist...\n")
showUserLibrary(library : player.songList)

userAnswer = readUserInput()

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
        case "skip":
            if ((player.player?.isPlaying) != nil) {
                guard let nextSong: Song = try player.skipSong() else {
                    throw ShellifyError.PlaybackError
                }
                playMusic(song: nextSong)
            }
        default:
            try player.playSong(songName: userAnswer)
            for song in player.songList {
                if song.name.localizedCaseInsensitiveContains(userAnswer) {
                    playMusic(song : song)
                }
            }
            print("\nTo exit the program, type: exit")
            print("To pause a song, type: pause")
            print("To continue playing a song that was paused, type: play")
            print("To skip a song, type: skip")
            print("To listen another song, type its title\n")

        }
        
    } catch (ShellifyError.InvalidSongName) {
        print("Sorry, but it appers you've inserted a strange name for a song 😳")
    } catch (ShellifyError.PlaybackError) {
        print("Sorry, but it appears there is an error with the playback 😰")
    } catch (ShellifyError.SongFileNotFound) {
        print("Sorry, but it appears there was an error while loading the song file 😰")
    } catch (ShellifyError.SongNotFound) {
        print("Sorry, but you've tried to play a song that is not inside the folder 🤪")
    } catch (ShellifyError.SongParametrizationFailed) {
        print("Sorry, but there was an error adding your song 😰")
    } catch {
        print("Something went wrong 😰")
    }
    
    userAnswer = readUserInput()
}

endProgram()
