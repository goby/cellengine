package com.cell.util
{
	import com.cell.io.TextDeserialize;
	import com.cell.io.TextReader;
	
	import flash.utils.ByteArray;

	/**
	 *  The StringUtil utility class is an all-static class with methods for
	 *  working with String objects within Flex.
	 *  You do not create instances of StringUtil;
	 *  instead you call methods such as 
	 *  the <code>StringUtil.substitute()</code> method.  
	 */
	public class StringUtil
	{
		
		public static function parserBoolean(s:String) : Boolean
		{
			if ( s == null) {
				return false;
			}
			return s.toLowerCase() == "true";
		}
		
			//--------------------------------------------------------------------------
			//
			//  Class methods
			//
			//--------------------------------------------------------------------------
			
			/**
			 *  Removes all whitespace characters from the beginning and end
			 *  of the specified string.
			 *
			 *  @param str The String whose whitespace should be trimmed. 
			 *
			 *  @return Updated String where whitespace was removed from the 
			 *  beginning and end. 
			 */
			public static function trim(str:String):String
			{
				if (str == null) return '';
				
				var startIndex:int = 0;
				while (isWhitespace(str.charAt(startIndex)))
					++startIndex;
				
				var endIndex:int = str.length - 1;
				while (isWhitespace(str.charAt(endIndex)))
					--endIndex;
				
				if (endIndex >= startIndex)
					return str.slice(startIndex, endIndex + 1);
				else
					return "";
			}
			
			/**
			 *  Removes all whitespace characters from the beginning and end
			 *  of each element in an Array, where the Array is stored as a String. 
			 *
			 *  @param value The String whose whitespace should be trimmed. 
			 *
			 *  @param separator The String that delimits each Array element in the string.
			 *
			 *  @return Updated String where whitespace was removed from the 
			 *  beginning and end of each element. 
			 */
			public static function trimArrayElements(value:String, delimiter:String):String
			{
				if (value != "" && value != null)
				{
					var items:Array = value.split(delimiter);
					
					var len:int = items.length;
					for (var i:int = 0; i < len; i++)
					{
						items[i] = StringUtil.trim(items[i]);
					}
					
					if (len > 0)
					{
						value = items.join(delimiter);
					}
				}
				
				return value;
			}
			
			/**
			 *  Returns <code>true</code> if the specified string is
			 *  a single space, tab, carriage return, newline, or formfeed character.
			 *
			 *  @param str The String that is is being queried. 
			 *
			 *  @return <code>true</code> if the specified string is
			 *  a single space, tab, carriage return, newline, or formfeed character.
			 */
			public static function isWhitespace(character:String):Boolean
			{
				switch (character)
				{
					case " ":
					case "\t":
					case "\r":
					case "\n":
					case "\f":
						return true;
						
					default:
						return false;
				}
			}
			
			/**
			 *  Substitutes "{n}" tokens within the specified string
			 *  with the respective arguments passed in.
			 *
			 *  @param str The string to make substitutions in.
			 *  This string can contain special tokens of the form
			 *  <code>{n}</code>, where <code>n</code> is a zero based index,
			 *  that will be replaced with the additional parameters
			 *  found at that index if specified.
			 *
			 *  @param rest Additional parameters that can be substituted
			 *  in the <code>str</code> parameter at each <code>{n}</code>
			 *  location, where <code>n</code> is an integer (zero based)
			 *  index value into the array of values specified.
			 *  If the first parameter is an array this array will be used as
			 *  a parameter list.
			 *  This allows reuse of this routine in other methods that want to
			 *  use the ... rest signature.
			 *  For example <pre>
			 *     public function myTracer(str:String, ... rest):void
			 *     { 
			 *         label.text += StringUtil.substitute(str, rest) + "\n";
			 *     } </pre>
			 *
			 *  @return New string with all of the <code>{n}</code> tokens
			 *  replaced with the respective arguments specified.
			 *
			 *  @example
			 *
			 *  var str:String = "here is some info '{0}' and {1}";
			 *  trace(StringUtil.substitute(str, 15.4, true));
			 *
			 *  // this will output the following string:
			 *  // "here is some info '15.4' and true"
			 */
			public static function substitute(str:String, args:Array):String
			{
				if (str == null) return '';
				// Replace all of the parameters in the msg string.
				var len:uint = args.length;
				for (var i:int = 0; i < len; i++)
				{
					str = str.replace(new RegExp("\\{"+i+"\\}", "g"), args[i]);
				}
				return str;
			}
			
			public static function format(str:String, ... rest) : String
			{
				return substitute(str, rest);
			}
			
			public static const ANCHOR_LEFT : int = 0;
			public static const ANCHOR_RIGHT : int = 2;
			
			/**
			 * 填充字符串
			 * 比如: 
			 * fillAlign('12', 3, '0', ANCHOR_RIGHT) => 012
			 */
			public static function fillAlign(src:*, length:int, 
											 fill_char:String = ' ',
											 anchor:int = ANCHOR_LEFT) : String
			{
				var str : String = src.toString();
				// src out of range
				if (str.length >= length) {
					return str;
				}
				var fill_count : int = length - str.length;
				if (anchor == ANCHOR_LEFT) {
					for (var i:int=0; i<fill_count; i++) {
						str = str + fill_char;
					}
				} else {
					for (var j:int=0; j<fill_count; j++) {
						str = fill_char + str;
					}
				}
				return str;
			}
			
			
			public static function endsOf(src:String, end:String) : Boolean 
			{
				return src.lastIndexOf(end) + end.length == src.length;
			}
			
			
			/**
			 * get [key : value] form str <\b> 
			 * 
			 * str = "FORCE=A"
			 * key = "FORCE="
			 * value = "A"
			 * 
			 * @param str
			 * @param key
			 * @param value
			 */
			static public function getStringValueFromKey(str:String, key:String) : String
			{
				var index : int = str.indexOf(key);
				if(index >= 0)
				{
					return str.substring(index + key.length);
				}
				else
				{
					return null;
				}
			}
			
			
			/**
			 * @param text
			 * @param s
			 * @param d
			 * @return
			 */
			static public function replaceString(text:String, s:String, d:String, limit:int=int.MAX_VALUE) : String
			{
				if (text.indexOf(s, 0) < 0) {
					return text;
				}
				
				var count : int = 0;
				
				var sb : String = "";
				
				for (var i:int = 0; i < text.length; i++)
				{
					if (count < limit) {
						var dst : int = text.indexOf(s, i);
						if (dst >= 0) {
							sb += (text.substring(i, dst) + d);
							i = dst + s.length - 1;
							count++;
						} else {
							sb += (text.substring(i));
							break;
						}
					} else {
						sb += (text.substring(i));
						break;
					}
				}
				
				return sb;
			}
			
			/**
			 * @author 
			 * split string 
			 * @param text
			 * @param separator
			 * @return
			 */
			static public function splitString( text:String, 
												separator:String, 
												limit:int=int.MAX_VALUE, 
												autotrim:Boolean=false) : Array
			{
				var lines : Array = new Array();
				for (var i : int = 0; i < text.length; i++) {
					if (lines.length+1 < limit) {
						var dst : int = text.indexOf(separator, i);
						if (dst >= 0) {
							lines.push(text.substring(i, dst));
							i = dst + separator.length - 1;
						} else {
							lines.push(text.substring(i, text.length));
							break;
						}
					} else {
						lines.push(text.substring(i, text.length));
						break;
					}
				}
				if (autotrim) {
					for (var i : int = 0; i < lines.length; i++) {
						lines[i] = StringUtil.trim(lines[i]);
					}
				}
				return lines;
			}
			
			
			
			
			/**
			 * input "{1234},{5678}"
			 * return [1234][5678]
			 */
			public static function getArray1DGroup(text:String) : Array
			{
				text = StringUtil.replaceString(text, '{', ' ');
				var texts : Array = StringUtil.splitString(text, "},");
				for (var i:int=texts.length-1; i>=0; --i) {
					texts[i] = StringUtil.trim(texts[i]);
				}
				return texts;
			}
			
			/**
			 * input 3,123,4,5678
			 * return [123] [5678]
			 * @param text
			 * @return
			 */
			public static function getArray1D(text:String) : Array
			{
				var reader : TextReader = new TextReader(text);
				var list : Array = new Array();
				while(reader.remain()>0){
					var line : String = TextDeserialize.getString(reader);
					if (line != null) {
						list.push(line);
					} else {
						break;
					}
				}
				return list;
			}
			
			/**
			 * input 3,123,4,5678
			 * return [123] [5678]
			 * @param text
			 * @return
			 */
			public static function getArray1DLines(text:String) : String
			{
				var reader : TextReader = new TextReader(text);
				var list : String = "";
				while(reader.remain()>0){
					var line : String = TextDeserialize.getString(reader);
					if (line != null) {
						list += line + "\n";
					} else {
						if (list.charAt(list.length - 1) == "\n") {
							list = list.substring(0, list.length-1);
						}
						break;
					}
				}
				return list;
			}
			
			
			
			
			
			
			
			
			
			public static function getNumberArray( str:String,  delimiter:String=",") : Array
			{
				if ( (str==null) || str.length==0 )
					return null;
				
				var strs : Array = str.split(delimiter);
				
				var ret : Array = new Array(strs.length);
				
				for (var i:int=0; i<strs.length; i++) {
					ret[i] = Number(strs[i]);
				}
				
				return ret;
			}	
			
			
			public static function getIntegerArray( str:String,  delimiter:String=",") : Array
			{
				if ( (str==null) || str.length==0 )
					return null;
				
				var strs : Array = str.split(delimiter);
				
				var ret : Array = new Array(strs.length);
				
				for (var i:int=0; i<strs.length; i++) {
					ret[i] = int(strs[i]);
				}
				
				return ret;
			}
			

			public static function arrayToString(array:Array,  delimiter:String=",") : String
			{
				var ret : String = "";
				for (var i:int=0; i<array.length; i++) {
					ret += array[i];
					if (i < array.length-1) {
						ret += delimiter;
					}
				}
				return ret;
			}
			
//			------------------------------------------------------------------------------------------------------
			
			public static function bin2hex(data:ByteArray) : String
			{
				var ret : String = "";
				var count : int = data.length;
				var old_p : int = data.position;
				data.position = 0;
				for (var i : int = 0; i<count; i++) {
					var dn : String = data.readUnsignedByte().toString(16);
					if (dn.length==2) {
						ret += dn;
					} else {
						ret += "0" + dn;
					}
				}
				data.position = old_p;
				return ret;
			}
			
			public static function hex2bin(hex:String) : ByteArray
			{
				if (hex.length % 2 != 0) {
					hex = "0" + hex;
				}
				var count : int = hex.length;
				var os : ByteArray = new ByteArray();
				for (var i:int = 0; i < count; i+=2) {
					var read : int = parseInt(hex.substring(i, i+2), 16);
					os.writeByte(read);
				}				
				os.position = 0;
				return os;
			}	
			
		}
	

	
	
}
