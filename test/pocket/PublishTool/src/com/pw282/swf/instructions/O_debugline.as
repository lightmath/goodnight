package com.pw282.swf.instructions
{
	import com.pw282.swf.data.BaseInstruction;
	import com.pw282.swf.data.EncodedU32;
	
	import flash.utils.ByteArray;
	
	
	/**
	 * 
	 * @author pw
	 * @Date：2011-7-22
	 */	
	public class O_debugline extends BaseInstruction
	{
		public var linenum:int;
		public function O_debugline(bt:ByteArray=null)
		{
			super(bt);
			this.opcode = 0xf0;
			this.opcodeName = "debugline";
		}
		override public function read(bt:ByteArray):void{
			this.linenum = EncodedU32.read(bt);
		}
		override public function write(bt:ByteArray):void{
			super.write(bt);
			EncodedU32.write(bt, this.linenum);
		}
		override public function toString():String{
			return super.toString() + linenum;
		}
	}
}