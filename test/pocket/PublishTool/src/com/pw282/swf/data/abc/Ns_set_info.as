package com.pw282.swf.data.abc
{
	import com.pw282.swf.data.BaseData;
	import com.pw282.swf.data.EncodedU32;
	
	import flash.utils.ByteArray;
	
	public class Ns_set_info extends BaseData
	{
		public var count:int;
		public var arrNS:Array;
		public function Ns_set_info(bt:ByteArray = null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			count = EncodedU32.read(bt);
			var i:int = 0;
			arrNS = [];
			for(i = 0; i < count; i++){
				arrNS.push(EncodedU32.read(bt));
			}
		}
		override public function write(bt:ByteArray):void{
			EncodedU32.write(bt, count);
			var i:int = 0;
			for(i = 0; i < count; i++){
				EncodedU32.write(bt, arrNS[i]);
			}
		}
		override public function toString():String{
			return "count:" + count + ",arrNS:" + arrNS;
		}
		public function toFullString(arrNamespace:Array):String{
			var fullString:String = "count:" + count;
			var i:int = 0;
			for(i = 0; i < count; i++){
				fullString += "\n\t\t" + arrNamespace[arrNS[i] - 1] + ";";
			}
			return fullString
		}
		public function addToEncryptWords():void{
			
		}
	}
}