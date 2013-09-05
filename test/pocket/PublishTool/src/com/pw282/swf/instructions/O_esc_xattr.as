package com.pw282.swf.instructions
{
	import com.pw282.swf.data.BaseInstruction;
	
	import flash.utils.ByteArray;
	
	
	/**
	 * 
	 * @author pw
	 * @Date：2011-7-22
	 */	
	public class O_esc_xattr extends BaseInstruction
	{
		public function O_esc_xattr(bt:ByteArray=null)
		{
			super(bt);
			this.opcode = 0x72;
			this.opcodeName = "esc_xattr";
		}
	}
}