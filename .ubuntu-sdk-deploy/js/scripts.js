// DB
function _getDB() {
    return LocalStorage.openDatabaseSync("translate", "1.0", "Translate app", 2048)
}

function initializeUser() {
    var user = _getDB();
    user.transaction(
        function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS user(key TEXT UNIQUE, value TEXT)');
            var table  = tx.executeSql("SELECT * FROM user");
            // Seed the table with default values
            if (table.rows.length == 0) {
                tx.executeSql('INSERT INTO user VALUES(?, ?)', ["from", "0"]);
                tx.executeSql('INSERT INTO user VALUES(?, ?)', ["to", "0"]);
            };
        });
}
// This function is used to write a key into the database
function setKey(key, value) {
    var db = _getDB();
    db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO user VALUES (?,?);', [key,""+value]);
        if (rs.rowsAffected == 0) {
            throw "Error updating key";
        } else {

        }
    });
}
// This function is used to retrieve a key from the database
function getKey(key) {
    var db = _getDB();
    var returnValue = undefined;

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT value FROM user WHERE key=?;', [key]);
        if (rs.rows.length > 0)
          returnValue = rs.rows.item(0).value;
    })

    return returnValue;
}
// This function is used to delete a key from the database
function deleteKey(key) {
    var db = _getDB();

    db.transaction(function(tx) {
        var rs = tx.executeSql('DELETE FROM user WHERE key=?;', [key]);
    })
}

function translate(text, fromIndex, destIndex) {
    setKey("from", fromIndex);
    setKey("to", destIndex);
    var Languages = ["sq","ar","hy","az","be","bs","bg","ca","hr","cs","da","nl","en","et","fi","fr","ka","de","el","he","hu","is","id","it","lv","lt","mk","ms","mt","no","pl","pt","ro","ru","sr","sk","sl","es","sv","tr","uk","vi"];

    var from = Languages[fromIndex];
    var dest = Languages[destIndex];
    var lookup = text.toLowerCase();

    var url = "https://glosbe.com/gapi/translate?from=" + from + "&dest=" + dest + "&format=json&phrase=" + lookup + "&pretty=true";

    getDict(text, url, 'translate', from, dest);
}

function stranslate(text, fromIndex, destIndex) {
    setKey("from", fromIndex);
    setKey("to", destIndex);
    var Languages = ["sq","ar","hy","az","be","bs","bg","ca","hr","cs","da","nl","en","et","fi","fr","ka","de","el","he","hu","is","id","it","lv","lt","mk","ms","mt","no","pl","pt","ro","ru","sr","sk","sl","es","sv","tr","uk","vi"];

    var from = Languages[fromIndex];
    var dest = Languages[destIndex];
    var lookup = text;

    var url = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20140514T004146Z.41144f499f3155ec.42436d488dd168e133f1fb146d335d5c64662332&lang="+from+"-"+dest+"&text="+lookup;
    getDict(text, url, 'stranslate', from, dest);
}

function getDict(text, url, type, from, dest) {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', url, true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
            if (xhr.status == 200) {
                var result = JSON.parse(xhr.responseText);
                //console.log(xhr.responseText);
                //console.log(url);
                if (type == 'translate') {
                    translateAppend(text, result, from, dest);
                } else {
                    stranslateAppend(text, result);
                }
            } else {
                var content = i18n.tr("A network error occured.");
                giveAnerror(content);
            }
        }
    };
    xhr.setRequestHeader('Content-Type', 'application/json; charset=UTF-8');

    // send the collected data as JSON
    xhr.send();
}

function translateAppend( text, jsonObj, from, dest, cback ){
    // rendering of results
    var templateT1 = '<p><big><strong>%1</strong></big></p>';
    var templateT2 = "<blockquote>%1</blockquote>";
    var tempText = "";
    var authors = jsonObj['authors'];
    var tucs = jsonObj['tuc'];
    // console.debug("tucs="+typeof(tucs));
    if (typeof(tucs) !== "undefined") {
        if (tucs.length > 0) {
            for (var ti=0,tl=tucs.length ; ti < tl ; ti++) {
                var phrase = tucs[ti]['phrase'];
                if (typeof(phrase) !== "undefined") {
                    var auth = authors[tucs[ti]['authors'][0]];
                    var t1 = templateT1.replace("%1", phrase['text']);
                    //t1 = t1.replace("%2", auth["N"])
                    tempText += t1;
                }
                var meanings = tucs[ti]['meanings'];
                if (typeof(meanings) !== "undefined") {
                    for (var mi=0,ml=meanings.length ; mi < ml ; mi++) {
                        tempText += templateT2.replace("%1", meanings[mi]['text']);
                    }
                }
            }
        } else {
            tempText = "";
        }
    } else {
        tempText = "";
    }

    // callBack with no error
    var content = '';
    if (tempText == "") {
        content = "<i>"+i18n.tr("No Result")+"</i>";
    } else {
        var message = i18n.tr("'%1'")
        message = message.replace("%1", text)
        content = "<h1>"+message+"</h1>"+tempText;
    }
    translateRes.text = content;
    translateRes.forceActiveFocus();
}

function stranslateAppend( text, jsonObj ){
    // rendering of results
    var templateT1 = '<p><big>%1</big></p>';
    var tempText = "";
    var texts = jsonObj['text'];
    if (typeof(texts) !== "undefined") {
        if (texts.length > 0) {
            for (var ti=0,tl=texts.length ; ti < tl ; ti++) {
                var str = texts[ti];
                if (typeof(str) !== "undefined") {
                    var t1 = templateT1.replace("%1", str);
                    tempText += t1;
                }
            }
        } else {
            tempText = "";
        }
    } else {
        tempText = "";
    }

    // callBack with no error
    var content = '';
    if (tempText == "") {
        content = "<i>"+i18n.tr("No Result")+"</i>";
    } else {
        var message = i18n.tr("'%1'")
        message = message.replace("%1", text)
        content = "<h1>"+message+"</h1>"+tempText;
    }
    translateRes.text = content;
    translateRes.forceActiveFocus();
}

function giveAnError(content) {
    translateRes.text = content;
}
