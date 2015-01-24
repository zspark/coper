/*
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
	public class Constance
	{
		public static const EXT_ALL:String='*';
		public static const ROOT:String="root";
		public static const TARGET:String="target";
		public static const COMMET_MARK:String='#';
		
		public static const MARK_BIG_BRACKET:String='{';
		public static const MARK_BIG_BRACKET_RIGHT:String='}';
		public static const MARK_BACK_SLASH:String='\\';
		public static const MARK_V_LINE:String='|';
		public static const MARK_COLON:String=':';
		public static const MARK_WAVE:String='~';
		public static const MARK_DOT:String='.';
		public static const FILE_BREAKER:RegExp=/\r\n|\r|\n/;
		
		public static const MAX_TF_COUNT:uint=500;
		
		public static const CLEARANCE:uint=100;//每两条Item拷贝的时间间隔（ms）；
		
		//color
		public static const RED:String="#FF0000";
		public static const BLUE:String="#0000FF";
		public static const GREEN:String="#00FF00";
		public static const BLACK:String="#000000";
		public static const WHITE:String="#FFFFFF";
		public static const GRAY:String="#888888";
		public static const YELLOW:String="#FFFF00";
	}
}