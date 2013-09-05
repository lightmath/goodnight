package com.pw282.swf.instructions
{
	import com.pw282.swf.data.BaseInstruction;
	
	import flash.utils.ByteArray;
	
	
	/**
	 * 
	 * @author pw
	 * @Date：2011-7-22
	 */	
	public class O_pushbyte extends BaseInstruction
	{
		public var byte_value:int = 0;
		public function O_pushbyte(bt:ByteArray=null)
		{
			super(bt);
			this.opcode = 0x24;
			this.opcodeName = "pushbyte";
		}
		override public function read(bt:ByteArray):void{
			this.byte_value = bt.readUnsignedByte();
		}
		override public function write(bt:ByteArray):void{
			super.write(bt);
			bt.writeByte(byte_value);
		}
		override public function toString():String{
			return super.toString() + byte_value;
		}
	}
}