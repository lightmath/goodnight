package com.pw282.swf.data.abc.trait
{
	import com.pw282.swf.data.BaseData;
	import com.pw282.swf.data.EncodedU32;
	
	import flash.utils.ByteArray;
	
	
	/**
	 * 
	 * @author pw
	 * @Date：2011-6-13
	 */	
	public class Trait_class extends BaseData
	{
		public var slot_id:int;
		public var classi:int;
		public function Trait_class(bt:ByteArray=null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			slot_id = EncodedU32.read(bt);
			classi = EncodedU32.read(bt);
		}
		override public function write(bt:ByteArray):void{
			EncodedU32.write(bt, slot_id);
			EncodedU32.write(bt, classi);
		}
		override public function encrypt():void{
//			classi = 1;
		}
		override public function toString():String{
			return "\t Trait_class:"
				+ "\n\t\t  slot_id:" + slot_id
				+ "\n\t\t  classi:" + classi
		}
	}
}