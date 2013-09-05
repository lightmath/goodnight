package com.pw282.swf.tags.control
{
	import com.pw282.swf.data.DString;
	import com.pw282.swf.data.KeyWords;
	import com.pw282.swf.tags.Tag;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class FrameLabelTag extends Tag
	{
		public var Name:String;
		public function FrameLabelTag()
		{
			super();
		}
		override public function parse():void{
			super.parse();
			if(!allowChildParse){
				return;
			}
			Name = DString.read(bt);
		}
		override public function encode():void{
			if(allowChildEncode){
				bt = new ByteArray();
				bt.endian = Endian.LITTLE_ENDIAN;
				
				DString.write(bt, Name);
			}
			super.encode();
		}
		override public function toString():String{
			return super.toString() + "\nName:" + Name;
		}
		override public function encrypt():void{
			if(!allowChildEncrypt){
				return;
			}
			Name = KeyWords.encryptStr(Name);
		}
	}
}