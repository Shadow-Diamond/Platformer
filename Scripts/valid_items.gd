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
	}
}
