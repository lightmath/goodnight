package com.pw282.swf.data
{
	import flash.utils.ByteArray;

	public class FillStyleArray extends BaseData
	{
		public var FillStyleCount:uint;
		public var FillStyleCountExtended:uint;
		public var FillStyles:Vector.<FillStyle>;
		public function FillStyleArray(bt:ByteArray = null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			FillStyleCount = bt.readUnsignedByte();
			if(FillStyleCount == 0xFF){
				FillStyleCountExtended = bt.readUnsignedShort();
			}
			FillStyles = new Vector.<FillStyle>();
			for(var i:int = 0; i < FillStyleCount; i++){
				var fillStyle:FillStyle = new FillStyle(bt);
				FillStyles.push(fillStyle);
			}
		}
		override public function toString():String{
			var strFillStyles:String = "";
			for(var i:int = 0; i < FillStyleCount; i++){
				strFillStyles += "FillStyle" + i + "：" + FillStyles[i];
			}
			return "FillStyleCount:" + FillStyleCount
				+ ",FillStyleCountExtended:" + FillStyleCountExtended
				+ ",FillStyles:" + strFillStyles;
		}
	}
}