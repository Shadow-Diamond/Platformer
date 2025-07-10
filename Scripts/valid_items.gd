extends Node2D
class_name ItemDB

const ITEMS = {
	"shardback_crawler_stationary": {
		"path": "res://Character-Scenes/Enemy-Scenes/Virellia/Shardback_Crawler.tscn",
		"stationary": true
	},
	"shardback_crawler_mobile_fallable": {
		"path": "res://Character-Scenes/Enemy-Scenes/Virellia/Shardback_Crawler.tscn",
		"stationary": false,
		"fallable": true
	},
	"shardback_crawler_mobile_not_fallable": {
		"path": "res://Character-Scenes/Enemy-Scenes/Virellia/Shardback_Crawler.tscn",
		"stationary": false,
		"fallable": false
	},
	"future_spider_mobile_fallable": {
		"path": "res://Character-Scenes/Enemy-Scenes/Virellia/Future_Spider.tscn",
		"stationary": false,
		"fallable": true
	},
	"future_spider_mobile_not_fallable": {
		"path": "res://Character-Scenes/Enemy-Scenes/Virellia/Future_Spider.tscn",
		"stationary": false,
		"fallable": false
	},
	"better_suit_item" : {
		"path": "res://Item-Scenes/better_suit_item.tscn",
		"suit_type": "better_suit"
	},
	"jump_suit_item" : {
		"path": "res://Item-Scenes/jump_suit_item.tscn",
		"suit_type": "jump_suit"
	},
	"virellia_diamond" : {
		"path" :"res://Item-Scenes/Virellia/Diamond.tscn"
	}
}
