//=============================================================================
//=============================================================================
function getType(thing) {
    if (thing === null || thing == undefined || thing === NaN) {
        return "[object Null]";
    }
    return Object.prototype.toString.call(thing);
}

//=============================================================================
//=============================================================================
function printType(thing) {
    $.Msg("Type: " + getType(thing));
}

//=============================================================================
//=============================================================================
function print(string) {
    $.Msg(string);
}

//=============================================================================
//=============================================================================
function printObject(object, varName, printContents, level) {
    if (level === undefined || level === 0) {
        print("\n-------------------------------");
        print("Printing properties for " + varName + " (" + getType(object) + "):");
        print("-------------------------------");
        level = 0;
    }
    if (printContents === undefined) {
        printContents = true;
    }
    var objectData = {};
    for (var prop in object) {
        if (object.hasOwnProperty(prop) && prop !== "style") {
            if (object[prop] === "paneltype") {
                objectData.isPanel = true;
            }
            var propType = getType(object[prop]);
            var whitespace = "";
            for (var i=0; i<level; i++) {
                whitespace += "\t";
            }
            print(whitespace + propType + " " + prop);
            if (printContents) {
                if (propType === "[object String]" || propType === "[object Number]") {
                    print(whitespace + "\t" + propType + " " + object[prop]);
                } else if (propType === "[object Object]") {
                    printObject(object[prop], prop, printContents, level+1);
                }
            }
        }
    }
    if (level === 0) {
        print("-------------------------------\n");
        return objectData;
    } else {
        print("");
    }
}

(function() {
    print("Utils loaded!");
})();
