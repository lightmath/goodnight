package com.pw282.swf.tags.control
{
	import com.pw282.swf.data.DString;
	import com.pw282.swf.utils.TagTypes;
	import com.pw282.swf.tags.Tag;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class MetadataTag extends Tag
	{
		public var v:String = "";
		public function MetadataTag()
		{
			v = "<swftool author='pw' e-mail='82376048@qq.com' date='" + new Date().toLocaleString() + "'/>";
			this.tagType = TagTypes.TAG_METADATA;
			super();
		}
		override public function parse():void{
			super.parse();
			
			if(!allowChildParse){
				return;
			}
			v = DString.read(bt);
		}
		override public function encode():void{
			if(allowChildEncode){
				bt = new ByteArray();
				bt.endian = Endian.LITTLE_ENDIAN;
				
				DString.write(bt, v);
			}
			
			super.encode();
		}
		override public function toString():String{
			return super.toString() + "\n" + v;
		}
	}
}