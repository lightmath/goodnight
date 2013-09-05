package com.pw282.swf.data.abc
{
	import com.pw282.swf.data.BaseData;
	import com.pw282.swf.data.EncodedU32;
	import com.pw282.swf.utils.Tools;
	
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author pw
	 * @Date：2011-6-13
	 */
	public class Metadata_info extends BaseData
	{
		public var name:int;
		public var item_count:int;
		public var arrItem_infos:Array;
		public function Metadata_info(bt:ByteArray = null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			name = EncodedU32.read(bt);
			item_count = EncodedU32.read(bt);
			var i:int = 0;
			arrItem_infos = [];
			for(i = 0; i < item_count; i++){
				arrItem_infos.push(new Item_info(bt));
			}
		}
		override public function write(bt:ByteArray):void{
			EncodedU32.write(bt, name);
			EncodedU32.write(bt, item_count);
//			EncodedU32.write(bt, 99);
			var i:int = 0;
			for(i = 0; i < item_count; i++){
				(arrItem_infos[i] as Item_info).write(bt);
			}
		}
		override public function encrypt():void{
			
		}
		override public function toString():String{
			return "name:" + Tools.abcFile.cpool_info.arrString[name - 1]
				+ ",item_count:" + item_count
				+ ",arrItem:" + arrItem_infos;
		}
	}
}