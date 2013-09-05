// ActionScript file
import com.pw282.swf.SwfFile;
import com.pw282.swf.data.KeyWords;
import com.swfdiy.data.ABC;
import com.swfdiy.data.SWF;
import com.swfdiy.data.SWFTag;
import com.swfdiy.data.SWFTag.TagDoABC;
import com.swfdiy.data.SWFTag.TagSymbolClass;

import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.net.FileFilter;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

import mx.events.FlexEvent;

import nochump.util.zip.ZipEntry;
import nochump.util.zip.ZipFile;

import org.flexlite.domUtils.FileUtil;
import org.flexlite.domUtils.SharedObjectUtil;
import org.flexlite.domUtils.StringUtil;

private var excludeDic:Dictionary = new Dictionary();
//要混淆的关键字
private var keyDic:Dictionary = new Dictionary();

//开始混淆
public function onStartMixUpClick():void
{
	trace("正在混淆，请耐心等待...");
	excludeDic = new Dictionary();
	keyDic = new Dictionary();
	
	//读取三个目录下的as和xml文件
	var list:Array = FileUtil.search(dfRootUrl+"\\src","",filterFunc);
	list = list.concat(FileUtil.search(protocolPath.text,"",filterFunc));
	list = list.concat(FileUtil.search(dfRootUrl+"\\Source","",filterFunc));
	
	for each(var file:File in list)
	{
		if(file.extension=="as")
		{
			checkAsFile(file);
		}
		else
		{
			try
			{
				var xmlStr:String = FileUtil.openAsString(file.nativePath);
				var xml:XML = new XML(xmlStr);
				checkXmlFile(xml);
			}
			catch(e:Error){}
		}
		
	}
	//从swf或swc中读取要排除的关键字
	var keyList:Array = readKeyFromExcludeSwf();
	//执行混淆
	doMixUp(keyList);
	trace("混淆成功！结果已保存到:"+publishUrl+"\\FDream"+version+".swf");
	encryptFDreamSwf(publishUrl+"\\FDream"+version+".swf");
	trace("加密成功！结果已保存到:"+publishUrl+"\\FDream"+version+".swf");
}

//搜索的扩展名
private var extensions:Vector.<String> = new <String>["as","xml"];
//搜索回调函数
private function filterFunc(file:File):Boolean
{
	if(file.isDirectory)
	{
		if(file.name.charAt(0)!=".")
			return true;
	}
	else if(file.extension&&extensions.indexOf(file.extension)!=-1)
	{
		return true;
	}
	return false;
}

//Dictionary自身的关键字列表
private var propList:Vector.<String> =  
	new <String>["hasOwnProperty","isPrototypeOf","valueOf",
		"propertyIsEnumerable","setPropertyIsEnumerable","toString"];
