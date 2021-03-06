package cn.utils.jtools.entity;

import lombok.Data;

import java.io.Serializable;

/**
 * common return
 * @author wanglei 2015-12-4 16:32:31
 */
@Data
public class ReturnT<T> implements Serializable {
	public static final long serialVersionUID = 42L;

	public static final int SUCCESS_CODE = 200;
	public static final int FAIL_CODE = 500;
	public static final ReturnT<String> SUCCESS = new ReturnT<>(null);
	public static final ReturnT<String> FAIL = new ReturnT<>(FAIL_CODE, null);
	
	private int code;
	private String msg;
	private T data;
	
	public ReturnT(int code, String msg) {
		this.code = code;
		this.msg = msg;
	}
	public ReturnT(T data) {
		this.code = SUCCESS_CODE;
		this.data = data;
	}
	
}
