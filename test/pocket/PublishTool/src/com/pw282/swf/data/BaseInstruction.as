package com.pw282.swf.data
{
	import flash.utils.ByteArray;
	
	
	/**
	 * 基础指令
	 * @author pw
	 * @Date：2011-7-22
	 */	
	public class BaseInstruction extends BaseData
	{
		public var bytesAvailable:int = 0;
		public var opcode:int = 0;
		public var opcodeName:String = "---------------";
		public function BaseInstruction(bt:ByteArray = null)
		{
			if(bt)
				bytesAvailable = bt.length - bt.bytesAvailable - 1;
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			
		}
		override public function write(bt:ByteArray):void{
			bt.writeByte(opcode);
		}
		override public function toString():String{
			return "<font color='#ff0000'>" + bytesAvailable + "</font>" + "<font color='#888888'>[0x" + opcode.toString(16) + "]</font>" + opcodeName + "\t\t"
		}
	}
}