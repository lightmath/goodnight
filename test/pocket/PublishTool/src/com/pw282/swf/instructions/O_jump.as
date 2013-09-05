package com.pw282.swf.instructions
{
	import com.pw282.swf.data.BaseInstruction;
	import com.pw282.swf.utils.Tools;
	
	import flash.utils.ByteArray;
	
	
	/**
	 * 
	 * @author pw
	 * @Date：2011-7-22
	 */	
	public class O_jump extends BaseInstruction
	{
		public var offset:int = 0;
		public function O_jump(bt:ByteArray=null)
		{
			super(bt);
			this.opcode = 0x10;
			this.opcodeName = "jump";
		}
		override public function read(bt:ByteArray):void{
			offset = Tools.readS24(bt);
		}
		override public function write(bt:ByteArray):void{
			super.write(bt);
			Tools.writeS24(bt, offset);
		}
		override public function toString():String{
			return super.toString() + "<font color='#0033FF'>" + offset + "</font>";
		}
	}
}