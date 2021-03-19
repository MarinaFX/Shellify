//
//  SongNotFoundError.swift
//  Shellify
//
//  Created by Marina De Pazzi on 17/03/21.
//

import Foundation

enum SpotifyError: Error {
    case SongNotFound
    case InvalidSongName
    case PlaybackError
    case SongFileNotFound
}