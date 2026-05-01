local managers = {}
managers.l = {
	["ping"] = require("script.ping"),
	["eyesequence"] = require("script.library.internal.eyesequence"),
	["nameplate"] = require("script.library.internal.nameplate"),
	["actionwheel"] = require("script.library.internal.actionwheel"),
	["patpat"] = require("script.library.external.patpat"),
}
managers.m = {
}




return managers
