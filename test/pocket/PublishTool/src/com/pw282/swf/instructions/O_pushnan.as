package com.pw282.swf.instructions
{
	import com.pw282.swf.data.BaseInstruction;
	
	import flash.utils.ByteArray;
	
	
	/**
	 * 
	 * @author pw
	 * @Date：2011-7-22
	 */	
	public class O_pushnan extends BaseInstruction
	{
		public function O_pushnan(bt:ByteArray=null)
		{
			super(bt);
			this.opcode = 0x28;
			this.opcodeName = "pushnan";
		}
	}
}