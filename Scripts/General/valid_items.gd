extends Node2D
class_name ItemDB

const ITEMS = {
	"shardback_crawler_stationary": {
		"path": "res://Character-Scenes/Enemy-Scenes/Virellia/Shardback_Crawler.tscn",
		"mobile": false,
		"fallable": false
	},
	"shardback_crawler_mobile_fallable": {
		"path": "res://Character-Scenes/Enemy-Scenes/Virellia/Shardback_Crawler.tscn",
		"mobile": true,
		"fallable": true,
		
	},
	"shardback_crawler_mobile_not_fallable": {
		"path": "res://Character-Scenes/Enemy-Scenes/Virellia/Shardback_Crawler.tscn",
		"mobile": true,
		"fallable": false
	},
	"future_spider_mobile_fallable": {
		"path": "res://Character-Scenes/Enemy-Scenes/Virellia/Future_Spider.tscn",
		"mobile": true,
		"fallable": true
	},
	"future_spider_mobile_not_fallable": {
		"path": "res://Character-Scenes/Enemy-Scenes/Virellia/Future_Spider.tscn",
		"mobile": true,
		"fallable": false
	},
	"better_suit_item" : {
		"path": "res://Item-Scenes/better_suit_item.tscn",
		"suit_type": "better_suit",
		"suit_value": 2
	},
	"jump_suit_item" : {
		"path": "res://Item-Scenes/jump_suit_item.tscn",
		"suit_type": "jump_suit",
		"suit_value": 3
	},
	"virellia_diamond" : {
		"path" :"res://Item-Scenes/Virellia/Diamond.tscn"
	}
}
