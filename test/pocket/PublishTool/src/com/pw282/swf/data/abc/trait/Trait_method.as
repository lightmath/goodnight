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
	public class Trait_method extends BaseData
	{
		public var disp_id:int;
		public var method_v:int;
		public function Trait_method(bt:ByteArray=null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			disp_id = EncodedU32.read(bt);
			method_v = EncodedU32.read(bt);
		}
		override public function write(bt:ByteArray):void{
			EncodedU32.write(bt, disp_id);
			EncodedU32.write(bt, method_v);
		}
		override public function toString():String{
			return "\t Trait_method"
				+ "\n\t\t  disp_id:" + disp_id
				+ "\n\t\t  method_v:" + method_v
		}
	}
}