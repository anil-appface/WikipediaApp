//
//  GlobalConstants.swift
//  Wikipedia App
//
//  Created by Anil Kumar on 27/07/18.
//  Copyright © 2018 Anil Kumar. All rights reserved.
//

import UIKit

//API

//https://www.mediawiki.org/w/api.php     # MediaWiki API
//https://en.wikipedia.org/w/api.php      # English Wikipedia API
//https://nl.wikipedia.org/w/api.php      # Dutch Wikipedia API
//https://commons.wikimedia.org/w/api.php # Wikimedia Commons API

let appDelegate = UIApplication.shared.delegate as! AppDelegate

let kBaseUrl_English = "https://en.wikipedia.org/w/api.php"
let kBaseUrl_Dutch = "https://nl.wikipedia.org/w/api.php"


struct BaseUrl {
    var isSelected: Bool?
    var baseUrl: String?
    var language: String?
}

enum WikiPediaApi: String {
    case listUrl
    case detailUrl
}

/*
action:query
formatversion:2
generator:prefixsearch
gpssearch:Sachin T
gpslimit:10
prop:pageimages%7Cpageterms
piprop:thumbnail
pithumbsize:50
pilimit:10
redirects:
wbptterms:description
format:json
*/



//MARK: Entity Names
let kMTWikiSearchResultEntity = "MTWikiSearchResultEntity"