//获取as文件内的关键字
private function checkAsFile(file:File):void
{
	var data:String = FileUtil.openAsString(file.nativePath);
	
	var lines:Array = data.split("\n");
	var length:int = lines.length;
	var strLen:int;
	var line:String;
	var charCode:Number;
	var isNoteStart:Boolean = false;
	var index:int;
	var k:int;
	var noteStart:String = "/**";
	var noteEnd:String = "*/";
	
	index = data.indexOf("package ");
	if(index!=-1)
	{
		key = getFirstWord(data.substring(index+8));
		keyDic[key] = true
	}
	for(var i:int=0;i<length;i++)
	{
		line = lines[i];
		line = line.split("\\n").join("{line}");
		line = line.split("\\r").join("{enter}");
		line = line.split("\\t").join("{tab}");
		line = line.split("\\\"").join("{quote}");
		line = line.split("\\'").join("{squote}");
		
		index = 0;
		strLen = line.length;
		if(isNoteStart)
		{
			index = line.indexOf(noteEnd);
			if(index==-1)
			{
				continue;
			}
			else
			{
				isNoteStart = false;
				index += 2;
			}
		}
		else
		{
			index = line.indexOf(noteStart);
			if(index!=-1)
			{
				strLen = index;
				index = 0;
				isNoteStart = true;
			}
		}
		k = line.indexOf("//");
		if(k!=-1)
			strLen = k;
		index = line.indexOf(" function ");
		if(index!=-1)
		{
			key = getFirstWord(line.substr(index+10));
			if(key)
			{
				if(propList.indexOf(key)==-1)
					keyDic[key]=true;   
			}
		}
		index = line.indexOf(" var ");
		if(index!=-1)
		{
			key = getFirstWord(line.substr(index+5));
			if(key)
			{
				if(propList.indexOf(key)==-1)
					keyDic[key]=true;
			}
		}
		
		var quoteStart:Boolean = false;
		var quote:String = "\"";
		var quoteIndex:int;
		var keys:Array = [];
		for(var j:int=index;j<strLen;j++)
		{
			var char:String = line.charAt(j);
			if(quoteStart)
			{
				if(char==quote)
				{
					keys.push(line.substring(quoteIndex,j));
					quoteStart = false;
				}
			}
			else
			{
				if(char=="\""||char=="'")
				{
					quoteStart = true;
					quoteIndex = j+1;
					quote = char;
				}
			}
			
		}
		
		for each(var key:String in keys)
		{
			key = key.split("{line}").join("\n");
			key = key.split("{tab}").join("\t");
			key = key.split("{enter}").join("\r");
			key = key.split("{quote}").join("\"");
			key = key.split("{squote}").join("'");
			if(propList.indexOf(key)==-1&&isNaN(Number(key)))
				excludeDic[key] = true;
		}
	}
}
//获取从索引0开始的第一个词组
private function getFirstWord(str:String):String
{
	str = StringUtil.trim(str);
	var index:int = str.indexOf(" ");
	if(index==-1)
		index = int.MAX_VALUE;
	var rIndex:int = str.indexOf("\r");
	if(rIndex==-1)
		rIndex = int.MAX_VALUE;
	var nIndex:int = str.indexOf("\n");
	if(nIndex==-1)
		nIndex = int.MAX_VALUE;
	var sIndex:int = str.indexOf("(");
	if(sIndex==-1)
		sIndex = int.MAX_VALUE;
	var mIndex:int = str.indexOf(":");
	if(mIndex==-1)
		mIndex = int.MAX_VALUE;
	index = Math.min(index,rIndex,nIndex,sIndex,mIndex);
	str = str.substr(0,index);
	return StringUtil.trim(str);
}

//从swf文件中读取要排除的关键字,并返回最终要混淆的关键字列表.
private function readKeyFromExcludeSwf():Array
{
	var paths:Array = excludeSwf.text.split(";");
	var strings:Array = [];
	for each(var path:String in paths)
	{
		var bytes:ByteArray = FileUtil.openAsByteArray(path);
		var file:File = new File(path);
		if(file.extension=="swc")
		{
			var zipFile:ZipFile = new ZipFile(bytes);   
			var zipEntry:ZipEntry = zipFile.getEntry("library.swf");   
			bytes = zipFile.getInput(zipEntry);
		}
		var swf:SWF = new SWF(bytes);
		swf.startReadTags();	
		var tag:SWFTag = swf.read_tag();
		while(tag) 
		{
			if(tag is TagDoABC) 
			{
				var abc:ABC = TagDoABC(tag).abc();
				strings = strings.concat(abc.constant_pool.strings);
			}
			tag = swf.read_tag();
		}
	}
	for each(var key:String in strings)
	{
		if(propList.indexOf(key)==-1&&isNaN(Number(key)))
			excludeDic[key] = true;
	}
	var keyList:Array = [];
	for(key in keyDic)
	{
		if(excludeDic[key]!==undefined||!isNaN(Number(key)))
		{
			delete keyDic[key];
		}
		else
		{
			var prefix:String = getPrefix(key);
			if(excludeDic[prefix]!==undefined)
			{
				delete keyDic[key];
			}
			else
			{
				keyList.push(key);
			}
		}
	}
	return keyList;
}
//去除key末尾的数字序号
private function getPrefix(key:String):String
{
	var index:int = key.length-1;
	while(index>0)
	{
		var char:String = key.charAt(index);
		if(char>="0"&&char<="9")
		{
			index--;
		}
		else
		{
			break;
		}
	}
	return key.substring(0,index+1);
}

