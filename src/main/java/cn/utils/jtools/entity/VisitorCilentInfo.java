package cn.utils.jtools.entity;

import lombok.Data;

import java.io.Serializable;
import java.util.Date;

/**
 * @author ：wanglei
 * @create ：2020-07-20 18:02
 * @description：
 */
@Data
public class VisitorCilentInfo implements Serializable,ToJSON {

	private static final long serialVersionUID = 1L;

	/**
	 * id
	 */
	private Long id;

	/**
	 * 真实ip
	 */
	private String realIp;

	/**
	 * 来源网址
	 */
	private String referer;

	/**
	 * user-agent
	 */
	private String userAgent;

	/**
	 * 是否移动端
	 */
	private boolean isMobile;

	/**
	 * cookie
	 */
	private String cookie;

	/**
	 * 平台
	 */
	private String platform;

	/**
	 * 浏览器
	 */
	private String browser;

	/**
	 * 系统
	 */
	private String os;

	/**
	 * 生产代码参数
	 */
	private String paramInfo;

	private Date createTime;

	public VisitorCilentInfo() {
	}

}
