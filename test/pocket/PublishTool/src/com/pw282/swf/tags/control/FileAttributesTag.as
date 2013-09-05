package com.pw282.swf.tags.control
{
	import com.pw282.swf.tags.Tag;
	
	import com.pw282.swf.utils.Tools;
	
	public class FileAttributesTag extends Tag
	{
		public var reserved:uint;
		public var useDirectBlit:uint;
		public var useGPU:uint;
		public var gasMetadata:uint;
		public var actionScript3:uint;
		public var reserved1:uint;
		public var useNetwork:uint;
		public var reserved2:int;
		public function FileAttributesTag()
		{
			super();
		}
		override public function parse():void{
			super.parse();
			
			if(!allowChildParse){
				return;
			}
			reserved = Tools.readUBits(bt, 0, 1);
			useDirectBlit = Tools.readUBits(bt, 1, 1);
			useGPU = Tools.readUBits(bt, 2, 1);
			gasMetadata = Tools.readUBits(bt, 3, 1);
			actionScript3 = Tools.readUBits(bt, 4, 1);
			reserved1 = Tools.readUBits(bt, 5, 2);
			useNetwork = Tools.readUBits(bt, 7, 1);
			reserved2 = Tools.readUBits(bt, 8, 24);
			bt.position = 4;
		}
		override public function encode():void{
			if(allowChildEncode){
				Tools.wirteBits(bt, 0, 1, reserved);
				Tools.wirteBits(bt, 1, 1, useDirectBlit);
				Tools.wirteBits(bt, 2, 1, useGPU);
				Tools.wirteBits(bt, 3, 1, gasMetadata);
				Tools.wirteBits(bt, 4, 1, actionScript3);
				Tools.wirteBits(bt, 5, 2, reserved1);
				Tools.wirteBits(bt, 7, 1, useNetwork);
				Tools.wirteBits(bt, 8, 24, reserved2);
				bt.position = 4;
			}
			super.encode();
		}
		override public function toString():String{
			return super.toString() 
				+ "\nreserved：" + reserved 
				+ "\nuseDirectBlit：" + useDirectBlit 
				+ "\nuseGPU：" + useGPU 
				+ "\ngasMetadata：" + gasMetadata 
				+ "\ngasMetadata：" + actionScript3 
				+ "\nreserved1：" + reserved1 
				+ "\nuseNetwork：" + useNetwork 
				+ "\nreserved2：" + reserved2;
		}
	}
}