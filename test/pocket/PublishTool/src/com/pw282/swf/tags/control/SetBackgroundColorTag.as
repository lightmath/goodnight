package com.pw282.swf.tags.control
{
	import com.pw282.swf.data.RGB;
	import com.pw282.swf.tags.Tag;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class SetBackgroundColorTag extends Tag
	{
		public var rgb:RGB;
		public function SetBackgroundColorTag()
		{
			super();
		}
		override public function parse():void{
			super.parse();
			
			if(!allowChildParse){
				return;
			}
			rgb = new RGB(bt);
		}
		override public function encode():void{
			if(allowChildEncode){
				bt = new ByteArray();
				bt.endian = Endian.LITTLE_ENDIAN;
				rgb.write(bt);
			}
			super.encode();
		}
		override public function toString():String{
			return super.toString() + "\nRGB:" + rgb;
		}
	}
}