import org.flexlite.domUtils.FileUtil;

/**
 * 
 * 修改编译文件
 */
private function updateProjectConfig():void
{
	var sConfigPath:String = configPath +"project-config.xml";
	var content:String = FileUtil.openAsString(sConfigPath);
	//新增外部导入的lib_swc.
	var len1:int = content.indexOf('<!--LC set. update library-path -->');
	if(len1 > -1)
	{
		var len2:int = content.indexOf('</library-path>');
		var repair:String = content.substring(len1, len2);
		content = content.replace(repair, "");
	}
	var arr:Array = content.split('</library-path>');
	var sRepleace:String = "<!--LC set. update library-path -->";
	var arr2:Array = libPathArr.concat();
	for(var i:int=0; i<arr2.length; i++)
	{
		sRepleace += "\n		 <path-element>";
		sRepleace += arr2[i];
		sRepleace += "</path-element>";
	}
	sRepleace += "\n	</library-path>";
	content = arr.join(sRepleace);
	FileUtil.save(sConfigPath, content);
}


/**
 * 发版本之前修改Xml_init.xml文件里的，isDebug box2DDraw AIShow属性为false
 */		
private function updateInitXML():void
{
	var soucePath:String = dfRootUrl +"\\Source\\Xml\\Xml_InitConfg.xml";
	var content:String = FileUtil.openAsString(soucePath);
	var len1:int = content.indexOf('isDebug="true"');
	if(len1 > -1)
	{
		content = content.replace('isDebug="true"', 'isDebug="false"');
	}
	len1 = content.indexOf('box2DDraw="true"');
	if(len1>-1)
	{
		content = content.replace('box2DDraw="true"', 'box2DDraw="false"');
	}
	len1 = content.indexOf('AIShow="true"');
	if(len1>-1)
	{
		content = content.replace('AIShow="true"', 'AIShow="false"');
	}
	FileUtil.save(soucePath, content);
}

/**
 * 资源加载路径的修改
 */
private function updateSourceUrlAs():void
{
	var soucePath:String = dfRootUrl +"\\src\\SystemLoading.as";
	var content:String = FileUtil.openAsString(soucePath);
	var len1:int = content.indexOf("../Source/");
	if(len1 > -1)
	{
		content = content.replace("../Source/", "Source/");
	}
	FileUtil.save(soucePath, content);
}

/**
 * 修改加载的FDream的文件名
 */
private function updateAppIniAs():void
{
	var soucePath:String = dfRootUrl +"\\src\\config\\app_ini.xml";
	var targetPath:String = publishUrl+"\\config\\app_ini"+version+".xml";
	FileUtil.copyTo(soucePath, targetPath, true);
	var content:String = FileUtil.openAsString(targetPath);
	if(content)
	{
		var appinixml:XML = XML(content);
		var groupXml:XML = appinixml.group[0];
		var itemxmllist:XMLList = groupXml.item;
		for each(var item:XML in itemxmllist)
		{
			item.@url = "FDream"+version+".swf";
		}
		content = appinixml.toString();
		FileUtil.save(targetPath, content);
	}
}


private function createHtml():void
{
	var htmlPath:String = toolRootUrl +"\\src\\config\\dg.html";
	var destPath:String = publishUrl+"\\dg"+version+".html";
	FileUtil.copyTo(htmlPath, destPath, true);
	var content:String = FileUtil.openAsString(destPath);
	if(content)
	{
		var len1:int = content.indexOf('flashvars.FlashVersion = "v";');
		if(len1>-1)
		{
			content = content.replace('flashvars.FlashVersion = "v";', 'flashvars.FlashVersion = "'+version+'";');
		}
		FileUtil.save(destPath, content);
	}
	
	//	qq版本
	htmlPath = toolRootUrl +"\\src\\config\\dgqq.htm";
	destPath = publishUrl+"\\dg"+version+"qq.htm";
	FileUtil.copyTo(htmlPath, destPath, true);
	content = FileUtil.openAsString(destPath);
	if(content)
	{
		len1 = content.indexOf('flashvars.FlashVersion = "v";');
		if(len1>-1)
		{
			content = content.replace('flashvars.FlashVersion = "v";', 'flashvars.FlashVersion = "'+version+'";');
		}
		FileUtil.save(destPath, content);
	}
}

/**
 * 重置SystemLoading.as文件
 */
private function resetFile():void
{
	var soucePath:String = dfRootUrl +"\\src\\SystemLoading.as";
	var content:String = FileUtil.openAsString(soucePath);
	var len1:int = content.indexOf('= "Source/"');
	if(len1 > -1)
	{
		content = content.replace('= "Source/"', '= "../Source/"');
	}
	FileUtil.save(soucePath, content);
}
