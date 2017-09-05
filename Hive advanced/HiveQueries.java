/*
Jars to be added
----------------
/usr/local/hadoop-2.6.0/share/hadoop/common/lib/slf4j-api-1.7.5.jar
/usr/local/hadoop-2.6.0/share/hadoop/common/hadoop-common-2.6.0.jar
/usr/local/hadoop-2.6.0/share/hadoop/mapreduce/hadoop-mapreduce-client-core-2.6.0.jar
/usr/local/hive/lib/hive-jdbc-0.14.0.jar
/usr/local/hive/lib/libthrift-0.9.0.jar
/usr/local/hive/lib/hive-service-0.14.0.jar
/usr/local/hive/lib/httpclient-4.2.5.jar
/usr/local/hive/lib/httpcore-4.2.5.jar
/usr/local/hive/lib/commons-logging-1.1.3.jar
/usr/local/hive/lib/hive-exec-0.14.0.jar

Daemons
-------
sudo service mysqld start
start-all.sh
hive
Service:
hive --service hiveserver2
*/

package thrift;

import java.sql.SQLException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.DriverManager;

public class HiveQueries {
	private static String driverName = "org.apache.hive.jdbc.HiveDriver";
	/**
	 * @param args
	 * @throws SQLException
	 */

	public static void main(String[] args) throws SQLException {
		try {
			Class.forName(driverName);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.exit(1);
		}

		Connection con = DriverManager.getConnection("jdbc:hive2://localhost:10000/default", "acadgild", "");
		Statement stmt = con.createStatement();
		String tableName = "testHiveDriverTable1";
		stmt.execute("drop table if exists " + tableName);
		//stmt.execute("create table " + tableName + " (key int, value string)");

		// show tables
		/*
		String sql = "show tables '" + tableName + "'";
		System.out.println("Running: " + sql);
		ResultSet res = stmt.executeQuery(sql);
		if (res.next()) {
			System.out.println(res.getString(1));
		}
		*/
		// describe table
		//sql = "describe " + tableName;
		
		String sql = "SELECT * FROM bucketed_emp";
		System.out.println("Running: " + sql);
		ResultSet res = stmt.executeQuery(sql);
		while (res.next()) {
			System.out.println(res.getString(1) + "\t" + res.getString(2) + "\t" + res.getInt(3) + "\t" + res.getString(4));
		}
		
	}
}