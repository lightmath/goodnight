package com.pw282.swf.tags.control
{
	import com.pw282.swf.data.DString;
	import com.pw282.swf.data.EncodedU32;
	import com.pw282.swf.tags.Tag;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class DefineSceneAndFrameLabelDataTag extends Tag
	{
		public var SceneCount:int;
		public var arrScene:Array;
		public var FrameLabelCount:int;
		public var arrFrameLabel:Array;
		public function DefineSceneAndFrameLabelDataTag()
		{
			super();
		}
		override public function parse():void{
			super.parse();
			
			if(!allowChildParse){
				return;
			}
			var ob:Object;
			var i:uint;
			arrScene = [];
			SceneCount = EncodedU32.read(bt);
			for(i = 0; i < SceneCount; i++){
				ob = {};
				ob.Offset = EncodedU32.read(bt);
				ob.Name = DString.read(bt);
				arrScene.push(ob);
			}
			arrFrameLabel = [];
			FrameLabelCount = EncodedU32.read(bt);
			for(i = 0; i < FrameLabelCount; i++){
				ob = {};
				ob.FrameNum = EncodedU32.read(bt);
				ob.FrameLabel = DString.read(bt);
				arrFrameLabel.push(ob);
			}
		}
		override public function encode():void{
			if(allowChildEncode){
				bt = new ByteArray();
				bt.endian = Endian.LITTLE_ENDIAN;
				
				var ob:Object;
				var i:uint;
				EncodedU32.write(bt, SceneCount);
				for(i = 0; i < SceneCount; i++){
					ob = arrScene[i];
					EncodedU32.write(bt, ob.Offset);
					DString.write(bt, ob.Name);
				}
				EncodedU32.write(bt, FrameLabelCount);
				for(i = 0; i < FrameLabelCount; i++){
					ob = arrFrameLabel[i];
					EncodedU32.write(bt, ob.FrameNum);
					DString.write(bt, ob.FrameLabel);
				}
			}
			super.encode();
		}
		override public function toString():String{
			var str:String = super.toString();
			var ob:Object;
			var i:uint;
			str += "\nSceneCount：" + SceneCount;
			for(i = 0; i < SceneCount; i++){
				ob = arrScene[i];
				str += "\nOffset" + i + "：" + ob.Offset;
				str += "\nName" + i + "：" + ob.Name;
			}
			str += "\nFrameLabelCount：" + FrameLabelCount;
			for(i = 0; i < FrameLabelCount; i++){
				ob = arrFrameLabel[i];
				str += "\nFrameNum" + i + "：" + ob.FrameNum;
				str += "\nFrameLabel" + i + "：" + ob.FrameLabel;
			}
			return str;
		}
	}
}