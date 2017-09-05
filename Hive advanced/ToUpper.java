package udf;

import org.apache.hadoop.hive.ql.exec.UDF;

public class ToUpper extends UDF{
	public String evaluate (String input) {
		if (input == null) {
			return null;
		}
		return input.toUpperCase();
	}
	
	public String evaluate (String input1, String input2) {
		if (input1 == null && input2 == null) {
			return null;
		}
		return input1.toUpperCase() + "," + input2.toUpperCase();
	}
}
