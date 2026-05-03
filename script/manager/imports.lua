local managers = {}
managers.l = {
    ["ping"] = require("script.library.internal.ping"),
    ["eyesequence"] = require("script.library.internal.eyesequence"),
    ["nameplate"] = require("script.library.internal.nameplate"),
    ["actionwheel"] = require("script.library.internal.actionwheel"),
    ["patpat"] = require("script.library.external.patpat"),
    ["tickmanager"] = require("script.library.internal.tickmanager")
}
managers.m = {
}




return managers
