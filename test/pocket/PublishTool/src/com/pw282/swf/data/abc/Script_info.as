package com.pw282.swf.data.abc
{
	import com.pw282.swf.data.BaseData;
	import com.pw282.swf.data.EncodedU32;
	
	import flash.utils.ByteArray;
	
	
	/**
	 * 
	 * @author pw
	 * @Date：2011-6-14
	 */	
	public class Script_info extends BaseData
	{
		public var init:int = 0;
		public var trait_count:int = 0;
		public var arrTraits:Array = [];
		public function Script_info(bt:ByteArray=null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			init = EncodedU32.read(bt);
			trait_count = EncodedU32.read(bt);
			var i:int = 0;
			arrTraits = [];
			for(i = 0; i < trait_count; i++){
				arrTraits.push(new Traits_info(bt));
			}
		}
		override public function write(bt:ByteArray):void{
			EncodedU32.write(bt, init);
			EncodedU32.write(bt, trait_count);
			var i:int = 0;
			for(i = 0; i < trait_count; i++){
				(arrTraits[i] as Traits_info).write(bt);
			}
		}
		override public function encrypt():void{
			var i:int = 0;
			for(i = 0; i < trait_count; i++){
				(arrTraits[i] as Traits_info).encrypt();
			}
		}
		override public function toString():String{
			return "init:" + init
				+ ",trait_count:" + trait_count
				+ ",arrTraits:" + arrTraits
		}
	}
}