/*
* Copyright (c) 2006-2007 Erin Catto http://www.gphysics.com
*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*/

package z_spark.coper
{
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	

	public class FileCoper
	{
		private var _numResCopied:uint=0;
		public function FileCoper(){}
		
		public function copy(itemArr:Array):void{
			checkStatus(itemArr);
			
			TextOutputter.ins.warning("开始拷贝...");
			var tf:TextField=TextOutputter.ins.info("");
			var _curIndex:uint=0;
			
			copy_();
			function copy_():void{
				var item:ConfigFileItem=itemArr[_curIndex] as ConfigFileItem;
				item.forEachExe(copyFile);
				_curIndex++;
				tf.htmlText="条目进度："+_curIndex+"/"+ConfigFileItem.totalItemCount+"		资源进度："+_numResCopied+'/'+ConfigFileItem.totalResCount;
				if(_curIndex>=itemArr.length){
					TextOutputter.ins.warning("拷贝完成！");
					return;
				}
				else{
					setTimeout(copy_,Constance.CLEARANCE);
				}
			}
		}
		
		private function checkStatus(itemArr:Array):void{
			//check path first
			if(itemArr.length==0)throw new Error("传入的数组没有内容！");
			if(ConfigParser.root =='' || ConfigParser.target=="")
				throw new Error("必要路径信息尚未配置，可能配置表少配，请检查！");
		}
		
		private function copyFile(relativePath:String,fileName:String):void
		{
			_numResCopied++;
			var barr:ByteArray=Utils.readByteArray(ConfigParser.root+relativePath+fileName);
			Utils.writeByteArray(ConfigParser.target+relativePath+fileName,barr);
		}
	}
}