package cn.utils.jtools.entity;

import lombok.Data;

import java.io.Serializable;

/**
 * @author ：wanglei
 * @create ：2020-07-29 15:44
 * @description：
 */
@Data
public class SignDTO  implements Serializable, ToJSON {
	private String appKey;
	private String area;
}
