package cn.utils.jtools.entity;

import lombok.Data;

import java.io.Serializable;

/**
 * Post data - ParamInfo
 *
 * @author wanglei
 */
@Data
public class ParamInfo implements Serializable, ToJSON {
	private String tableSql;
	private String authorName;
	private String packageName;
	private String returnUtil;
	private String nameCaseType;
	private String tinyintTransType;
	private String dataType;
	private boolean swagger;

	@Data
	public static class NAME_CASE_TYPE {
		public static String CAMEL_CASE = "CamelCase";
		public static String UNDER_SCORE_CASE = "UnderScoreCase";
		public static String UPPER_UNDER_SCORE_CASE = "UpperUnderScoreCase";
	}
}
