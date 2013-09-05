package com.pw282.swf.instructions
{
	import com.pw282.swf.data.BaseInstruction;
	
	import flash.utils.ByteArray;
	
	
	/**
	 * 
	 * @author pw
	 * @Date：2011-7-22
	 */	
	public class O_dxnslate extends BaseInstruction
	{
		public function O_dxnslate(bt:ByteArray=null)
		{
			super(bt);
			this.opcode = 0x07;
			this.opcodeName = "dxnslate";
		}
	}
}