package com.gdx.util;

using StringTools;

/*
DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
         Version 0.002, 14, January, 1978

Copyright (C) 2014 Luis Santos AKA DJOKER <djokertheripper@gmail.com>

Everyone is permitted to copy and distribute verbatim or modified
copies of this license document, and changing it is allowed as long
as the name is changed.

           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
  TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

 0. You just DO WHAT THE FUCK YOU WANT TO.
*/
class Strings
{
    /**
     * Gets the extension of a file name, or null if there is no extension.
     */
    public static function getFileExtension (fileName :String) :String
    {
        var dot = fileName.lastIndexOf(".");
        return (dot > 0) ? fileName.substr(dot+1) : null;
    }

    /**
     * Returns a file name without its extension.
     */
    public static function removeFileExtension (fileName :String) :String
    {
        var dot = fileName.lastIndexOf(".");
        return (dot > 0) ? fileName.substr(0, dot) : fileName;
    }

    /**
     * Gets the extension of a full path or URL, with special handling for '/' and '?' characters.
     * Returns null if there is no extension.
     */
    public static function getUrlExtension (url :String) :String
    {
        var question = url.lastIndexOf("?");
        if (question >= 0) {
            url = url.substr(0, question);
        }
        var slash = url.lastIndexOf("/");
        if (slash >= 0) {
            url = url.substr(slash+1);
        }
        return getFileExtension(url);
    }

    /**
     * Joins two strings with a path separator.
     */
    public static function joinPath (base :String, relative :String) :String
    {
        if (base.length > 0 && base.fastCodeAt(base.length-1) != "/".code) {
            base += "/"; // Ensure base ends with a trailing slash
        }
        return base + relative;
    }

    public static function hashCode (str :String) :Int
    {
        var code = 0;
        if (str != null) {
            for (ii in 0...str.length) {
                code = Std.int(31*code + str.fastCodeAt(ii));
            }
        }
        return code;
    }

    /**
     * Substitute all "{n}" tokens with the corresponding values.
     * Example: `substitute("{1} sat on a {0}", ["wall", "Humpty Dumpty"])` returns `"Humpty Dumpty
     * sat on a wall"`.
     */
    public static function substitute (str :String, values :Array<Dynamic>) :String
    {
        // FIXME(bruno): If your {0} replacement has a {1} in it, then that'll get replaced next
        // iteration
        for (ii in 0...values.length) {
            str = str.replace("{" + ii + "}", values[ii]);
        }
        return str;
    }

    /**
     * Format a message with named parameters into a standard format for logging and errors.
     * Example: `withFields("Wobbles were frobulated", ["count", 5, "silly", true])` returns
     * `"Wobbles were frobulated [count=5, silly=true]"`.
     *
     * @param fields The field names and values to be formatted. Must have an even length.
     */
    public static function withFields (message :String, fields :Array<Dynamic>) :String
    {
        var ll = fields.length;
        if (ll > 0) {
            message += (message.length > 0) ? " [" : "[";
            var ii = 0;
            while (ii < ll) {
                if (ii > 0) {
                    message += ", ";
                }
                var name = fields[ii];
                var value :Dynamic = fields[ii + 1];

                // Replace throwables with their stack trace
#if flash
                if (Std.is(value, flash.errors.Error)) {
                    var stack :String = cast(value, flash.errors.Error).getStackTrace();
                    if (stack != null) {
                        value = stack;
                    }
                }
#elseif js
                if (Std.is(value, untyped __js__("Error"))) {
                    var stack :String = value.stack;
                    if (stack != null) {
                        value = stack;
                    }
                }
#end
                message += name + "=" + value;
                ii += 2;
            }
            message += "]";
        }

        return message;
    }
}
