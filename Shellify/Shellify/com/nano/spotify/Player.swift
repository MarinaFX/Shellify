//
//  Player.swift
//  Shellify
//
//  Created by Marina De Pazzi on 17/03/21.
//

import Foundation

class Player {
    var searchQueue: [Song] = []
    var currentSong: Song
    
    init (currentSong: Song) {
        self.currentSong = currentSong
    }
}