//执行混淆
private function doMixUp(keyList:Array):void
{
	var bytes:ByteArray = FileUtil.openAsByteArray(publishUrl+"\\FDream"+version+".swf");
	bytes.position = 0;
	var swfFile:SwfFile = new SwfFile(bytes);
	KeyWords.arrNeedEncryptStr = keyList;
	if(FileUtil.exists(keyWordPath.text))
	{
		var keyBytes:ByteArray = FileUtil.openAsByteArray(keyWordPath.text);
		try
		{
			var keyWordDic:Object = keyBytes.readObject();
			KeyWords.keyWordDic = keyWordDic;
			var keyObj:Object = {};
			var c:int = 1;
			for(var str:String in keyWordDic)
			{
				var key:String = keyWordDic[str];
				keyObj[key] = str;
				c++;
			}
			KeyWords.strCount = c;
			KeyWords.keyWordObj = keyObj;
		}
		catch(e:Error){}
	}
	swfFile.encrypt();
	swfFile.encode();
	if(keyWordPath.text)
	{
		keyBytes = new ByteArray();
		keyBytes.writeObject(KeyWords.keyWordDic);
		var obj:Object = KeyWords.keyWordDic;
		FileUtil.save(keyWordPath.text,keyBytes);
	}
	FileUtil.save(publishUrl+"\\FDream"+version+".swf",swfFile.bt);
}


//获取xml文件内的关键字
private function checkXmlFile(xml:XML):void
{
	var key:String = xml.localName();
	if(isNaN(Number(key)))
	{
		excludeDic[key] = true;
	}
	for each(var attrib:XML in xml.attributes())
	{
		key = attrib.toString();
		if(key.indexOf(",")!=-1)
		{
			for each(key in key.split(","))
			{
				if(isNaN(Number(key)))
				{
					excludeDic[key] = true;
				}
			}
		}
		else
		{
			if(isNaN(Number(key)))
			{
				excludeDic[key] = true;
			}
		}
		
		key = attrib.localName();
		if(isNaN(Number(key)))
		{
			excludeDic[key] = true;
		}
	}
	
	for each(var item:XML in xml.children())
	{
		checkXmlFile(item);
	}
}

protected function button4_clickHandler(event:MouseEvent):void
{
	FileUtil.browseForOpen(function(files:Array):void{
		var list:Array = [];
		for each(var file:File in files)
		{
			list.push(file.nativePath);
		}
		excludeSwf.text = list.join(";");
		//					SharedObjectUtil.write("EncryptTool","excludeSwf",excludeSwf.text);
	},2,[new FileFilter("swf或swc文件","*.swf;*.swc")]);
}

protected function windowedapplication1_creationCompleteHandler(event:FlexEvent):void
{
//				excludeSwf.text = SharedObjectUtil.read("EncryptTool","excludeSwf");
	protocolPath.text = SharedObjectUtil.read("EncryptTool","protocolPath");
	keyWordPath.text = SharedObjectUtil.read("EncryptTool","keyWordPath");
}

protected function button5_clickHandler(event:MouseEvent):void
{
	FileUtil.browseForOpen(function(file:File):void{
		protocolPath.text = file.nativePath;
		SharedObjectUtil.write("EncryptTool","protocolPath",file.nativePath);
	},3);
}

protected function button7_clickHandler(event:MouseEvent):void
{
	FileUtil.browseForOpen(function(file:File):void{
		keyWordPath.text = file.nativePath;
		SharedObjectUtil.write("EncryptTool","keyWordPath",file.nativePath);
	},1);
}


/**
 * 加密FDream文件
 * @param file
 */
private function encryptFDreamSwf(fileUrl:String):void
{
	var bytes:ByteArray = FileUtil.openAsByteArray(fileUrl);
	var len:int = bytes.length;
	var i:int;
	if(false)//1234位
	{
		for(i=6;i<=len;i+=8)
		{
			bytes[i] = bytes[i]^40;
		}
	}
	if(true)//12位
	{
		for(i=5;i<=len;i+=8)
		{
			bytes[i] = bytes[i]^10;
		}
	}				
	if(false)//5678位
	{
		for(i=4;i<=len;i+=8)
		{
			bytes[i] = bytes[i]^128;
		}
	}				
	if(false)//34位
	{
		for(i=3;i<=len;i+=8)
		{
			bytes[i] = bytes[i]^204;
		}
	}
	if(true)//3456位
	{
		for(i=2;i<=len;i+=8)
		{
			bytes[i] = bytes[i]^123;
		}
	}
	if(false)//56位
	{
		for(i=1;i<=len;i+=8)
		{
			bytes[i] = bytes[i]^156;
		}
	}				
	if(true)//78位
	{
		for(i=0;i<=len;i+=8)
		{
			bytes[i] = bytes[i]^102;
		}
	}
	FileUtil.save(fileUrl,bytes);
}
	
