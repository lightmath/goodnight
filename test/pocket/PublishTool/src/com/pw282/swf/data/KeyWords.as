package com.pw282.swf.data
{
	import flash.utils.Dictionary;

	/**
	 * 系统关键字收集
	 * @author pw
	 * @Date：2011-6-13
	 */
	public class KeyWords
	{
		/**
		 * 收集包名
		 */
		public static var isEncryptPackage : Boolean = false;
		/**
		 * 收集类名
		 */
		public static var isEncryptClass : Boolean = false;
		/**
		 * 收集方法名
		 */
		public static var isEncryptMethod : Boolean = false;
		/**
		 * 收集变量名
		 */
		public static var isEncryptVariable : Boolean = false;
		/**
		 * 用于记录被替换字符串的原始字符和替换后字符，替换时无论如何都应该先搜索这个字典
		 * ，这样保证相同的字符替换后不会出现字符差异
		 */
		public static var dictReplace : Dictionary = new Dictionary();

		public static function isKeyWords(str : String) : Boolean
		{
			return arrWords.indexOf(str) >= 0 || arrSelfWords.indexOf(str) >= 0;
		}
		/** 需要加密的字符串，所有Method_body_info中解析出的code的initproperty指令参数 */
		public static var arrNeedEncryptStr : Array = [];

		public static function addNeedEncryptStr(str : String) : Boolean
		{
			if(arrNeedEncryptStr.indexOf(str) == -1 && !isKeyWords(str))
			{
				arrNeedEncryptStr.push(str);
				return true;
			}
			else
			{
			}
			return false;
		}
		/**
		 * 是否将混淆的关键字替换成（par_1、par_2....）格式
		 */
		public static var isSimpleMode : Boolean = false;
		public static var strCount : int = 0;
		public static var keyWordDic:Object = {};
		
		public static var keyWordObj:Object = {};
		
		public static function getNextEncryptStr(str : String) : String
		{
			if(keyWordDic[str])
				return keyWordDic[str];
			var key:String = generateKey();
			while(keyWordObj[key])
			{
				key = generateKey();
			}
			keyWordDic[str] = key;
			keyWordObj[key] = str;
			return key;
		}

		public static var randomList : Array = [];
		public static var randomData : Dictionary = new Dictionary();

		public static function randomString(str : String) : String
		{
			if(randomData[str])
			{
				return randomData[str];
			}
			var length : int = str.length;
			var s : String = "";

			for(var i : int = 0; i < length; i++)
			{
				s += String.fromCharCode(32 + int(100 * Math.random()));
			}

			if(randomList.indexOf(s) == -1)
			{
				randomList.push(s);
				randomData[str] = s;
			}
			else
			{
				return randomString(str);
			}
			return s;
		}
		
		private static var keyList:Vector.<String> = 
			new <String>["?","#","[","]","}","{","!","~","@","$","%","^","&","*","-","+","=","`",";","'","\"",",",".",">","<","|"];
		private static function generateKey():String
		{
			strCount ++;
			var num:Number = strCount;
			var key:String = "";
			var index:int;
			while(num>0)
			{
				index = int(num%keyList.length);
				key += keyList[index];
				num = int(num/keyList.length);
			}
			return key;
		}

		public static function encryptStr(str : String) : String
		{
			if(arrNeedEncryptStr.indexOf(str) >= 0)
			{
				if(!dictReplace[str])
				{
					dictReplace[str] = getNextEncryptStr(str);
				}
				return dictReplace[str];
			}
			return str;
		}
		/**
		 * swf专有的关键字
		 * 比如要加载一个url是str="my.swf"的文件
		 * 那这个str就不能混淆，必须吧"my.swf"放到关键字里
		 */
		public static var arrSelfWords : Array = [];
		/**
		 * 公共关键字
		 */
		public static const arrWords : Array = ["", "CHANGE", "backgroundColor", "close", "connect", "colorTransform", "hide", "show", "type", "TextField", "flash.text", "text", "addChild", "void", "int", "file", "flash.display", "Sprite", "Object", "EventDispatcher", "flash.events", "DisplayObject", "InteractiveObject", "DisplayObjectContainer", "graphics", "beginFill", "drawRect", "endFill", "loaderInfo", "Event", "addEventListener", "removeEventListener", "Loader", "contentLoaderInfo", "ProgressEvent", "URLRequest", "flash.net", "load", "removeChildAt", "numChildren", "String", "PROGRESS", "COMPLETE", "flash.utils", "ByteArray", "uint", "stage", "StageScaleMode", "NO_SCALE", "scaleMode", "StageAlign", "TOP_LEFT", "align", "showDefaultContextMenu", "URLLoaderDataFormat", "BINARY", "dataFormat", "parameters", "name", "flash.display:Sprite", "flash.display:DisplayObjectContainer", "flash.display:InteractiveObject", "flash.display:DisplayObject", "flash.events:EventDispatcher", "setInterval", "target", "data", "navigateToURL", "Endian", "LITTLE_ENDIAN", "endian", "writeByte", "readBytes", "position", "length", "writeBytes", "loadBytes", "URLLoader", "_blank", "MovieClip", "x", "y", "writeUTFBytes", "Stage", "readUTFBytes", "Class", "Boolean", "Number", "Array", "URLStream", "mp3", "Socket", "flash.geom", "Rectangle", "Transform", "Point", "LoaderInfo", "flash.accessibility", "AccessibilityProperties", "XML", "Function", "Bitmap", "IDataInput", "IOErrorEvent", "SecurityErrorEvent", "MouseEvent", "flash.system", "LoaderContext", "ApplicationDomain", "Dictionary", "autoLayout", "toString", "IBitmapDrawable", "IEventDispatcher", "root", "parent", "mask", "visible", "scaleX", "scaleY", "mouseX", "mouseY", "rotation", "alpha", "width", "height", "cacheAsBitmap", "opaqueBackground", "scrollRect", "filters", "blendMode", "transform", "scale9Grid", "globalToLocal", "localToGlobal", "getBounds", "getRect", "hitTestObject", "hitTestPoint", "accessibilityProperties", "measuredHeight", "measuredWidth", "move", "setActualSize", "flash.media", "SoundChannel", "SoundTransform", "volume", "bottom", "left", "LEFT", "RIGHT", "DOWN", "UP", "right", "top", "clone", "flag", "version", "offset", "time", "method", "flash.errors", "IOError", "lable", "enabled", "TOP", "stageFocusRect", "frameRate", "StageQuality", "BEST", "quality", "Error", "contains", "removeChild", "pop", "htmlText", "writeUnsignedInt", "connect", "readInt", "getTimer", "writeInt", "flush", "MAX_VALUE", "trace", "readUnsignedInt", "ENTER_FRAME", "System", "totalMemory", "appendText", "maxScrollV", "scrollV", "getQualifiedClassName", "setChildIndex", "Math", "ceil", "children", "id", "mouseEnabled", "textColor", "textWidth", "textHeight", "flash.utils:IDataInput", "readShort", "readUnsignedShort", "currentDomain", "applicationDomain", "IO_ERROR", "Sound", "CONNECT", "CLOSE", "SECURITY_ERROR", "SOCKET_DATA", "bytesAvailable", "readBoolean", "readUTF", "readByte", "writeUTF", "CLICK", "push", "clear", "push", "shift", "loaderURL", "indexOf", "random", "substr", "charCodeAt", "join", "SecurityError", "result", "indices", "Date", "slice", "splice", "bytesLoaded", "bytesTotal", "unload", "loader", "bitmapData", "auto", "getDefinition", "flash.filters", "GlowFilter", "currentTarget", "MOUSE_UP", "MOUSE_DOWN", "startDrag", "stopDrag", "ROLL_OVER", "gotoAndStop", "ROLL_OUT", "buttonMode", "totalFrames", "currentFrame", "nextFrame", "stopImmediatePropagation", "stopPropagation", "pause", "http://adobe.com/AS3/2006/builtin", "TextFormat", "KeyboardEvent", "ErrorEvent", "SystemManager", "Graphics", "Bindable", "allowDomain", "addChildAt", "getChildAt", "getChildByName", "getChildIndex", "getObjectsUnderPoint", "getDefinitionByName", "Timer", "BitmapData", "Shape", "RENDER", "KEY_DOWN", "selectable", "invalidate", "lock", "fillRect", "copyPixels", "unlock", "ctrlKey", "shiftKey", "dispatchEvent", "min", "max", "stageWidth", "stageHeight", "content", "rect", "label", "gb2312", "hasEventListener", "RESIZE", "Vector", "CENTER", "TextFieldAutoSize", "writeShort", "connected",
//			"EdgeMetrics",
			"__AS3__.vec", "autoSize", "::", "fullYear", "month", "date", "day", "hours", "minutes", "seconds", "charAt", "ENTER", "DOWN", "UP", "Keyboard", "flash.ui", "keyCode", "dispose", "getCharBoundaries", "verticalScrollPosition", "update", "maxVerticalScrollPosition", "split", "substring", "addItem", "getItemAt", "focus", "setSelection", "fromCharCode", "value", "selectedIndex", "setRendererStyle", "maxChars", "setStyle", "textPadding", "addItems", "dataProvider", "wordWrap", "multiline", "LINK", "setTextFormat", "source", "defaultTextFormat", "replace", "search", "exec", "textField", "dropdown", "bold", "symbol", "writeMultiByte", "readMultiByte", "leading", "font", "letterSpacing", "readFloat", "readDouble", "soundTransform", "toFixed", "stop", "play", "TextEvent", "RegExp", "size", ".", "\n", "DropShadowFilter", "getUTCHours", "getUTCMinutes", "getUTCSeconds", "setHours", "fullYearUTC", "monthUTC", "dateUTC", "currentLabel", "currentFrameLabel", "abs", "moveTo", "lineTo", "hasDefinition", "Capabilities", "readObject", "writeObject", "drawRoundRect", "PI", "pow", "eventPhase", "getSeconds", "getMinutes", "getHours", "getFullYear", "getMonth", "getDay", "getTextFormat", "LocalConnection", "TIMER_COMPLETE", "repeatCount", "XMLNodeType", "TEXT_NODE", "ELEMENT_NODE", "nodeValue", "nodeType", "childNodes", "nodeName", "ColorMatrixFilter", "filter", "getTime", "setTime", "NUMERIC", "XMLDocument", "contextMenu", "ContextMenu", "ContextMenuItem", "customItems", "getParagraphLength", "getLineOffset", "replaceText", "getLineText", "numLines", "lastIndexOf", "setTimeout", "writeBoolean", "TEXT_INPUT", "INPUT", "maxScrollH", "scrollH", "styleSheet", "fontSize", "underline", "textDecoration", "RangeError", "TypeError", "hasSimpleContent", "localName", "attributes", "XMLList", "MOUSE_FOCUS_CHANGE", "tabChildren", "TAB_CHILDREN_CHANGE", "TAB_INDEX_CHANGE", "TAB_ENABLED_CHANGE", "REMOVED", "ADDED", "getQualifiedSuperclassName", "scaleZ", "getLocal", "HTTP_STATUS", "HTTPStatusEvent", "OPEN", "INIT", "TAB", "preventDefault", "charCode", "ESCAPE", "relatedObject", "KEY_FOCUS_CHANGE", "describeType", "DEACTIVATE", "isDefaultPrevented", "stageY", "Mouse", "MOUSE_MOVE", "stageX", "DESCENDING", "NaN", "MOUSE_OUT", "MOUSE_OVER", "DYNAMIC", "TextFieldType", "currentCount", "delay", "TIMER", "useHandCursor", "SPACE", "hasOwnProperty", "DOUBLE_CLICK", "doubleClickEnabled", "floor", "PAGE_DOWN", "PAGE_UP", "HOME", "END", "toUpperCase", "apply", "mouseChildren", "MOUSE_WHEEL", "UNKNOWN", "IMEConversionMode", "conversionMode", "IME", "isNaN", "round", "KEY_UP", "FOCUS_OUT", "FOCUS_IN", "focusRect", "defaultDisabledTextFormat", "TextFormatAlign", "call", "ExternalInterface", "flash.external", "ADDED_TO_STAGE", "mx_internal", "getUnqualifiedClassName", "displayObjectToString", "createUniqueName", "testCharacter", "substitute", "isWhitespace", "trimArrayElements", "breakDownBloxUtils", "validInterval", "getLocalName", "http://www.adobe.com/2006/flex/mx/internal", "VERSION", "readLong", "SUCCESS", "StyleSheet", "isDocument", "getLineMetrics", "sortOn", "merge", "concat", "SharedObject", "SimpleButton", "FocusEvent", "TimerEvent", "restrict", "color", "tabEnabled", "selected", "editable", "sort", "reset", "start", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "flash", "确定", "取消", "flash"];

	}
}